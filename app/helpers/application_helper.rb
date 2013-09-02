module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "CheechPool"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def league_user(user,league)
    LeagueUser.find_by_user_id_and_league_id(user.id,league.id)
  end

  def league_user_player(user, league)
    Player.find(league_user(user, league).player_id)
  end
end
