league = League.create(name: "Survivor - Caramoan")

Challenge.create(name: "Elimination")
Challenge.create(name: "Reward")
Challenge.create(name: "Immunity")
Challenge.create(name: "Winner")

bikal = league.teams.create(name: "Bikal", start_week: 1, image_url: "http://wwwimage.cbsstatic.com/base/files/styles/596xh/public/101917_d24774.jpg")

gota = league.teams.create(name: "Gota", start_week: 1, image_url: "http://wwwimage.cbsstatic.com/base/files/styles/596xh/public/101917_d01507.jpg")

bikal.players.create(name: "Andrea", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/136x170/public/cast/andrea_boehlke.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203513/", league_id: league.id)

bikal.players.create(name: "Brandon", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/136x170/public/cast/brandon_hantz.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203520/", league_id: league.id)

bikal.players.create(name: "Brenda", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/brenda_lowe.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203535/", league_id: league.id)

bikal.players.create(name: "Corinne", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/corinne_kaplan.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203539/", league_id: league.id)

bikal.players.create(name: "Dawn", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/dawn_meehan.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203543/", league_id: league.id)

bikal.players.create(name: "Erik", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/erik_reichenbach.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203550/", league_id: league.id)

bikal.players.create(name: "Francesca", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/francesca_hogi.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203554/", league_id: league.id)

bikal.players.create(name: "Cochran", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/john_cochran.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203558/", league_id: league.id)

bikal.players.create(name: "Phillip", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/phillip_sheppard_0.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203564/", league_id: league.id)

bikal.players.create(name: "Malcolm", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/malcolm_freberg.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203568/", league_id: league.id)

gota.players.create(name: "Laura", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/136x170/public/cast/laura_alexander.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203573/", league_id: league.id)

gota.players.create(name: "Sherri", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/136x170/public/cast/sherri_biethman.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203577/", league_id: league.id)

gota.players.create(name: "Matt", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/matt_bischoff_0.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203585/", league_id: league.id)

gota.players.create(name: "Hope", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/hope_driskill.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203589/", league_id: league.id)

gota.players.create(name: "Eddie", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/eddie_fox.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203597/", league_id: league.id)

gota.players.create(name: "Julia", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/julia_landauer.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203601/", league_id: league.id)

gota.players.create(name: "Allie", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/allie_pohevitz.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203605/", league_id: league.id)

gota.players.create(name: "Michael", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/michael_snow.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203609/", league_id: league.id)

gota.players.create(name: "Shamar", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/shamar_thomas.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/203613/", league_id: league.id)

gota.players.create(name: "Reynold", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/102x128/public/cast/reynold_toepfer.jpg", info_url: "http://www.cbs.com/shows/survivor/cast/205502/", league_id: league.id)
