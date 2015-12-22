# Highlights service
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1


angular.module "flickstuff"
.service "HighlightsService",
	class HighlightsService extends TinyEmitter

		@$inject: ["$filter", "$timeout", "$log", "$http", "$localStorage"]

		# Constructor
		constructor: (@filter, @timeout, @log, @http, @localStorage) ->
			@storage = @localStorage.$default
				tvHighlights: []

			@init()
			return

		init: =>
			console.log "Init highlights"

			@fetchHighlights()
			.then (highlights) =>
				console.log "Found: ", highlights
				@storage.tvHighlights = highlights

		fetchHighlights: =>
			@http.get "/events?select=hilights"
			.then (response) -> return response.data
			.catch (err) -> console.log "Error occurred", err; return []






