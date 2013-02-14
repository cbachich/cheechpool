class LeaguesController < ApplicationController
  
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

  @picks = []

  def picksheet
    @league = active_league
    user = current_user
    week_number = active_week

    # Build a picks array based on the challenge types for this week
    challenges = @league.picksheets.find_by_week(week_number).challenges
    @picks = []
    challenges.each_with_index do |challenge, i|
      if challenge.name == 'Preshow'
        @picks << get_this_weeks_players
      elsif challenge.name == 'Elimination'
        players = get_this_weeks_players

        player_picks = []
        players.each do |player|
          player_pick = @league.player_picks.find_by_player_id_and_user_id_and_week_and_challenge_id(player.id,user.id,week_number,challenge.id)
          if player_pick.nil?
            player_picks << ""
          else
            player_picks << player_pick
          end
        end

        @picks << [challenge.name, players, player_picks]
      else
        teams = Team.find_all_by_league_id(@league.id)

        team_picks = []
        teams.each do |team|
          team_pick = @league.team_picks.find_by_team_id_and_user_id_and_week_and_challenge_id(team.id,user.id,week_number,challenge.id)
          
          if team_pick.nil?
            team_picks << false
          else
            team_picks << team_pick.picked?
          end
        end

        @picks << [challenge.name, teams, team_picks] 
      end
    end

    set_picks(@picks)
  end

  def make_picks
    @league = active_league
    @week_number = active_week
    @picks = get_picks

    error = false
    same_value_errors = ""
    bad_value_errors = ""
    error_ids = []
    @picks.each_with_index do |pick|
      if pick[0] == 'Elimination'
        players = pick[1]
        player_picks = pick[2]
        players.each_with_index do |player, i|
          elim_value = params["eliminations#{i}"].to_i

          # If the value is zero then the user didn't input a value
          # or they entered a non numerical number. Inform the user
          # they performed error.
          if (elim_value == 0) || (elim_value > players.count)
            bad_value_errors = bad_value_errors + "(#{player.name})"
            error = true
          end

          player_picks.each do |player_pick|
            if player.id != player_pick.player_id
              if (player_pick.value == elim_value) &&
                 (!error_ids.include? player.id)
                same_value_errors = same_value_errors +"(#{player.name} and #{Player.find(player_pick.player_id).name} have #{elim_value}) "
                error = true
                error_ids << player.id
                error_ids << player_pick.player_id
              end
            else
              player_pick.value = elim_value
            end
          end
        end
      else
        reward_pick = params[:team_selection[1]]
        immunity_pick = params[:team_selection[2]]
      end
    end

    if error
      error_output = ""
      error_output = "Bad input in player text field: " + bad_value_errors + " " if bad_value_errors != ""

      if same_value_errors != ""
        error_output = error_output + "Players can not have the same value, please correct the following players: "
        error_output = error_output + same_value_errors
      end

      flash[:error] = error_output
      render '/leagues/picksheet'
    else
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
end
