# Request component
#
# *Author:* Dominique Rau
# *Version:* 0.0.1-alpha.0
"use strict"





# Request page controller
# ------------------------------
app = angular.module "refugee-app"
app.controller "RequestDetailController",
	class RequestDetailController

		# Injection annotation for minimization
		@$inject: ["RequestService", "$location", "$scope"]

		# Constructor
		constructor: (@requestService, @location, @scope) ->
			@scope.pageClass = "request-detail-page"

			# /request-detail?requestId=xxx
			{requestId} = @location.search()

			# Edit given id
			if requestId?
				@requestService.getRequestById requestId
				.then (e) =>
					@editRequest = e
					console.log "Editing: ", @editRequest
			else
				console.log "Create new request."
				# Create blank request
				today = new Date()
				today.setSeconds(0)
				today.setMilliseconds(0)
				@editRequest =
					name: ""
					desc: ""
					from: today
					to: today
			return





		# Cancel edit
		clickedCancel: =>
			@location.path "/"




		# Save request
		clickedSave: =>
			@requestService.saveRequest(@editRequest)
			@location.path "/"




		# Use delete button
		clickedDelete: =>
			@requestService.deleteRequestById(@editRequest.requestId)
			.then =>
				@location.path "/"
