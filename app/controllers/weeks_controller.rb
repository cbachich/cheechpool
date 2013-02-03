class WeeksController < ApplicationController
  def show
    @league = League.find(params[:league_id])
    @week_number = params[:week_number]
    @weeks = @league.weeks.find_all_by_number(@week_number)
    @users = @league.users

    # Add all of the players to the initial column
    @player_table = []
    @weeks[0].player_picks.each do |player_pick|
      @player_table << [player_pick.player_id]
    end
    
    # Add player picks to the table
    @weeks.each do |week|
      week.player_picks.each do |player_pick|
        @player_table.each do |row|
          if row.first == player_pick.player_id
            if player_pick.value.nil?
              row << picked_text(player_pick.picked)
            else
              row << player_pick.value
            end
          end
        end
      end
    end

    # Add all of the teams to the initial column
    reward_id = Challenge.find_by_name("Reward")
    reward_picks = @weeks[0].team_picks.find_all_by_challenge_id(reward_id)
    @reward_table = []
    reward_picks.each do |reward_pick|
      @reward_table << [reward_pick.team_id]
    end

    # Do the same for immunity
    immunity_id = Challenge.find_by_name("Immunity")
    immunity_picks = @weeks[0].team_picks.find_all_by_challenge_id(immunity_id)
    @immunity_table = []
    immunity_picks.each do |immunity_pick|
      @immunity_table << [immunity_pick.team_id]
    end

    # Add reward and immunity picks to the table
    @weeks.each do |week|

      # Set up Rewards
      reward_picks = week.team_picks.find_all_by_challenge_id(reward_id)
      reward_picks.each do |reward_pick|
        @reward_table.each do |row|
          if row.first == reward_pick.team_id
            row << picked_text(reward_pick.picked)
          end
        end
      end

      # Set up Immunity
      immunity_picks = week.team_picks.find_all_by_challenge_id(immunity_id)
      immunity_picks.each do |immunity_pick|
        @immunity_table.each do |row|
          if row.first == immunity_pick.team_id
            row << picked_text(immunity_pick.picked)
          end
        end
      end
    end
  end
  
  private
    
    def picked_text(picked)
      if picked
        "X"
      else
        ""
      end
    end
end
