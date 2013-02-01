cheech = User.find_by_name("Cheech")
bob = User.find_by_name("Bob Burger")
survivor = League.find_by_name("Survivor - Caramoan")
gota = Team.find_by_name("Gota")
bikal = Team.find_by_name("Bikal")
andrea = Player.find_by_name("Andrea")
brandon = Player.find_by_name("Brandon")
laura = Player.find_by_name("Laura")
sher = Player.find_by_name("Sherri")

##################
# Player Results #
##################
laura.voted_out_week = 1
laura.save
andrea.voted_out_week = 2
andrea.save
brandon.voted_out_week = 3
brandon.save
sher.player_wins.create(week: 3)

################
# Team Results #
################

gota.team_wins.create(week: 1)
bikal.team_wins.create(week: 2)

################
# Cheech Picks #
################

# --------- Week #1 ------------------------
cw1 = cheech.weeks.create(league_id: survivor.id, number: 1, score: 0)

# Team Choice - Gota
cw1.team_picks.create(team_id: gota.id,  picked: true)
cw1.team_picks.create(team_id: bikal.id, picked: false)

# Player Values - Laura voted out
cw1.player_picks.create(player_id: andrea.id,  value: 1)
cw1.player_picks.create(player_id: brandon.id, value: 2)
cw1.player_picks.create(player_id: laura.id,   value: 3)
cw1.player_picks.create(player_id: sher.id,    value: 4)

# --------- Week #2 ------------------------
cw2 = cheech.weeks.create(league_id: survivor.id, number: 2, score: 0)

# Team Choice - Bikal
cw2.team_picks.create(team_id: gota.id,  picked: false)
cw2.team_picks.create(team_id: bikal.id, picked: true)

# Player Values - Andrea voted out
cw2.player_picks.create(player_id: andrea.id,  value: 3)
cw2.player_picks.create(player_id: brandon.id, value: 1)
cw2.player_picks.create(player_id: sher.id,    value: 2)

# --------- Week #3 ------------------------
cw3 = cheech.weeks.create(league_id: survivor.id, number: 3, score: 0)

# Player Choice - Sher
cw3.player_picks.create(player_id: brandon.id, picked: false)
cw3.player_picks.create(player_id: sher.id,    picked: true)

#############
# Bob Picks #
#############

# --------- Week #1 ------------------------
bw1 = bob.weeks.create(league_id: survivor.id, number: 1, score: 0)

# Team Choice - Bikal
bw1.team_picks.create(team_id: gota.id,  picked: false)
bw1.team_picks.create(team_id: bikal.id, picked: true)

# Player Values - Laura voted out
bw1.player_picks.create(player_id: andrea.id,  value: 4)
bw1.player_picks.create(player_id: brandon.id, value: 2)
bw1.player_picks.create(player_id: laura.id,   value: 1)
bw1.player_picks.create(player_id: sher.id,    value: 3)

# --------- Week #2 ------------------------
bw2 = bob.weeks.create(league_id: survivor.id, number: 2, score: 0)

# Team Choice - Bikal
bw2.team_picks.create(team_id: gota.id,  picked: false)
bw2.team_picks.create(team_id: bikal.id, picked: true)

# Player Values - Andrea voted out
bw2.player_picks.create(player_id: andrea.id,  value: 3)
bw2.player_picks.create(player_id: brandon.id, value: 1)
bw2.player_picks.create(player_id: sher.id,    value: 2)

# --------- Week #3 ------------------------
bw3 = bob.weeks.create(league_id: survivor.id, number: 3, score: 0)

# Player Values - Sher wins out
bw3.player_picks.create(player_id: brandon.id, picked: true)
bw3.player_picks.create(player_id: sher.id,    picked: false)
