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

################
# Team Results #
################

gota.team_wins.create( week: 1, challenge_id: immunity.id)
bikal.team_wins.create(week: 1, challenge_id: reward.id)

################
# Cheech Picks #
################

# Reward Choice - Gota
cheech.team_picks.create(team_id: gota.id,  picked: true, challenge_id: reward.id, league_id: survivor.id, week: 1)
cheech.team_picks.create(team_id: bikal.id, picked: false, challenge_id: reward.id, league_id: survivor.id, week: 1)

# Immunity Choice - Gota
cheech.team_picks.create(team_id: gota.id,  picked: false, challenge_id: immunity.id, league_id: survivor.id, week: 1)
cheech.team_picks.create(team_id: bikal.id, picked: true, challenge_id: immunity.id, league_id: survivor.id, week: 1)


# Player Values - Laura voted out
cheech.player_picks.create(player_id: andrea.id,  value: 1, challenge_id: elimination.id, league_id: survivor.id, week: 1)
cheech.player_picks.create(player_id: brandon.id, value: 2, challenge_id: elimination.id, league_id: survivor.id, week: 1)
cheech.player_picks.create(player_id: laura.id,   value: 3, challenge_id: elimination.id, league_id: survivor.id, week: 1)
cheech.player_picks.create(player_id: sher.id,    value: 4, challenge_id: elimination.id, league_id: survivor.id, week: 1)

#############
# Bob Picks #
#############

# Reward Choice - Bikal
bob.team_picks.create(team_id: gota.id,  picked: false, challenge_id: reward.id, league_id: survivor.id, week: 1)
bob.team_picks.create(team_id: bikal.id, picked: true, challenge_id: reward.id, league_id: survivor.id, week: 1)

# Immunity Choice - Gota
bob.team_picks.create(team_id: gota.id,  picked: true, challenge_id: immunity.id, league_id: survivor.id, week: 1)
bob.team_picks.create(team_id: bikal.id, picked: false, challenge_id: immunity.id, league_id: survivor.id, week: 1)

# Player Values - Laura voted out
bob.player_picks.create(player_id: andrea.id,  value: 4, challenge_id: elimination.id, league_id: survivor.id, week: 1)
bob.player_picks.create(player_id: brandon.id, value: 2, challenge_id: elimination.id, league_id: survivor.id, week: 1)
bob.player_picks.create(player_id: laura.id,   value: 1, challenge_id: elimination.id, league_id: survivor.id, week: 1)
bob.player_picks.create(player_id: sher.id,    value: 3, challenge_id: elimination.id, league_id: survivor.id, week: 1)
