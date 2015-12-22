# Highlights service
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1


angular.module "flickstuff"
.service "ChannelService",
	class ChannelService extends TinyEmitter

		@$inject: ["$location", "$filter", "$timeout", "$log", "$http", "$localStorage", "Restangular"]

		# Constructor
		constructor: (@location, @filter, @timeout, @log, @http, @localStorage, @Restangular) ->
			@events = []
			@channel = {}

			@init()
			return

		init: =>
			channelId = @parseChannelId()
			if channelId? and channelId isnt ""
				@fetchChannelEvents(channelId).then (@events) => return

		setChannel: (@channel) =>
			@fetchChannelEvents(@channel.id).then (@events) => return

		parseChannelId: =>
			path = @location.path()
			return channelId = path.split("/").pop()

		fetchChannel: (channelId) =>
			@http.get "/channel/#{channelId}"
			.then (response) -> return response.data
			.catch (err) -> console.log "Error occurred", err; return []

		fetchChannelEvents: (channelId) =>
			@http.get "/events?channelId=#{channelId}"
			.then (response) -> return response.data
			.catch (err) -> console.log "Error occurred", err; return []

		isEventPast: (event) ->
			return event.info.endTimeUtcEpoch < Date.now()

		isEventActive: (event) ->
			return event.info.startTimeUtcEpoch < Date.now() and event.info.endTimeUtcEpoch > Date.now()

		isEventFuture: (event) ->
			return event.info.startTimeUtcEpoch > Date.now()


.filter "pastEventFilter", ["$filter", (filter) ->
	(eventList) ->
		return eventList.filter (inputEvent) -> inputEvent?.info?.endTimeUtcEpoch < Date.now()
]


.filter "currentEventFilter", ["$filter", (filter) ->
	(eventList) ->
		return eventList.filter (inputEvent) -> inputEvent?.info?.startTimeUtcEpoch < Date.now() and inputEvent?.info?.endTimeUtcEpoch > Date.now()
]

.filter "futureEventFilter", ["$filter", (filter) ->
	(eventList) ->
		return eventList.filter (inputEvent) -> inputEvent?.info?.startTimeUtcEpoch > Date.now()
]
