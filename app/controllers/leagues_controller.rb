class LeaguesController < ApplicationController
  include LeaguesHelper

  before_filter :signed_in_user
  before_filter :admin_user, only: [:admin, :modify, :save_changes]
  
  def show
    @league = League.find(params[:id])
    @teams = @league.teams
    @smacks = @league.smacks.paginate(page: params[:page])
  end


  def new
  end

  def new_players
    @league = League.new(name: params["league_name"])
    if @league.save
      for i in 1..2
        @league.teams.create(
          name: params["team_name_#{i}"],
          image_url: params["team_image_#{i}"])
      end
      @team_names = @league.teams.map{|team| team.name }
    else
      redirect_to root_url
    end
  end

  def add_players
    league = League.find(params[:league_id])
    league.add_players(params)
    flash[:success] = "League created: #{league.name}"
    join_league(league, current_user, true)
    redirect_to league
  end

  def modify
    @league = active_league
    @players = @league.players
    @team_names = @league.teams.map{|team| team.name }
  end

  def save_changes
    league = League.find(params[:id])
    league.modify_players(params)
    flash[:success] = "League changes saved"
    redirect_to :back
  end

  def index
    @leagues = League.paginate(page: params[:page])
  end

  def destroy
    League.find(params[:id]).destroy
    current_user.remove_active_league(params[:id])
    flash[:success] = "League destroyed!"
    redirect_to leagues_path
  end

  def add_user
    @league = League.find(params[:id])
    if LeagueUser.exists?(user_id: current_user.id, league_id: @league.id)
      flash[:error] = "User already joined in this league!"
      redirect_to @league
    else
      join_league(@league, current_user, false)
      flash[:success] = "Joined this league!"
      redirect_to root_url
    end
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
    @league = active_league
    @week = @league.current_week
    @week -= 1 if (!picksheet_closed? || @league.finished?)
    
    if @week >= 1
      @players = @league.players_for_week(@week)
      @challenges = @league.challenges_for_week(@week)
    end
  end

  def admin
    @league = active_league
  end

  def finish_season
    league = active_league
    challenges = league.current_challenges

    # Grab the final results
    winner = nil
    challenge_winners = []
    challenges.each do |c|
      if c.name == "Winner"
        if !params["overall_winner"].nil?
          winner = Player.find(params["overall_winner"].to_i) 
          challenge_winners << {challenge: c, players: [winner]}
        else
          flash[:error] = "Overall Winner has no selection"
          redirect_to admin_path
          return
        end
      else
        winners = get_winners(league, c)
        if winners.empty?
          flash[:error] = "#{c.name} has no selection"
          redirect_to admin_path
          return
        end
        challenge_winners << {challenge: c, players: winners}
      end
    end

    # Set the final results for the league
    league.set_final_results(winner, challenge_winners)

    flash[:success] = "Form was completed successfully"
    redirect_to admin_path
  end

  def move_week
    league = active_league
    week = active_week
    challenges = league.challenges_for_week(week)

    # Start by grabbing this weeks results
    eliminated_players = []
    winners = []
    challenge_winners = []
    error = false
    challenges.each do |challenge|
      if challenge.name == "Elimination"
        eliminated_players = get_eliminated_players(league,week)
        error = true if eliminated_players.empty?
      else
        winners = get_winners(league, week, challenge)
        if !winners.empty?
          challenge_winners << {challenge: challenge, objects: winners}
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
    league.set_week_results(eliminated_players, challenge_winners) 
    if finale?
      league.setup_finale(cutoff_date)
    else
      league.move_week(cutoff_date, new_challenges)

      if merged?
        league.merge_teams(params['merge_img_url'])
      end
    end
    
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
      if !players.empty?
        league_user.player_id = players[rand(players.count)].id
        league_user.save
      end
    end

    def get_this_weeks_players(league,week)
      players = []
      league.players.each do |player|
        players << player if player.voted_out_week.nil? || (player.voted_out_week >= week) 
      end
      players
    end

    def picksheet_form_errors
      same_value_errors = ""
      bad_value_errors = ""
      used_values = {}
      league = active_league
      players = league.players_left
      user = current_user

      # Next verify there is input in the reward/immunity challenges
      selection_errors = ""
      league.current_challenges.each do |challenge|
        if challenge.name == "Elimination"
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
        else
          object_id = params["select_#{challenge.id}"]
          if !object_id.nil?
            if challenge.is_players?
              object = Player.find(object_id.to_i)
            else
              object = Team.find(object_id.to_i)
            end
            
            user.set_temporary_selection(challenge,object)
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

    def get_winners(league, challenge)
      winners = []
      if challenge.is_players?
        objects = league.players_left
      else
        objects = league.teams
      end
      
      objects.each do |object|
        if !params["challenge_#{challenge.id}_#{object.id}"].nil?
          winners << object
        end
      end
      winners
    end

    def merged?
      !params['merge'].nil?
    end

    def finale?
      !params['finale'].nil?
    end

    def get_new_challenges
      challenges = []
      if !params['next_week_elimination'].nil?
        challenges << {name: "Elimination", player: true}
      end
      if !params['next_week_reward'].nil?
        challenges << {name: "Reward", player: !params['reward_player'].nil?}
      end
      if !params['next_week_immunity'].nil?
        challenges << {name: "Immunity", player: !params['immunity_player'].nil?}
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
