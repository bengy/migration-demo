# Description
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1<





# Event controller
# ------------------------------
angular.module "tellyb-app"
.controller "SettingsController",
	class SettingsController

		# Injection annotation for minimization
		@$inject: ["$timeout", "$log", "$scope", "$http"]

		# Constructor
		constructor: (@timeout, @log, @scope, @http) ->
			@view =
				scraping: false

		# Start scraping events
		clickedFetchEvents: =>
			@view.scraping = true
			console.log "Fetch events"
			@http.post "/command/fetch-events"
			.success (data, status) =>
				@view.scraping = false
