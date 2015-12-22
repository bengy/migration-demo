# Main View
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Main controller
# ------------------------------
angular.module "flickstuff"
.controller "ChannelController",
	class ChannelController

		# Injection annotation for minimization
		@$inject: ["$location", "$timeout", "$log", "$scope", "$http", "ChannelService", "EventService"]

		# Constructor
		constructor: (@location, @timeout, @log, @scope, @http, @channelService, @eventService) ->
			console.log "Main controller init"

		clickedEvent: (event) ->
			@eventService.setEvent event
			@location.path "/event/#{event.id}"
			return


.directive "fixedToolbar", ["$timeout", (timeout) ->
	directiveDefinitionObject =
		restrict: "A"
		link: (scope, elem, attrs, ngModel) ->
			resize = ->
				$("#tv-toolbar").css {"position":"fixed"}
				toolbarHeight = $("#tv-toolbar").height()
				$("#tv-content").css {"padding-top":toolbarHeight}
			timeout(resize, 200)
			$(window).on "resize", resize
]

.directive "scrollIntoView", ["$timeout", (timeout) ->
	directiveDefinitionObject =
		restrict: "A"
		link: (scope, elem, attrs, ngModel) ->
			console.log("This is called")
			timeout ->
				elem.scrollintoview()
			, 200
]