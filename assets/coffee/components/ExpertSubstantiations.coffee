{ div, a } = React.DOM

InlineLink = require("components/InlineLink")

module.exports = React.createFactory React.createClass
  displayName: "ExpertSubstantiations"
  getInitialState: ->
    data: null
    url: ''
    addSubstantiationError: null
    submitting: false


  componentDidMount: ->
    @fetchSubstantiationData()


  fetchSubstantiationData: ->
    params = {
      path: "get_substantiations"
      path_variables:
        expert_id: @props.expert.id
      data:
        type: @props.type
        id: @props.id

      success: @substantiationsSuccess
      error: @substantiationsError
    }

    API.call(params)


  substantiationsSuccess: (data) ->
    @setState data: data

    # TODO: Add bit here to pass updated data to parent, to
    # reflect data without having to reload the whole thing.
    # Need to be pretty generic about it.
  

  addSubstantiation: ->
    if @state.url == ''
      @setState addSubstantiationError: "Url required"
      return

    @setState submitting: true

    params = {
      path: "add_substantiation"
      path_variables:
        expert_id: @props.expert.id
      data:
        type: @props.type
        id: @props.id
        url: @state.url

      success: @addSubstantiationsSuccess
      error: @addSubstantiationsError
    }

    API.call(params)

  
  addSubstantiationsSuccess: (data) ->
    @setState url: ''
    @fetchSubstantiationData()
    @setState submitting: false


  addSubstantiationsError: (error) ->
    if error.responseJSON? and error.responseJSON.errors?
      @setState addSubstantiationError: error.responseJSON.errors[0]
    else
      @setState addSubstantiationError: "There was an error."
      @setState submitting: false


  changeURL: (event) ->
    @setState url: event.target.value


  render: ->
    @refreshStyle = {
      display: 'inline-block'
      position: 'relative'
      boxShadow: 'none'
    }
    { expert, type } = @props

    if @state.data == null
      React.createElement(Material.RefreshIndicator, { style: @refreshStyle, size: 50, left: 0, top: 0, status:"loading" })
    else
      div {},
        div { className: "substantiation-list" },
          if @state.data.length > 0
            @state.data.map (substantiation, index) =>
              InlineLink
                item: substantiation
                key: "substantiation-list-#{@props.id}-#{index}"
          else
            "There are currently no links substantianting #{expert.name}'s belief in this #{type}."

        if UserStore.loggedIn()
          div { className: "substantiation-list__add" },
            "Add Substantiation:"
            if @state.submitting == false
              div {},
                React.createElement(Material.TextField,
                  {
                    value: @state.url,
                    fullWidth: true,
                    onChange: @changeURL,
                    id: "add-substantiation"
                  }
                )
                React.createElement(Material.FlatButton, { label: "Add", onClick: @addSubstantiation })
            else
              React.createElement(Material.LinearProgress, { mode: "indeterminate" })
            
            if @state.addSubstantiationError?
              div {},
                @state.addSubstantiationError
      