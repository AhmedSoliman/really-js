###*
 * Copyright (C) 2014-2015 Really Inc. <http://really.io>
 * 
 * Callbacks Buffer
 * 
###
protocol = require './protocol.coffee'
class CallbacksBuffer
  constructor: ->
    @tag = 0
    @_callbacks = {}
  
  handle: (message) ->
    {tag} = message
    if protocol.isErrorMessage message
      try
        @_callbacks[tag]['error'].call()
      catch e
        console.log 'Error happened when trying to execute your error callback', e.stack
      
    else
      try
        @_callbacks[tag]['success'].call()
      catch e
        console.log 'Error happened when trying to execute your success callback', e.stack

    try
      @_callbacks[tag]['complete'].call()
    catch e
      console.log 'Error happened when trying to execute your complete callback', e.stack
    

    delete @_callbacks[tag]


  add: (args) ->
    {type, success, error, complete} = args
    type ?= 'default'
    tag = newTag.call(this)
    
    @_callbacks[tag] = {type, success, error, complete}

    return tag

  newTag = -> @tag += 1


module.exports = CallbacksBuffer