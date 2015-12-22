# Main View
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Main controller
# ------------------------------
angular.module "flickstuff"
.controller "SearchController",
	class SearchController

		# Injection annotation for minimization
		@$inject: ["$location", "$timeout", "$log", "$scope", "$http"]

		# Constructor
		constructor: (@location, @timeout, @log, @scope, @http) ->
			console.log "Main controller init"











