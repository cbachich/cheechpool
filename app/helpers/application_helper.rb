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

  def get_league_user_player(user,league)
    player_id = LeagueUser.find_by_user_id_and_league_id(user.id,league.id).player_id
    Player.find(player_id)
  end
end
