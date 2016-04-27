# Main script for migration-demo
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
		@$inject: ["$anchorScroll", "$location", "$timeout", "$log", "$scope", "$http", "TabService"]

		# Constructor
		constructor: (@anchorScroll, @location, @timeout, @log, @scope, @http, @tabService) ->
			console.log "Init main page"
			@scope.pageClass = "main-page"
			@currentTab = @tabService.getCurrent('main') or 1
			return




