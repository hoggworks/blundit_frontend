{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: '404'
  
  render: ->
    div {},
      Header {}, ''
      div { className: "not-found-wrapper" },
        div { className: "not-found-content" },
          "404"
      Footer {}, ''