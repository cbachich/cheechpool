module LeaguesHelper

  def picksheet_closed?
    ps_date = active_league.picksheet_close_date
    curr_date = DateTime.current
    if ps_date.nil? || (curr_date > ps_date)
      true
    else
      false
    end
  end

  def user_week_score(user,league,week)
    user.scores.find_by_league_id_and_week(league.id, week).value
  end

  def user_total_score(user,league)
    total = 0
    scores = user.scores.find_all_by_league_id(league.id)
    scores.each do |score|
      total += score.value
    end
    total
  end

  def number_of_players(league,week)
    player_count = 0
    league.players.each do |player|
      player_count += 1 if player.voted_out_week.nil? || (player.voted_out_week >= week) 
    end
    player_count
  end

  def scaled_value(pick_value, num_of_players)
    point_max = 20
    (num_of_players - pick_value) * (point_max / (num_of_players - 1))
  end
end
