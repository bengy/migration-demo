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
		@$inject: ["EventService", "$location"]

		# Constructor
		constructor: (@eventService, @location) ->
			console.log "Init event detail page"
			today = new Date()
			today.setSeconds(0)
			today.setMilliseconds(0)
			@editEvent =
				name: ""
				desc: ""
				from: today
				to: today

			return

		clickedCancel: =>
			@location.path "/"

		clickedSave: =>
			eventToSave = {
				name: @editEvent.name
				desc: @editEvent.desc
				to: @editEvent.to.valueOf()
				from: @editEvent.from.valueOf()
			}
			@eventService.saveNewEvent(eventToSave)
			@location.path "/"