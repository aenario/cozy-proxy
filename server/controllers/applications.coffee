appManager = require '../lib/app_manager'
{getProxy} = require '../lib/proxy'
localization = require '../lib/localization_manager'

module.exports.app = (req, res, next) ->
    appName = req.params.name
    req.url = req.url.substring "/apps/#{appName}".length
    shouldStart = -1 is req.url.indexOf 'socket.io'
    appManager.ensureStarted appName, shouldStart, (err, port) ->
        if err?
            error = new Error err.msg
            error.status = err.code
            error.template =
                name: if err.code is 404 then 'not_found' else 'error_app'
                params: polyglot: localization.getPolyglot()
            next error
        else
            req.headers['x-cozy-slug'] = appName
            getProxy().web req, res, target: process.env.DOCKPROXY_URL

module.exports.publicApp = (req, res, next) ->
    appName = req.params.name
    req.url = req.url.substring "/public/#{appName}".length
    req.url = "/public#{req.url}"

    shouldStart = -1 is req.url.indexOf 'socket.io'
    appManager.ensureStarted appName, shouldStart, (err, port) ->
        if err?
            error = new Error err.msg
            error.status = err.code
            error.template =
                name: 'error_public'
                params: polyglot: localization.getPolyglot()
            next error
        else
            req.headers['x-cozy-slug'] = appName
            getProxy().web req, res, target: process.env.DOCKPROXY_URL

module.exports.appWithSlash = (req, res) -> res.redirect "#{req.url}/"
