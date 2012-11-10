express = require("express")
http = require("http")
path = require("path")
passport = require("passport")
passportConfig = require("./passport-config")
routesConfig = require("./routes-config")
mongoose = require("mongoose")

app = express()
mongoose.connect "mongodb://admin:SPSU2012@ds037817.mongolab.com:37817/anthill"

app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session(secret: "28FFB9ABAB6B0961799D52E171D2E06352B9A0BB8679708A42C98B20AC6680A6")
  app.use passport.initialize()
  app.use passport.session()  
  
  app.use (req, res, next) ->
    messages = req.session.messages || req.session.messages = []
    res.flash = (type, text) ->
      messages.push 
        'type': type
        'text': text
    next()
  app.use (req, res, next) ->
    res.locals.messages = req.session.messages
    next()
  app.use (req, res, next) ->
    res.locals.user = req.user
    next()
  app.use app.router
  app.use express.static(path.join(__dirname, "public"))


app.configure "development", ->
  app.use express.errorHandler()

passportConfig()
routesConfig app

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
