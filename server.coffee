express      = require "express"
server = express()
server.use express.static "build/"
server.listen 5000 or process.env.PORT