# Eventlist component
#
# *Author:* Dominique Rau
# *Version:* 0.0.1-alpha.0
"use strict"





# Event page controller
# ------------------------------
app = angular.module "refugee-app"
app.component "eventPage",
	templateUrl: "/views/event-page/event.html"
	bindings:{}
	controller:
		class EventController

			# Injection annotation for minimization
			@$inject: ["EventService", "$location"]

			# Constructor
			constructor: (@eventService, @location) ->
				console.log "Init event page"
				return

			clickedNewEvent: =>
				console.log "Clicked new event"
				@location.path "/event-detail"