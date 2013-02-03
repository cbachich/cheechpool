league = League.create(name: "Survivor - Caramoan")

Challenge.create(name: "Elimination")
Challenge.create(name: "Reward")
Challenge.create(name: "Immunity")
Challenge.create(name: "Winner")

bikal = league.teams.create(name: "Bikal", start_week: 1, image_url: "http://wwwimage.cbsstatic.com/base/files/styles/596xh/public/101917_d24774.jpg")

gota = league.teams.create(name: "Gota", start_week: 1, image_url: "http://wwwimage.cbsstatic.com/base/files/styles/596xh/public/101917_d01507.jpg")

bikal.players.create(name: "Andrea", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/136x170/public/cast/andrea_boehlke.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203513/", league_id: league.id)

bikal.players.create(name: "Brandon", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/136x170/public/cast/brandon_hantz.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203520/", league_id: league.id)

gota.players.create(name: "Laura", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/136x170/public/cast/laura_alexander.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203573/", league_id: league.id)

gota.players.create(name: "Sherri", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/136x170/public/cast/sherri_biethman.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203577/", league_id: league.id)
