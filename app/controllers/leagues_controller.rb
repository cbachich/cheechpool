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

  def add_user_setup
    @league = League.find(params[:id])
    @players = Player.find_all_by_league_id(@league.id)
  end

  def add_user
    @league = League.find(params[:id])
    if LeagueUser.exists?(user_id: current_user.id, league_id: @league.id)
      flash[:error] = "User already joined in this league!"
    else
      player = Player.find(params[:player_selection])
      league_user = join_league(@league, current_user, false)
      league_user.player_id = player.id
      league_user.save
      flash[:success] = "Joined this league with #{player.name}!"
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

  def scoreboard
    @league = League.find(params[:league_id])
    @week_number = params[:week_number].to_i

    if @league.current_week < @week_number
      redirect_to "/leagues/#{@league.id}/week/#{@league.current_week}"
      return
    end

    @users = @league.users
    @player_table = create_player_table
    #@reward_table = create_team_table("Reward")
    #@immunity_table = create_team_table("Immunity")
    #@score_table = create_score_table
  end

  private

    def join_league(league,user,admin)
      user.active_league_id = league.id
      user.save
      LeagueUser.create(league_id: league.id, user_id: user.id, admin: admin)
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

    def get_this_weeks_players
      players = []
      @league.players.each do |player|
        players << player if player.voted_out_week.nil? || (player.voted_out_week >= @week_number) 
      end
      players
    end
end
