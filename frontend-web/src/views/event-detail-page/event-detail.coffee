# Eventlist component
#
# *Author:* Dominique Rau
# *Version:* 0.0.1-alpha.0
"use strict"





# Event page controller
# ------------------------------
app = angular.module "refugee-app"
app.controller "EventDetailController",
	class EventDetailController

		# Injection annotation for minimization
		@$inject: ["EventService", "$location", "$scope"]

		# Constructor
		constructor: (@eventService, @location, @scope) ->
			@scope.pageClass = "event-detail-page"

			# /event-detail?eventId=xxx
			{eventId} = @location.search()

			# Edit given id
			if eventId?
				@eventService.getEventById eventId
				.then (e) =>
					@editEvent = e
					console.log "Editing: ", @editEvent
			else
				console.log "Create new event."
				# Create blank event
				today = new Date()
				today.setSeconds(0)
				today.setMilliseconds(0)
				@editEvent =
					name: ""
					desc: ""
					from: today
					to: today
			return





		# Cancel edit
		clickedCancel: =>
			@location.path "/"




		# Save event
		clickedSave: =>
			@eventService.saveEvent(@editEvent)
			@location.path "/"




		# Use delete button
		clickedDelete: =>
			@eventService.deleteEventById(@editEvent.eventId)
			.then =>
				@location.path "/"