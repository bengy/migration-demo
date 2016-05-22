# Request component
#
# *Author:* Dominique Rau
# *Version:* 0.0.1-alpha.0
"use strict"





# Request page controller
# ------------------------------
app = angular.module "refugee-app"
app.component "requestPage",
	templateUrl: "/views/request-page/request.html"
	bindings:{}
	controller:
		class RequestController

			# Injection annotation for minimization
			@$inject: ["RequestService", "$location"]

			# Constructor
			constructor: (@requestService, @location) ->
				console.log "Init request page"
				return

			clickedNewRequest: =>
				console.log "Clicked new request"
				@location.path "/request-detail"

			clickedRequestEvent: (e) =>
				console.log "Clicked edit:", r
				@location.url "/request-detail?requestId=#{r.requestId}"
