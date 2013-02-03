cheech = User.find_by_name("Cheech")
bob = User.find_by_name("Bob Burger")
survivor = League.find_by_name("Survivor - Caramoan")
gota = Team.find_by_name("Gota")
bikal = Team.find_by_name("Bikal")
andrea = Player.find_by_name("Andrea")
brandon = Player.find_by_name("Brandon")
laura = Player.find_by_name("Laura")
sher = Player.find_by_name("Sherri")
elimination = Challenge.find_by_name("Elimination")
reward = Challenge.find_by_name("Reward")
immunity = Challenge.find_by_name("Immunity")
winner = Challenge.find_by_name("Winner")

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

gota.team_wins.create( week: 1, challenge_id: immunity.id)
bikal.team_wins.create(week: 1, challenge_id: reward.id)
bikal.team_wins.create(week: 2, challenge_id: immunity.id)
gota.team_wins.create( week: 2, challenge_id: reward.id)

################
# Cheech Picks #
################

# --------- Week #1 ------------------------
cw1 = cheech.weeks.create(league_id: survivor.id, number: 1, score: 0)

# Reward Choice - Gota
cw1.team_picks.create(team_id: gota.id,  picked: true, challenge_id: reward.id)
cw1.team_picks.create(team_id: bikal.id, picked: false, challenge_id: reward.id)

# Immunity Choice - Gota
cw1.team_picks.create(team_id: gota.id,  picked: false, challenge_id: immunity.id)
cw1.team_picks.create(team_id: bikal.id, picked: true, challenge_id: immunity.id)


# Player Values - Laura voted out
cw1.player_picks.create(player_id: andrea.id,  value: 1, challenge_id: elimination.id)
cw1.player_picks.create(player_id: brandon.id, value: 2, challenge_id: elimination.id)
cw1.player_picks.create(player_id: laura.id,   value: 3, challenge_id: elimination.id)
cw1.player_picks.create(player_id: sher.id,    value: 4, challenge_id: elimination.id)

# --------- Week #2 ------------------------
cw2 = cheech.weeks.create(league_id: survivor.id, number: 2, score: 0)

# Reward Choice - Bikal
cw2.team_picks.create(team_id: gota.id,  picked: false, challenge_id: reward.id)
cw2.team_picks.create(team_id: bikal.id, picked: true, challenge_id: reward.id)

# Immunity Choice - Gota
cw2.team_picks.create(team_id: gota.id,  picked: true, challenge_id: immunity.id)
cw2.team_picks.create(team_id: bikal.id, picked: false, challenge_id: immunity.id)

# Player Values - Andrea voted out
cw2.player_picks.create(player_id: andrea.id,  value: 3, challenge_id: elimination.id)
cw2.player_picks.create(player_id: brandon.id, value: 1, challenge_id: elimination.id)
cw2.player_picks.create(player_id: sher.id,    value: 2, challenge_id: elimination.id)

# --------- Week #3 ------------------------
cw3 = cheech.weeks.create(league_id: survivor.id, number: 3, score: 0)

# Player Choice - Sher
cw3.player_picks.create(player_id: brandon.id, picked: false, challenge_id: winner.id)
cw3.player_picks.create(player_id: sher.id,    picked: true, challenge_id: winner.id)

#############
# Bob Picks #
#############

# --------- Week #1 ------------------------
bw1 = bob.weeks.create(league_id: survivor.id, number: 1, score: 0)

# Reward Choice - Bikal
bw1.team_picks.create(team_id: gota.id,  picked: false, challenge_id: reward.id)
bw1.team_picks.create(team_id: bikal.id, picked: true, challenge_id: reward.id)

# Immunity Choice - Gota
bw1.team_picks.create(team_id: gota.id,  picked: true, challenge_id: immunity.id)
bw1.team_picks.create(team_id: bikal.id, picked: false, challenge_id: immunity.id)

# Player Values - Laura voted out
bw1.player_picks.create(player_id: andrea.id,  value: 4, challenge_id: elimination.id)
bw1.player_picks.create(player_id: brandon.id, value: 2, challenge_id: elimination.id)
bw1.player_picks.create(player_id: laura.id,   value: 1, challenge_id: elimination.id)
bw1.player_picks.create(player_id: sher.id,    value: 3, challenge_id: elimination.id)

# --------- Week #2 ------------------------
bw2 = bob.weeks.create(league_id: survivor.id, number: 2, score: 0)

# Team Choice - Bikal
bw2.team_picks.create(team_id: gota.id,  picked: false, challenge_id: reward.id)
bw2.team_picks.create(team_id: bikal.id, picked: true, challenge_id: reward.id)

# Immunity Choice - Gota
bw2.team_picks.create(team_id: gota.id,  picked: false, challenge_id: immunity.id)
bw2.team_picks.create(team_id: bikal.id, picked: true, challenge_id: immunity.id)

# Player Values - Andrea voted out
bw2.player_picks.create(player_id: andrea.id,  value: 3, challenge_id: elimination.id)
bw2.player_picks.create(player_id: brandon.id, value: 1, challenge_id: elimination.id)
bw2.player_picks.create(player_id: sher.id,    value: 2, challenge_id: elimination.id)

# --------- Week #3 ------------------------
bw3 = bob.weeks.create(league_id: survivor.id, number: 3, score: 0)

# Player Values - Sher wins out
bw3.player_picks.create(player_id: brandon.id, picked: true, challenge_id: winner.id)
bw3.player_picks.create(player_id: sher.id,    picked: false, challenge_id: winner.id)
