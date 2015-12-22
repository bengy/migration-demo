# Highlights service
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1


angular.module "flickstuff"
.service "EventService",
	class EventService extends TinyEmitter

		@$inject: ["$location", "$filter", "$timeout", "$log", "$http", "$localStorage", "Restangular", "StreamService"]

		# Constructor
		constructor: (@location, @filter, @timeout, @log, @http, @localStorage, @Restangular, @streamService) ->
			@event = {}
			@show = {}

			@init()
			return

		init: =>
			eventId = @parseChannelId()
			if eventId? and eventId isnt ""
				@fetchEvent eventId
				.then @setEvent
			return


		parseChannelId: =>
			path = @location.path()
			return eventId = path.split("/").pop()

		setEvent: (@event) =>
			console.log "Event: ", @event
			@streamService.addStream @event.id

			@fetchShow @event.showId
			.then (@show) =>
				console.log "Show: ", @show
			return


		setEventId: (eventId) =>
			return @fetchEvent(eventId)
			.then (@events) => console.log "Get events:", @events; return

		fetchShow: (showId) ->
			return @http.get "/shows/#{showId}"
			.then (response) -> return response.data
			.catch (err) -> console.log "Error occurred", err; return null

		fetchEvent: (eventId) ->
			return @http.get "/events/#{eventId}"
			.then (response) -> return response.data
			.catch (err) -> console.log "Error occurred", err; return null

