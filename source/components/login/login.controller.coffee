# Main View
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Main controller
# ------------------------------
angular.module "flickstuff"
.controller "LoginController",
	class BrowserController

		# Injection annotation for minimization
		@$inject: ["$window", "$location", "$timeout", "$scope", "$http", "LoginService"]

		# Constructor
		constructor: (@window, @location, @timeout, @scope, @http, @loginService) ->
			@name = "Name"

		clickedLogin: =>
			console.log "Login: Clicked login"
			@loginService.setName @name
			@location.path "/"

