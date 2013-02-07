laura = Player.find_by_name("Laura")
andrea = Player.find_by_name("Andrea")

cheech = User.create(name: "Cheech", email: "cbachich@gmail.com", password: "foobar", password_confirmation: "foobar")
cheech.admin = true
cheech.save

bob = User.create(name: "Bob Burger", email: "bob@burger.com", password: "foobar", password_confirmation: "foobar")

survivor = League.find_by_name("Survivor - Caramoan")


cheech_league = LeagueUser.create(league_id: survivor.id, user_id: cheech.id)
cheech_league.admin = true
cheech_league.player_id = laura.id
cheech_league.save

cheech.active_league_id = survivor.id
cheech.save

bob_league = LeagueUser.create(league_id: survivor.id, user_id: bob.id)
bob_league.player_id = andrea.id
bob_league.save

bob.active_league_id = survivor.id
bob.save

cheech_smack = cheech.smacks.create(content: "Oh my God! You killed Kyle!")
cheech_smack.league_id = survivor.id
cheech_smack.save

bob_smack = bob.smacks.create(content: "You bastard!")
bob_smack.league_id = survivor.id
bob_smack.save
