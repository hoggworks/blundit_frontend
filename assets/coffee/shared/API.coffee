###
API Class.
Usage to call is like this:
path is required.
path_variables is optional, and used for replacement in paths, like 'claims/%claim_id%/add_commment'
data is optional.

params = {
  path: "claims"
  path_variables:
    claim_id: 1
  data:
    id: "xxx"
}
API.call(params)
###

module.exports = class API
  @paths =
    register:
      path: "users/register"
      method: "POST"
    login:
      path: "users/login"
      method: "POST"
    claims:
      path: "claims/%claim_id%/add_comment"
      method: "POST"


  @server = ->
    return "http://localhost:3000/api/v1/"
    
  
  @method = (params) ->
    return @paths[params.path].method


  @path = (params) ->
    @p = @server() + @paths[params.path].path

    for key, value of params.path_variables
      @p = @p.replace '%'+key+'%', value
    
    return @p


  @data = (params) ->
    if params.data?
      @data = params.data
    else
      @data = {}


  @call = (params) ->
    $.ajax
      type: @method(params)
      url: @path(params)
      headers:
        Authorization: UserStore.getAuthHeader()
      data: @data(params)
      success: (data) ->
        params.success(data) if params.success?
      error: (error) ->
        params.error(error) if params.error?