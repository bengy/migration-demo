# Event services
#
# *Author:* Dominique Rau
# *Version:* 0.0.1-alpha.0
"use strict"





# Event service
# ------------------------------
app = angular.module "refugee-app"
app.service "EventService",
	class EventService

		# Injection annotation for minimization
		@$inject: ["$http"]

		# Constructor
		constructor: (@http) ->
			console.log "Init event service"
			@eventList = []
			@loadEvents()
			return

		loadEvents: =>
			console.log "Loading events"
			@http.get("/api/v1/events")
			.then (res) =>
				@eventList = res.data
				console.log "Got: ", @eventList

		saveNewEvent: (e) =>
			@http.post("/api/v1/event", e)
			.then (res) =>
				console.log "Status: ", res.status
				console.log "Response: ", res.data
				if res.status is 200 and res.data.status is "done"
					e.id = res.data.eventId
					@eventList.push e
					return