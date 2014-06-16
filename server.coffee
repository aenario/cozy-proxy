process.env.NODE_ENV ?= "development"

process.on 'uncaughtException', (err) ->
    console.error err.message
    console.error err.stack

# default value for the default port (home)
process.env.DATASYSTEM_HOST = process.env.DATASYSTEM_PORT_9101_TCP_ADDR or 'localhost'
process.env.DATASYSTEM_PORT = process.env.DATASYSTEM_PORT_9101_TCP_PORT or '9101'
process.env.DATASYSTEM_URL = "http://#{process.env.DATASYSTEM_HOST}:#{process.env.DATASYSTEM_PORT}"

process.env.HOME_HOST = process.env.HOME_PORT_9103_TCP_ADDR or 'localhost'
process.env.HOME_PORT = process.env.HOME_PORT_9103_TCP_PORT or process.env.DEFAULT_REDIRECT_PORT or '9103'
process.env.HOME_URL = "http://#{process.env.HOME_HOST}:#{process.env.HOME_PORT}"

process.env.COUCH_HOST = process.env.COUCH_PORT_5984_TCP_ADDR or 'localhost'
process.env.COUCH_PORT = process.env.COUCH_PORT_5984_TCP_PORT or '5984'
process.env.COUCH_URL = "http://#{process.env.COUCH_HOST}:#{process.env.COUCH_PORT}"

process.env.INDEXER_HOST = process.env.INDEXER_PORT_9102_TCP_ADDR or 'localhost'
process.env.INDEXER_PORT = process.env.INDEXER_PORT_9102_TCP_ADDR or '9102'
process.env.INDEXER_URL = "http://#{process.env.INDEXER_HOST}:#{process.env.INDEXER_PORT}"

process.env.CONTROLLER_HOST = process.env.CONTROLLER_PORT_9002_TCP_ADDR or 'localhost'
process.env.CONTROLLER_PORT = process.env.CONTROLLER_PORT_9002_TCP_PORT or '9002'
process.env.CONTROLLER_URL = "http://#{process.env.CONTROLLER_HOST}:#{process.env.CONTROLLER_PORT}"

process.env.DOCKPROXY_HOST = process.env.DOCKPROXY_PORT_8000_TCP_ADDR
process.env.DOCKPROXY_PORT = process.env.DOCKPROXY_PORT_8000_TCP_PORT
process.env.DOCKPROXY_URL = "http://#{process.env.DOCKPROXY_HOST}:#{process.env.DOCKPROXY_PORT}"

console.log process.env

application = module.exports = (callback) ->

    americano = require 'americano'
    initialize = require './server/initialize'
    errorMiddleware = require './server/middlewares/errors'

    options =
        name: 'proxy'
        port: process.env.PORT or 9104
        host: process.env.HOST or "127.0.0.1"
        root: __dirname

    americano.start options, (app, server) ->
        app.use errorMiddleware
        initialize app, server, callback

if not module.parent
    application()