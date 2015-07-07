StateModel = require 'lib/state_model'


module.exports = class Auth extends StateModel

    initialize: ->
        @alert     = new Bacon.Bus()
        @recover   = new Bacon.Bus()
        @isBusy    = new Bacon.Bus()
        @success   = new Bacon.Bus()
        @sendReset = new Bacon.Bus()

        @add 'alert', @alert.toProperty()
        @add 'recover', @recover.startWith(false).toProperty()

        @sendReset.onValue @sendResetSubmit


    signinSubmit: (form) =>
        @isBusy.push true

        data = JSON.stringify password: form.password
        req = Bacon.fromPromise $.post form.action, data
        @isBusy.plug req.mapEnd false

        @alert.plug req.mapError
            status:  'error'
            title:   'wrong password title'
            message: 'wrong password message'

        @success.plug req.map '.success'


    sendResetSubmit: =>
        reset = Bacon.fromPromise $.post '/login/forgot'

        @alert.plug reset.map
            status:  'success'
            title:   'recover sent title'
            message: 'recover sent message'

