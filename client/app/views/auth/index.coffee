FeedbackView = require 'views/auth/feedback'


module.exports = class AuthView extends Mn.LayoutView

    tagName: 'form'

    className: ->
        "#{@options.type} auth"

    attributes: ->
        data =
            method: 'POST'
            action: @options.backend

    template: require 'views/templates/view_auth'

    regions:
        'feedback': '.feedback'

    ui:
        passwd: 'input[type=password]'
        submit: '.controls button[type=submit]'


    serializeData: ->
        username: window.username
        prefix:   @options.type


    initialize: () ->
        @options.next   ?= '/'

        @password = @ui.passwd.asEventStream 'focus keyup blur'
                    .map getEventTargetValue
                    .toProperty('')

        form = @$el.asEventStream 'click', @ui.submit
            .doAction '.preventDefault'
            .filter @password.map notEmpty
            .map @password
            .map (password) =>
                password: password
                action:   @options.backend


        form.onValue @model.signinSubmit

    onRender: ->
        @passwd.map isEmpty
            .assign @ui.submit, 'attr', 'aria-disabled'

        @ui.passwd.asEventStream 'focus'
            .assign @ui.passwd[0], 'select'

        @model.isBusy
            .assign @ui.submit, 'attr', 'aria-busy'

        @model.success
            .doAction =>
                setTimeout =>
                    window.location.pathname = @options.next
                , 500
            .map =>
                $ '<i/>',
                    class: 'fa fa-check'
                    text:  t "#{@options.type} auth success"
            .assign @ui.submit, 'html'

        @showChildView 'feedback', new FeedbackView
            forgot: @options.type is 'login'
            prefix: @options.type
            model:  @model

        setTimeout =>
            @ui.passwd.focus()
        , 100

