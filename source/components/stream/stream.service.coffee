# Highlights service
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1


angular.module "flickstuff"
.service "StreamService",
	class StreamService extends TinyEmitter

		@$inject: ["$location", "$filter", "$timeout", "$log", "$http", "$localStorage", "Restangular"]

		# Constructor
		constructor: (@location, @filter, @timeout, @log, @http, @localStorage, @Restangular) ->
			@streamIdList = []
			@stream = []
			@streamProvider = {
				getItemAtIndex: (index) =>
					return @stream[index]
				getLength: =>
					return @stream.length
			}

			console.log "Stream not initialized"
			#@init()
			return

		init: =>
			eventId = @parseChannelId()
			if eventId? and eventId isnt ""
				@fetchEvent eventId
				.then @setEvent
			return

		addStream: (streamId) =>
			@streamIdList.push streamId
			@fetchStream streamId
			.then (stream) =>
				@stream = stream
				console.table @stream

		fetchStream: (streamId) ->
			return @http.get "/stream/#{streamId}"
			.then (response) -> return response.data
			.catch (err) -> console.log "Error occurred", err; return []



