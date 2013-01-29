cheech = User.find_by_name("Cheech")
bob = User.find_by_name("Bob Burger")
survivor = League.find_by_name("Survivor - Caramoan")
gota = Team.find_by_name("Gota")
bikal = Team.find_by_name("Bikal")
andrea = Player.find_by_name("Andrea")
brandon = Player.find_by_name("Brandon")
laura = Player.find_by_name("Laura")
sher = Player.find_by_name("Sherri")

################
# Cheech Picks #
################

# Week 1 - Team Choice - Gota
cheech.team_picks.create(league_id: survivor.id, week: 1, picked: true, team_id: gota.id)
cheech.team_picks.create(league_id: survivor.id, week: 1, picked: false, team_id: bikal.id)

# Week 2 - Team Choice - Bikal
cheech.team_picks.create(league_id: survivor.id, week: 2, picked: false, team_id: gota.id)
cheech.team_picks.create(league_id: survivor.id, week: 2, picked: true, team_id: bikal.id)

# Week 3 - Team Choice - Gota
cheech.team_picks.create(league_id: survivor.id, week: 3, picked: true, team_id: gota.id)
cheech.team_picks.create(league_id: survivor.id, week: 3, picked: false, team_id: bikal.id)

# Week 1 - Player Values - Laura voted out
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 1, player_id: andrea.id)
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 2, player_id: brandon.id)
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 3, player_id: laura.id)
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 4, player_id: sher.id)

# Week 2 - Player Values - Andrea voted out
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 2, player_id: andrea.id)
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 3, player_id: brandon.id)
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 1, player_id: sher.id)

# Week 3 - Player Values - Sher voted out
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 1, player_id: brandon.id)
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 2, player_id: sher.id)

#############
# Bob Picks #
#############

# Week 1 - Team Choice - Bikal
bob.team_picks.create(league_id: survivor.id, week: 1, picked: false, team_id: gota.id)
bob.team_picks.create(league_id: survivor.id, week: 1, picked: true, team_id: bikal.id)

# Week 2 - Team Choice - Bikal
bob.team_picks.create(league_id: survivor.id, week: 2, picked: false, team_id: gota.id)
bob.team_picks.create(league_id: survivor.id, week: 2, picked: true, team_id: bikal.id)

# Week 3 - Team Choice - Bikal
bob.team_picks.create(league_id: survivor.id, week: 3, picked: false, team_id: gota.id)
bob.team_picks.create(league_id: survivor.id, week: 3, picked: true, team_id: bikal.id)

# Week 1 - Player Values - Laura voted out
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 3, player_id: andrea.id)
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 1, player_id: brandon.id)
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 4, player_id: laura.id)
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 2, player_id: sher.id)

# Week 2 - Player Values - Andrea voted out
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 1, player_id: andrea.id)
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 3, player_id: brandon.id)
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 2, player_id: sher.id)

# Week 3 - Player Values - Sher voted out
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 2, player_id: brandon.id)
cheech.player_picks.create(league_id: survivor.id, week: 1, value: 1, player_id: sher.id)
