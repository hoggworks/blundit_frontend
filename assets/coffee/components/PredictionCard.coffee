{ div, img, a, br, span } = React.DOM

LinksMixin = require("mixins/LinksMixin")
DateMixin = require("mixins/DateMixin")
AvatarMixin = require("mixins/AvatarMixin")

module.exports = React.createFactory React.createClass
  displayName: 'PredictionCard'
  mixins: [LinksMixin, DateMixin, AvatarMixin]

  getDescription: ->
    { prediction } = @props
    if prediction.description?
      return prediction.description

    return ''


  getStatus: ->
    { prediction } = @props
    if prediction.status == 0
      return "Unknown"
    else if prediction.status == 1
      if prediction.vote_value >= 0.5
        return "Right"
      else
        return "Wrong"


  getVoteInfo: ->
    { prediction } = @props
    if !prediction.votes_count?
      votes = 0
    else
      votes = prediction.votes_count
    return "#{votes} votes"


  getCommentInfo: ->
    { prediction } = @props
    return "#{prediction.comments_count} comments"


  predictionDate: ->
    { prediction } = @props
    return @formatDate(prediction.prediction_date)

  
  render: ->
    { prediction } = @props
    div { className: "prediction-card" },
      React.createElement(Material.Card, {},
        div
          className: "prediction-card-title"
          onClick: @goToPrediction.bind(@, prediction.alias)
          prediction.title
        div { className: "prediction-card-text" },
          div { className: "prediction-card-date" },
            if prediction.status == 0
              "Will happen on "
            else if prediction.status == 1
              "Happened on "
            span {},
              @predictionDate()
          div { className: "prediction-card-meta" },
            div { className: "prediction-card-meta__status" },
              @getStatus()
            div { className: "prediction-card-meta__votes" },
              @getVoteInfo()
            div { className: "prediction-card-meta__comments" },
              @getCommentInfo()
          if prediction.categories.length > 0
            div { className: "prediction-card-category" },
              span
                onClick: @goToCategory.bind(@, prediction.categories[0].id)
                prediction.categories[0].name

          if prediction.recent_experts.length > 0
            div { className: "prediction-card-experts" },
              prediction.recent_experts.map (expert, index) =>
                div
                  key: "prediction-card-expert-#{index}"
                  className: "prediction-card-experts__expert"
                  onClick: @goToExpert.bind(@, expert.alias)
                  div
                    className: "prediction-card-experts__expert-avatar"
                    style:
                      backgroundImage: "url(#{@getExpertAvatar(expert)})"
                  div { className: "prediction-card-experts__expert-name" },
                    expert.name
          

        React.createElement(Material.CardActions, {},
          if prediction.status == 0 and UserStore.loggedIn()
            # also add check here to see if user has already voted
            # and add vote buttons
            div
              className: "prediction-card-vote"
              onClick: @goToPrediction.bind(@, prediction.alias)
              "VOTE"
          else if prediction.status == 0 and !UserStore.loggedIn()
            div { className: "prediction-card-vote" },
              "Log in to Vote"

        )
      )
