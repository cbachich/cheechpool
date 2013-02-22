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

  def winner(object, week_number)
    true
  end
end
