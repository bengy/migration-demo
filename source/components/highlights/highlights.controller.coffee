# Main View
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Main controller
# ------------------------------
angular.module "flickstuff"
.controller "HighlightsController",
	class HighlightsController

		# Injection annotation for minimization
		@$inject: ["$location", "$timeout", "$log", "$scope", "$http", "HighlightsService", "EventService"]

		# Constructor
		constructor: (@location, @timeout, @log, @scope, @http, @highlightsService, @eventService) ->
			console.log "Main controller init"
			return

		clickedEvent: (hilightEvent) ->
			@eventService.setEvent hilightEvent
			@location.path "/event/#{hilightEvent.id}"








# Heightlights
# ------------------------------
.directive "highlightsComponent", ->
	directiveDefinitionObject =
		restrict: "A"
		scope: true
		templateUrl:"/components/highlights/views/highlights.html"
		controller: "HighlightsController"
		controllerAs: "highlightsCtrl"
		link: (scope, elem, attrs, ngModel) ->
			return





# Filter
# ------------------------------
# Get back 10:10 - 10:30
.filter 'eventDurationFilter', ["$filter", (filter) ->
	(inputEvent) ->
		start = filter("date")(inputEvent.info.startTimeUtcEpoch, "hh:mm")
		end = filter("date")(inputEvent.info.endTimeUtcEpoch, "hh:mm")
		return "#{start} - #{end}"
]





# Flexible height
# ------------------------------
.directive "tabsFlexibleHeight", ->
	directiveDefinitionObject =
		restrict: "A"
		link: (scope, elem, attrs, ngModel) ->
			resize = ->
				windowHeight = $(window).height()
				toolbarHeight = $("#tv-toolbar").height()
				tabsDestinationHeight = windowHeight - toolbarHeight
				$("#tv-tabs").css {"min-height":tabsDestinationHeight}
			resize()
			$(window).on "resize", resize
