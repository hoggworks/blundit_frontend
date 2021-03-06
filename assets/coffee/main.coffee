window.React = require('react')
window.ReactDOM = require('react-dom')

require('react-tap-event-plugin')()

RouterMixin = require('react-mini-router').RouterMixin
window.navigate = require('react-mini-router').navigate
window._ = require('lodash')

window.UserStore = UserStore = require("stores/UserStore")
window.API = require("shared/API")
window.global = require("shared/Global")

getMuiTheme = require('material-ui/styles/getMuiTheme').default
deepOrange500 = require('material-ui/styles/colors').deepOrange500
MuiThemeProvider = require('material-ui/styles/MuiThemeProvider').default
window.Material = require("material-ui")

ReactGA = require('react-ga')
ReactGA.initialize('UA-97844495-1')

muiTheme = getMuiTheme(palette: {
  primary1Color: "#4869b2",
  accent1Color: deepOrange500
})

SessionMixin = require("mixins/SessionMixin")

Header = require("./components/Header")
Footer = require("./components/Footer")

{ div } = React.DOM

Blundit = React.createFactory React.createClass
  mixins: [RouterMixin, SessionMixin]

  getInitialState: ->
    verificationComplete: false


  componentWillMount: ->
    @verifyUserToken()


  componentWillUnmount: ->
    # console.log "will componentWillUnmount"


  routes:
    '/': 'landing'
    '/me': 'userProfile'
    '/bookmarks': 'bookmarks'
    '/users': 'users'
    '/users/:id': 'user'
    '/register': 'register'
    '/register_success': 'registerSuccessful'
    '/login': 'login'
    '/forgot_password': 'forgotPassword'
    '/predictions': 'predictions'
    '/predictions/:id': 'prediction'
    '/predictions/new': 'createPrediction'
    '/experts': 'experts'
    '/experts/:id': 'expert'
    '/experts/new': 'createExpert'
    '/claims': 'claims'
    '/claims/:id': 'claim'
    '/claims/new': 'createClaim'
    '/categories': 'categories'
    '/categories/:id': 'categoryAll'
    '/categories/:id/predictions': 'categoryPredictions'
    '/categories/:id/claims': 'categoryClaims'
    '/categories/:id/experts': 'categoryExperts'
    '/search': 'search'
    

  landing: ->
    div {},
      require("views/Landing")
        path: @state.path


  users: ->
    div {},
      require("views/Users")
        path: @state.path

  
  user: (id) ->
    div {},
      require("views/User")
        path: @state.path
        user_id: id

  
  userProfile: ->
    div {},
      require("views/User")
        path: @state.path
        me: true


  predictions: ->
    div {},
      require("views/Predictions")
        path: @state.path

  
  search: ->
    div {},
      require("views/Search")
        path: @state.path

  
  prediction: (id) ->
    if id != "new"
      div {},
        require("views/Prediction")
          path: @state.path
          id: id
    else
      @createPrediction()


  createPrediction: ->
    div {},
      require("views/CreatePrediction")
        path: @state.path


  claims: ->
    div {},
      require("views/Claims")
        path: @state.path

  
  claim: (id) ->
    if id != "new"
      div {},
        require("views/Claim")
          path: @state.path
          id: id
    else
      @createClaim()


  createClaim: ->
    div {},
      require("views/CreateClaim")
        path: @state.path


  experts: ->
    div {},
      require("views/Experts")
        path: @state.path

  
  expert: (id) ->
    if id != "new"
      div {},
        require("views/Expert")
          path: @state.path
          id: id
    else
      @createExpert()

      
  createExpert: ->
    div {},
      require("views/CreateExpert")
        path: @state.path


  bookmarks: ->
    div {},
      require("views/Bookmarks")
        path: @state.path


  categories: ->
    div {},
      require("views/Categories")
        path: @state.path


  categoryAll: (id) ->
    div {},
      require("views/CategoryAll")
        path: @state.path
        id: id

  
  categoryPredictions: (id) ->
    div {},
      require("views/CategoryPredictions")
        path: @state.path
        id: id


  categoryExperts: (id) ->
    div {},
      require("views/CategoryExperts")
        path: @state.path
        id: id

  
  categoryClaims: (id) ->
    div {},
      require("views/CategoryClaims")
        path: @state.path
        id: id

  
  notFound: (path) ->
    div {},
      require("views/404") {}


  render: ->
    div {},
      @renderCurrentRoute()


startBlundit = ->
  if document.getElementById('app')?
    ReactDOM.render(
      React.createElement(MuiThemeProvider, { muiTheme: muiTheme }, Blundit { history: true })
      document.getElementById('app')
    )

if window.addEventListener
  window.addEventListener('DOMContentLoaded', startBlundit)
else
  window.attachEvent('onload', startBlundit)
