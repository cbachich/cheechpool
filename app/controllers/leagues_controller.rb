class LeaguesController < ApplicationController
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
    user = current_user
    @week_number = active_week

    # Build a picks array based on the challenge types for this week
    challenges = @league.picksheets.find_by_week(@week_number).challenges
    @pick_values = []
    challenges.each_with_index do |challenge, i|
      if challenge.name == 'Preshow'
        @pick_values << get_this_weeks_players
      elsif challenge.name == 'Elimination'
        players = get_this_weeks_players

        player_picks = []
        players.each do |player|
          player_pick = @league.player_picks.find_by_player_id_and_user_id_and_week_and_challenge_id(player.id,user.id,@week_number,challenge.id)
          if player_pick.nil?
            player_picks << ""
          else
            player_picks << player_pick.value
          end
        end

        @pick_values << { challenge: challenge, players: players, player_picks: player_picks }
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

    set_picks(@pick_values)
  end

  def make_picks
    @league = active_league
    @week_number = active_week
    @pick_values = get_picks

    
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
    @league = League.find(params[:league_id])
    @week_number = params[:week_number].to_i

    if @league.current_week < @week_number
      redirect_to "/leagues/#{@league.id}/week/#{@league.current_week}"
      return
    end

    @users = @league.users
    @challenges = @league.picksheets.find_by_week(@week_number).challenges
    @tables = []
    @challenges.each do |challenge|
      if challenge.name == "Elimination"
        @tables << create_player_table
      else
        @tables << create_picked_table(challenge)
      end
    end
    #@reward_table = create_team_table("Reward")
    #@immunity_table = create_team_table("Immunity")
    #@score_table = create_score_table
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

    def create_player_table
      players = get_this_weeks_players

      player_table = []
      players.each_with_index do |player, i|

        # Add the player to the initial column and
        # add a flag to indicate if the player was voted
        # out that week
        if player.voted_out_week == @week_number
          player_table << [true, player.id]
        else
          player_table << [false, player.id]
        end

        @users.each do |user|
          player_pick = user.player_picks.find_by_league_id_and_player_id_and_week_and_picked(@league.id, player.id, @week_number,nil)
          if player_pick.nil?
            player_table[i] << ""
          else
            player_table[i] << player_pick.value
          end
        end
      end

      player_table
    end

    def create_picked_table(challenge)
      picked_table = [challenge.name]
      @users.each do |user|
        team_pick = user.team_picks.find_by_league_id_and_week_and_picked_and_challenge_id(@league.id, @week_number, true, challenge.id)
        if team_pick.nil?
          picked_table << ""
        else
          picked_table << Team.find(team_pick.team_id).image_url
        end
      end

      picked_table
    end

    def get_this_weeks_players
      players = []
      @league.players.each do |player|
        players << player if player.voted_out_week.nil? || (player.voted_out_week >= @week_number) 
      end
      players
    end

    def update_picks
      @pick_values.each_with_index do |pick, pi|
        if pick[:challenge].name == 'Elimination'
          pick[:player_picks].map!.with_index do |player_pick, ppi|
            player_pick = params["eliminations#{ppi}"].to_i
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
      error_ids = []

      # Check the eliminated player values
      @pick_values.each do |pick|
        if pick[:challenge].name == 'Elimination'
          players = pick[:players]
          player_picks = pick[:player_picks]
          players.each_with_index do |player, pi|
            player_pick = pick[:player_picks][pi]

            # If the value is zero then the user didn't input a value
            # or they entered a non numerical number. Inform the user
            # they performed error.
            if (player_pick == 0) || (player_pick > players.count)
              bad_value_errors = bad_value_errors + "(#{player.name})"
            end

            player_picks.each_with_index do |compare_pick, ppi|
              if pi != ppi
                if (compare_pick == player_pick) &&
                  (!error_ids.include? pi)
                  same_value_errors = same_value_errors +"(#{player.name} and #{players[ppi].name} have #{player_pick}) "
                  error_ids << pi
                  error_ids << ppi
                end
              end
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
          pick[:players].each_with_index do |player, i|
            new_pick_value = pick[:player_picks][i]
            # Start by seeing if the player pick already exists
            player_pick = @league.player_picks.find_by_player_id_and_challenge_id_and_week_and_user_id(player.id,challenge.id,@week_number,current_user.id)
            if !player_pick.nil?
              player_pick.value = new_pick_value
            else
              player_pick = @league.player_picks.create(player_id: player.id, value: new_pick_value, challenge_id: challenge.id, week: @week_number, user_id: current_user.id)
            end

            player_pick.save
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
