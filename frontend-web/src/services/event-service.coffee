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

		# Initial load of events
		loadEvents: =>
			console.log "Loading events"
			@http.get("/api/v1/events")
			.then (res) =>
				@eventList = res.data
				console.log "Got: ", @eventList

		# Create or update event, depending on existence of "eventId"
		saveEvent: (e) =>

			# Copy to make sure no ghost elements are in object
			# Ff id is set, we put, else we post new one
			eventToSave = {
				name: e.name
				desc: e.desc
				to: e.to.valueOf()
				from: e.from.valueOf()
			}
			if e.eventId? then eventToSave["eventId"] = "#{e.eventId}"

			console.log "Saving: ", eventToSave
			@http.post("/api/v1/event", eventToSave)
			.then (res) =>
				console.log "Saved: ", res.data
				# If new event save id and push to list
				if res.status is 200 and res.data.status is "done"
					eventToSave.eventId = res.data.eventId
					@eventList.push eventToSave
					return

				if res.status is 200 and res.data.status is "updated"
					for ev in @eventList
						if ev.eventId = e.eventId
							ev.name = e.name
							ev.desc = e.desc
							ev.to = e.to
							ev.from = e.from


		# Get singular
		getEventById: (id) =>
			@http.get("/api/v1/event/#{id}")
			.then (res) ->

				# Transform dates
				e = res.data
				e.to = new Date(e.to)
				e.from = new Date(e.from)
				return e

		# Delete singular
		deleteEventById: (id) =>
			@http.delete "/api/v1/event/#{id}"
			.then (res) =>
				if res.status is 200 and res.data.status is "deleted"
					@eventList = @eventList.filter (e) -> e.eventId isnt id