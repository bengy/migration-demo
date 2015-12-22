# Main View
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Main controller
# ------------------------------
angular.module "flickstuff"
.controller "BrowserController",
	class BrowserController

		# Injection annotation for minimization
		@$inject: ["$window", "$location", "$timeout", "$log", "$scope", "$http", "BrowserService", "$sce"]

		# Constructor
		constructor: (@window, @location, @timeout, @log, @scope, @http, @browserService, @sce) ->
			console.log "Browser controller init"

		trustSource: (src) =>
			@sce.trustAsResourceUrl src

		clickedBack: =>
			console.log "Browser: Clicked back"
			@window.history.back()

.directive "browserOnLoad", ->
	directiveDefinitionObject =
		restrict: "A"
		controller: "BrowserController"
		controllerAs: "browserCtrl"
		link: (scope, elem, attrs, ngModel) ->
			# elem.on "load"
			return
