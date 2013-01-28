league = League.create(name: "Survivor - Caramoan")

bikal = league.teams.create(name: "Bikal", start_week: 1, image_url: "http://wwwimage.cbsstatic.com/base/files/styles/596xh/public/101917_d24774.jpg")

gota = league.teams.create(name: "Gota", start_week: 1, image_url: "http://wwwimage.cbsstatic.com/base/files/styles/596xh/public/101917_d01507.jpg")

andrea = bikal.players.create(name: "Andrea", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/136x170/public/cast/brandon_hantz.jpg", league_id: league.id)

brandon = bikal.players.create(name: "Brandon", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/136x170/public/cast/brandon_hantz.jpg", league_id: league.id)

laura = gota.players.create(name: "Laura", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/136x170/public/cast/laura_alexander.jpg", league_id: league.id)

sherri = gota.players.create(name: "Sherri", image_url: "http://wwwimage.cbsstatic.com/base/files/styles/136x170/public/cast/sherri_biethman.jpg", league_id: league.id)
