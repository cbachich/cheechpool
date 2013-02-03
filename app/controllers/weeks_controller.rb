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
    @immunity_table = []
    @weeks[0].team_picks.each do |team_pick|
      @immunity_table << [team_pick.team_id]
    end

    # Add player picks to the table
    @weeks.each do |week|
      week.team_picks.each do |team_pick|
        @immunity_table.each do |row|
          if row.first == team_pick.team_id
            row << picked_text(team_pick.picked)
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
