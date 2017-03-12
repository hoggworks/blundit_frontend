{ div, a } = React.DOM

# InputsMixin = require("mixins/InputsMixin")

Header = require("components/Header")
Footer = require("components/Footer")

TextField = Material.TextField
RaisedButton = Material.RaisedButton
RefreshIndicator = Material.RefreshIndicator

module.exports = React.createFactory React.createClass
  displayName: 'Forgot Password'
  # mixins: [InputsMixin]

  getInitialState: ->
    inputs:
      email:
        validateEmail: true
        value: ''
    errors: []
    forgotLoading: false
    forgotError: false
    sentRecoveryEmail: false


  goToLogin: ->
    navigate('/login')


  processForgotPassword: ->
    if @validateInputs()
      @setState errors: []
      @setState forgotLoading: true
      params = {
        path: "forgot_password"
        data:
          email: @state.inputs.email.value
        success: @forgotPasswordSuccess
        error: @forgotPasswordError
      }

      API.call(params)


  handleEmailChange: (event) ->
    # console.log event.target.id
    @inputs = @state.inputs
    @inputs.email.value = event.target.value

    @setState inputs : @inputs


  validateInputs: ->
    @errors = []
    if @state.inputs.email.value.length < 6 or @state.inputs.email.value.indexOf("@", 0) == -1 or @state.inputs.email.value.indexOf(".", 0) == -1
      @errors.push { id: "email", text: "Valid Email Required" }

    @setState errors: @errors

    return true if @errors.length == 0
    return false


  getErrorText: (key) ->
    for error in @state.errors
      if error.id == key
        return error.text
    
    return null


  forgotPasswordSuccess: (data) ->
    @setState sentRecoveryEmail: true
    @setState forgotLoading: false


  forgotPasswordError: (error) ->
    @setState forgotLoading: false
    if error.responseJSON? and error.responseJSON.errors?
      @setState forgotError: error.responseJSON.errors[0]

  
  render: ->
    div {},
      Header {}, ''
      div { className: "user-wrapper" },
        div { className: "user-content" },
          "Forgot Password"
          if @state.sentRecoveryEmail == false
            div {},
              div {},
                React.createElement(TextField, { id: "forgot-email", floatingLabelText: "Email", value: @state.inputs.email.value, onChange: @handleEmailChange, errorText: @getErrorText("email") })
              div {},
                if @state.loginLoading == true
                  @style = {
                    display: 'inline-block'
                    position: 'relative'
                    boxShadow: 'none'
                  }
                  React.createElement(RefreshIndicator, { style: @style, size: 50, left: 0, top: 0, status:"loading" })

                else
                  React.createElement(RaisedButton, {label: "Reset Password", primary: true, onClick: @processForgotPassword })
              if @state.forgotError?
                div {},
                  @state.forgotError
              div {},
                "Remembered your password? "
                a
                  onClick: @goToLogin
                  'Click here to login'
          else
            div {},
              "An email with a link to reset your password has been sent to you."
      Footer {}, ''