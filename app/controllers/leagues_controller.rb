class LeaguesController < ApplicationController
  include LeaguesHelper

  before_filter :signed_in_user
  before_filter :admin_user, only: :admin
  
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
  end

  def make_picks
    if picksheet_closed?
      flash[:error] = "Sorry but picks are closed for this week"
      redirect_to picksheet_path
      return
    end

    @league = active_league

    if !picksheet_form_errors
      current_user.save_picks
      flash[:success] = "Picksheet submitted!"
    end
    
    redirect_to picksheet_path
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
      @players = get_this_weeks_players(@league,@week_number)

      # Extract data for the overall table
      @user_scores = get_user_scores(@league,@week_number)

      # Extract data for the week table
      @challenges = @league.picksheets.find_by_week(@week_number).challenges
      @user_picks_table = create_user_pick_table
    end
  end

  def admin
    league = active_league
    @week = active_week

    if !picksheet_closed?
      @users = league.users
    else
      @week -= 1 if !picksheet_closed?
      @challenges = league.picksheets.find_by_week(@week).challenges
      @players = get_this_weeks_players(league,@week)
      @teams = league.teams
    end
  end

  def move_week
    league = active_league
    week = active_week
    challenges = league.challenges_for_week(week)

    # Start by grabbing this weeks results
    eliminated_players = []
    winners = []
    error = false
    challenges.each do |challenge|
      if challenge.name == "Elimination"
        eliminated_players = get_eliminated_players(league,week)
        error = true if eliminated_players.empty?
      else
        winner = get_winner(challenge)
        if winner.nil?
          error = true
        else
          winners << {challenge: challenge, team: winner} if !winner.nil?
        end
      end
    end

    # Verify selections in Week Results have been made
    if error
      flash[:error] = "Week Results is not complete"
      redirect_to admin_path
      return
    end

    # Get the new challenges for next week
    new_challenges = get_new_challenges
    
    # Finally get the cut off time
    cutoff_date = get_cutoff_date
    
    # Verify selections in Next Week have been made
    if new_challenges.empty? || cutoff_date.nil?
      flash[:error] = "Next Week is not complete"
      redirect_to admin_path
      return
    end
    
    # If we get to this point, everything is ready and the week can be pushed
    # forward
    league.set_results(eliminated_players, winners) 
    league.move_week(cutoff_date, new_challenges)
    
    redirect_to admin_path
  end

  def close_picksheet
    active_league.close_picksheet_now
    redirect_to admin_path
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

    def get_this_weeks_players(league,week)
      players = []
      league.players.each do |player|
        players << player if player.voted_out_week.nil? || (player.voted_out_week >= week) 
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
          @pick_values << get_this_weeks_players(@league,@week_number)
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

    def picksheet_form_errors
      same_value_errors = ""
      bad_value_errors = ""
      used_values = {}
      league = active_league
      players = league.players_left
      user = current_user

      # Start by checking the number fields for player elimination
      players.each do |player|
        value = params["elim_#{player.id}"].to_i
        
        # If the value is zero then the user didn't input a value
        # or they entered a non numerical number
        if (value == 0) || (value > players.count)
          bad_value_errors += "(#{player.name})"
        end

        if used_values[value].nil?
          used_values.merge!(value => player)
        else
          same_value_errors += "(#{player.name} and #{used_values[value].name} have #{value}) "
        end

        user.set_temporary_player_pick_value(player,value)
      end

      # Next verify there is input in the reward/immunity challenges
      selection_errors = ""
      league.current_challenges.each do |challenge|
        if challenge.name != "Elimination"
          team_id = params["select_#{challenge.id}"]
          if !team_id.nil?
            team = Team.find(team_id.to_i)
            user.set_temporary_team_selection(challenge,team)
          else
            selection_errors += "(#{challenge.name}) "
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
          same_value_errors + " "
      end

      if !selection_errors.empty?
        error_output += 
          "No selection made the following: " +
          selection_errors
      end

      if !error_output.empty?
        flash[:error] = "Sorry! " + error_output
      end

      !error_output.empty?
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

    def get_user_scores(league,weeks)
      user_scores = []
      total_score_ordered_users(league).each do |user|
        scores = []
        for i in 1..weeks
          scores << user_week_score(user,league,i)
        end
        scores << user_total_score(user,league)
        user_scores << {name: user.name, scores: scores}
      end
      user_scores
    end

    def get_eliminated_players(league, week)
      players = get_this_weeks_players(league,week)
      eliminated_players = []
      players.each do |player|
        if !params["eliminated_#{player.id}"].nil?
          eliminated_players << player
        end
      end
      eliminated_players
    end

    def get_winner(challenge)
      team_id = params["team_selection_#{challenge.name}"]
      if !team_id.nil?
        Team.find(team_id)
      else
        nil
      end
    end

    def get_new_challenges
      challenges = []
      if !params['next_week_elimination'].nil?
        challenges << "Elimination"
      end
      if !params['next_week_reward'].nil?
        challenges << "Reward"
      end
      if !params['next_week_immunity'].nil?
        challenges << "Immunity"
      end
      challenges
    end

    def get_cutoff_date
      year = params['year'].to_i
      month = params['month'].to_i
      day = params['day'].to_i
      hour = params['hour'].to_i

      if !((year<1) || (month<1) || (day<1) || (hour<1))
        DateTime.civil(year,month,day,hour)
      else
        nil
      end
    end
end
