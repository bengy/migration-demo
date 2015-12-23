# Main View
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Main controller
# ------------------------------
angular.module "flickstuff"
.controller "MainController",
	class MainController

		# Injection annotation for minimization
		@$inject: ["$location", "$timeout", "$log", "$scope", "$http", "LoginService", "$rootScope"]

		# Constructor
		constructor: (@location, @timeout, @log, @scope, @http, @loginService, @rootScope) ->
			console.log "Main controller init"





		# Clickhandler
		# ------------------------------
		clickedLogout: =>
			@loginService.logout()
			@location.path "/login"






