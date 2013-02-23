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
    score = user.scores.find_by_league_id_and_week(league.id, week)
    if score.nil?
      0
    else
      score.value
    end
  end

  def user_total_score(user,league)
    total = 0
    scores = user.scores.find_all_by_league_id(league.id)
    scores.each do |score|
      total += score.value
    end
    total
  end

  def week_score_ordered_users(league,week)
    sort_users(league,week)
  end

  def total_score_ordered_users(league)
    sort_users(league)
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

  private

    def sort_users(league,week)
      user_scores = []
      league.users.each do |user|
        if week.nil?
          score = user_total_score(user,league)
        else
          score = user_week_score(user,league, week)
        end
        user_scores << { user: user, score: score}
      end

      user_scores.sort! { |a,b| b[:score] <=> a[:score] }

      ordered_users = []
      user_scores.each do |user_score|
        ordered_users << user_score[:user]
      end
      ordered_users
    end

end
