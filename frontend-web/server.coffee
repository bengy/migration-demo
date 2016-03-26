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
app.use (req, res) -> res.redirect "/"
app.listen (port = process.env.PORT or 4000)
console.log "Server started on http://localhost:#{port}"
