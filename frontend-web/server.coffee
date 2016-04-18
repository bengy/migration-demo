# Landing page
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Dependancies
# ------------------------------
express = require "express"
bodyParser = require "body-parser"





# App
# ------------------------------
app = express()
app.use express.static __dirname + "/dist"
app.use bodyParser.json()
app.use bodyParser.urlencoded {extended: true}
app.get "/api/v1/events", (req, res) ->
	res.json [1..10].map (i) -> {"id": "#{i}", "name":"Test", "desc":"Test", "to":1459045020000, "from":1459045020000}
app.listen (port = process.env.PORT or 4000)
console.log "Server started on http://localhost:#{port}"
