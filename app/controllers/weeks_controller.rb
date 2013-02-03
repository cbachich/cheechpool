class WeeksController < ApplicationController
  def show
    league = League.find(params[:league_id])
    @week_number = params[:week_number].to_i
    @weeks = league.weeks.find_all_by_number(@week_number)
    @users = league.users
    @player_table = create_player_table
    @reward_table = create_team_table("Reward")
    @immunity_table = create_team_table("Immunity")
    @score_table = create_score_table
  end
  
  private

    def create_player_table
      # Add all of the players to the initial column
      player_table = []
      @weeks[0].player_picks.each do |player_pick|
        if voted_out(player_pick.player_id)
          player_table << [true, player_pick.player_id]
        else
          player_table << [false, player_pick.player_id]
        end
      end
 
      # Add player picks to the table
      @weeks.each do |week|
        week.player_picks.each do |player_pick|
          player_table.each do |row|
            if row[1] == player_pick.player_id
              if player_pick.value.nil?
                row << picked_text(player_pick.picked)
              else
                row << player_pick.value
              end
            end
          end
        end
      end

      player_table
    end

    def voted_out(player_id)
      player = Player.find(player_id)
      player.voted_out_week == @week_number
    end

    def create_team_table(challenge)
      # Add all of the teams to the initial column
      challenge_id = Challenge.find_by_name(challenge)
      team_picks = @weeks[0].team_picks.find_all_by_challenge_id(challenge_id)
      team_table = []
      team_picks.each do |team_pick|
        if team_won(team_pick.team_id, @week_number, challenge_id)
          team_table << [true, team_pick.team_id]
        else
          team_table << [false, team_pick.team_id]
        end
      end

      # Add picked values to the correct teams
      @weeks.each do |week|
        team_picks = week.team_picks.find_all_by_challenge_id(challenge_id)
        team_picks.each do |team_pick|
          team_table.each do |row|
            if row[1] == team_pick.team_id
              row << picked_text(team_pick.picked)
            end
          end
        end
      end

      team_table
    end

    def team_won(team_id,week,challenge_id)
      !TeamWin.find_by_team_id_and_week_and_challenge_id(team_id,week,challenge_id).nil?
    end

    def create_score_table
      player = Player.find_by_voted_out_week(@week_number)
      team_wins = TeamWin.find_all_by_week(@week_number)

      score_table = []
      @weeks.each do |week|
        player_value = player_value(week,player)
        player_score = adjusted_value(player_value,week.player_picks.count)
        team_wins.each do |team_win|
          player_score += 10 if team_picked(week,team_win)
        end
        score_table << player_score
      end

      score_table
    end

    def player_value(week,player)
      week.player_picks.find_by_player_id(player.id).value
    end

    def adjusted_value(player_value,num_of_players)
      ((num_of_players - player_value) * (20.0 / (num_of_players - 1))).round
    end

    def team_picked(week,team_win)
      week.team_picks.find_by_team_id_and_challenge_id(team_win.team_id,team_win.challenge_id).picked
    end
    
    def picked_text(picked)
      if picked
        "X"
      else
        ""
      end
    end
end
