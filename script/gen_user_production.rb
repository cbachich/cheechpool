laura = Player.find_by_name("Laura")
survivor = League.find_by_name("Survivor - Caramoan")

cheech = User.create(name: "Cheech", email: "cbachich@gmail.com", password: "foobar", password_confirmation: "foobar")
cheech.admin = true
cheech.save

cheech_league = LeagueUser.create(league_id: survivor.id, user_id: cheech.id)
cheech_league.admin = true
cheech_league.player_id = laura.id
cheech_league.save

cheech.active_league_id = survivor.id
cheech.save

cheech_smack = cheech.smacks.create(content: "Welcome to CheechPool hosting this year's Survivor - Caramoan!")
cheech_smack.league_id = survivor.id
cheech_smack.save

cheech_smack = cheech.smacks.create(content: "Make sure to post some smack and here, but about each other and not the website! I'll ban anyone saying anything bad about CheechPool!")
cheech_smack.league_id = survivor.id
cheech_smack.save

cheech_smack = cheech.smacks.create(content: "Just kidding!")
cheech_smack.league_id = survivor.id
cheech_smack.save

cheech_smack = cheech.smacks.create(content: "Or am I? <_<")
cheech_smack.league_id = survivor.id
cheech_smack.save
