class LeaguesController < ApplicationController
  include LeaguesHelper

  before_filter :signed_in_user
  
  def show
    @league = League.find(params[:id])
    @teams = @league.teams
    @smacks = @league.smacks.paginate(page: params[:page])

    if @league.user_in_league(current_user)
      @league_user = LeagueUser.find_by_user_id_and_league_id(current_user.id, @league.id)
    end
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(params[:league])
    if @league.save
      flash[:success] = "League created!"
      join_league(@league, current_user, true)
      redirect_to @league
    else
      render 'new'
    end
  end

  def index
    @leagues = League.paginate(page: params[:page])
  end

  def destroy
    League.find(params[:id]).destroy
    flash[:success] = "League destroyed!"
    redirect_to leagues_path
  end

  def add_user
    @league = League.find(params[:id])
    if LeagueUser.exists?(user_id: current_user.id, league_id: @league.id)
      flash[:error] = "User already joined in this league!"
    else
      join_league(@league, current_user, false)
      flash[:success] = "Joined this league!"
    end
    redirect_to @league
  end

  def remove_user
    @league = League.find(params[:id])
    @user = current_user
    if LeagueUser.exists?(user_id: @user.id, league_id: @league.id)
      LeagueUser.find_by_user_id_and_league_id(@user.id, @league.id).destroy
      if @user.active_league_id == @league.id
        @user.active_league_id = nil
        @user.save
      end
      flash[:success] = "Quit this league!"
    else
      flash[:error] = "User is not in this league!"
    end
    redirect_to @league
  end

  @pick_values = []

  def picksheet
    @league = active_league
    @week_number = active_week
    @pick_values = get_pick_values
    @player_count = get_this_weeks_players.count
  end

  def make_picks
    if picksheet_closed?
      flash[:error] = "Sorry but picks are closed for this week"
      redirect_to picksheet_path
      return
    end

    @league = active_league
    @week_number = active_week
    @pick_values = get_pick_values
    @player_count = get_this_weeks_players.count

    
    # Start by updating all of the fields
    update_picks

    # Verify there were no issues with the eliminated player fields
    error_output = check_eliminated_players
    
    if !error_output.empty?
      flash[:error] = "Sorry! " + error_output
      render '/leagues/picksheet'
    else
      save_picks
      flash[:success] = "Picksheet submitted!"
      redirect_to picksheet_path
    end
  end

  def make_pre_picks
    player = Player.find(params[:player_selection])
    league_user = active_league_user
    league_user.player_id = player.id
    if league_user.save
      flash[:success] = "Changed player pick to #{player.name}"
    else
      flash[:error] = "Pick was not able to be made!"
    end
    redirect_to picksheet_path
  end

  def scoreboard
    @week_number = active_week
    @week_number -= 1 if !picksheet_closed?
    
    if @week_number >= 1
      @league = active_league
      @players = get_this_weeks_players
      @challenges = @league.picksheets.find_by_week(@week_number).challenges

      @user_picks_table = create_user_pick_table
    end
  end

  private

    def join_league(league,user,admin)
      user.active_league_id = league.id
      user.save
      league_user = LeagueUser.create(league_id: league.id, user_id: user.id, admin: admin)
      
      # Select a random player for an initial pick
      players = league.players
      league_user.player_id = players[rand(players.count)].id
      league_user.save
    end

    def create_user_pick_table
      users = week_score_ordered_users(@league, @week_number)

      user_pick_table = []
      users.each do |user|
        contents = []
        @challenges.each do |challenge|
          if challenge.name == "Elimination"
            for value in 1..@players.count
              player_pick = 
                @league.player_picks.
                  find_by_user_id_and_week_and_challenge_id_and_value(
                    user.id,@week_number,challenge.id,value)

              if player_pick.nil?
                cell = ""
              else
                player = Player.find(player_pick.player_id)
                eliminated = player.voted_out_week == @week_number
                cell = { object: player, winner: eliminated }
              end

              contents << cell
            end
          else
            team_pick = 
              @league.team_picks.
                find_by_user_id_and_week_and_challenge_id_and_picked(
                  user.id,@week_number,challenge.id,true)

            if team_pick.nil?
              cell = ""
            else
              team = Team.find(team_pick.team_id)
              winner = 
                !TeamWin.find_by_team_id_and_week_and_challenge_id(
                  team.id,@week_number,challenge.id).nil?

              cell = { object: team, winner: winner}
            end

            contents << cell
          end
          
        end
        user_pick_table << { user: user, contents: contents }
      end

      user_pick_table
    end

    def get_this_weeks_players
      players = []
      @league.players.each do |player|
        players << player if player.voted_out_week.nil? || (player.voted_out_week >= @week_number) 
      end
      players
    end

    def teams_for_week(league,week)
      teams = []
      league.teams.each do |team|
        players = team.players.where("players.voted_out_week IS NULL OR players.voted_out_week > #{week}")
        teams << { team: team, players: players }
      end
      teams
    end

    def get_pick_values
      user = current_user

      # Build a picks array based on the challenge types for this week
      challenges = @league.picksheets.find_by_week(@week_number).challenges
      @pick_values = []
      challenges.each_with_index do |challenge, i|
        if challenge.name == 'Preshow'
          @pick_values << get_this_weeks_players
        elsif challenge.name == 'Elimination'
          teams = teams_for_week(@league,@week_number)

          team_picks = []
          teams.each do |team|
            player_picks = []
            team[:players].each do |player|
              player_pick = @league.player_picks.find_by_player_id_and_user_id_and_week_and_challenge_id(player.id,user.id,@week_number,challenge.id)
              if player_pick.nil?
                player_picks << { player: player, value: "" }
              else
                player_picks << { player: player, value: player_pick.value }
              end
            end
            team_picks << { team: team[:team], player_picks: player_picks }
          end

          @pick_values << { challenge: challenge, team_picks: team_picks }
        else
          teams = Team.find_all_by_league_id(@league.id)

          team_picks = []
          teams.each do |team|
            team_pick = @league.team_picks.find_by_team_id_and_user_id_and_week_and_challenge_id(team.id,user.id,@week_number,challenge.id)
            
            if team_pick.nil?
              team_picks << false
            else
              team_picks << team_pick.picked?
            end
          end

          @pick_values << { challenge: challenge, teams: teams, team_picks: team_picks } 
        end
      end

      @pick_values
    end

    def update_picks
      @pick_values.each_with_index do |pick, pi|
        if pick[:challenge].name == 'Elimination'
          pick[:team_picks].each do |team_pick|
            team_pick[:player_picks].each do |player_pick|
              player_pick[:value] = params["eliminations#{player_pick[:player].id}"].to_i
            end
          end
        else
          team_selection = params["team_selection#{pi}"].to_i
          pick[:team_picks].map!.with_index do |team_pick, tpi|
            if tpi == team_selection
              team_pick = true
            else
              team_pick = false
            end
          end
        end
      end
    end

    def check_eliminated_players
      same_value_errors = ""
      bad_value_errors = ""
      other_players = []

      # Check the eliminated player values
      @pick_values.each do |pick|
        if pick[:challenge].name == 'Elimination'
          pick[:team_picks].each do |team_pick|
            team_pick[:player_picks].each do |player_pick|
              value = player_pick[:value]
              player = player_pick[:player]

              # If the value is zero then the user didn't input a value
              # or they entered a non numerical number. Inform the user
              # they performed error.
              if (value == 0) || (value > @player_count)
                bad_value_errors = bad_value_errors + "(#{player.name})"
              end

              other_players.each do |other_player|
                if value == other_player[:value]
                  same_value_errors = same_value_errors +"(#{player.name} and #{other_player[:name]} have #{value}) "
                end
              end

              other_players << { name: player.name, value: value }
            end
          end
        end
      end

      error_output = ""
      if !bad_value_errors.empty?
        error_output = 
          "Picks must be numbers, please correct the following players: " + 
          bad_value_errors + " "
      end

      if !same_value_errors.empty?
        if !bad_value_errors.empty?
          error_output += "Also, "
        end

        error_output += 
          "Players can not have the same value, " +
          "please correct the following players: " + 
          same_value_errors
      end

      error_output
    end

    def save_picks
      @pick_values.each do |pick|
        challenge = pick[:challenge]
        if challenge.name == "Elimination"
          pick[:team_picks].each do |team_pick|
            team_pick[:player_picks].each do |player_pick|
              value = player_pick[:value]
              player = player_pick[:player]

              # Start by seeing if the player pick already exists
              pick = @league.player_picks.find_by_player_id_and_challenge_id_and_week_and_user_id(player.id,challenge.id,@week_number,current_user.id)
              if !pick.nil?
                pick.value = value
              else
                pick = @league.player_picks.create(player_id: player.id, value: value, challenge_id: challenge.id, week: @week_number, user_id: current_user.id)
              end

              pick.save
            end
          end
        else
          teams = pick[:teams]
          teams.each_with_index do |team,i|
            team_picked = pick[:team_picks][i]
            # Start by seeing if the team pick already exists
            team_pick = @league.team_picks.find_by_team_id_and_challenge_id_and_user_id_and_week(team.id,challenge.id,current_user.id,@week_number)

            if !team_pick.nil?
              team_pick.picked = team_picked
            else
              team_pick = @league.team_picks.create(team_id: team.id, picked: team_picked, challenge_id: challenge.id, user_id: current_user.id, week: @week_number)
            end

            team_pick.save
          end
        end
      end
    end
end
