# Main script for flickstuff landingpage
#
# *Author:* Dominique Rau
# *Version:* 0.0.1-alpha.0
"use strict"





# Main controller
# ------------------------------
app = angular.module "refugee-app"
app.controller "MainController",
	class MainController

		# Injection annotation for minimization
		@$inject: ["$anchorScroll", "$location", "$timeout", "$log", "$scope", "$http"]

		# Constructor
		constructor: (@anchorScroll, @location, @timeout, @log, @scope, @http) ->
			console.log "Init main page"
			return


