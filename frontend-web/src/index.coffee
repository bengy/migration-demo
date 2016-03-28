# Main script for flickstuff landingpage
#
# *Author:* Dominique Rau
# *Version:* 0.0.1-alpha.0
"use strict"





# Title
# ------------------------------
# Declare app level module which depends on filters, and services
app = angular.module "refugee-app", ["ngRoute", "ngAnimate", "pascalprecht.translate", "ngMaterial", "mdExtension"]
# app = angular.module "refugee-app", ["ngRoute", "ngAnimate", "pascalprecht.translate", "ui.semantic"]





# App configuration
# ------------------------------
app.config ["$routeProvider", "$translateProvider", "$mdThemingProvider"
	($routeProvider, $translateProvider, $mdThemingProvider, config) ->

		# Without server side support html5 must be disabled.
		# $locationProvider.html5Mode(false)

		# Routes
		$routeProvider
			# Main view
			.when "/",
				templateUrl: "/views/main-page/main.html"
				controller: "MainController"
				controllerAs: "mainCtrl"

			.when "/event-detail",
				templateUrl: "/views/event-detail-page/event-detail.html"
				controller: "EventDetailController"
				controllerAs: "eventCtrl"

			# Catch rest
			.otherwise({redirectTo: "/"})

		$mdThemingProvider.theme('default')
			.primaryPalette('blue')
			.accentPalette('pink')
		# # Englisch translations
		# $translateProvider.translations 'en',
		# 	TEST: "Test"

		# # German translations
		# $translateProvider.translations 'de',
		# 	TEST: "Test"
		# $translateProvider.useSanitizeValueStrategy 'escape'
]





# Following menu directive
# ------------------------------

# Animate following header, pop when getting back to top
# app.directive "following", ->
# 	directiveDefinitionObject =
# 		restrict: "A"
# 		link: (scope, elem, attrs, ngModel) ->

# 			# Header animation
# 			$('body').visibility
# 				offset			: -10,
# 				observeChanges	: false,
# 				once				: false,
# 				continuous		: false,
# 				onTopPassed: ->
# 					requestAnimationFrame ->
# 						$('.following.bar').addClass('light fixed')
# 						$('.following .additional.item').transition('scale in', 750)

# 				onTopPassedReverse: ->
# 					requestAnimationFrame ->
# 						$('.following.bar')
# 						.removeClass('light fixed')
# 						.find('.menu .additional.item')
# 						.transition('hide')

# Animate appearence for all elements
# app.directive "animatedAppearence", ->
# 	directiveDefinitionObject =
# 		restrict: "A"
# 		link: (scope, elem, attrs, ngModel) ->

# 			$(elem).visibility
# 				offset         : -30
# 				observeChanges	: false,
# 				once				: true,
# 				continuous		: false,
# 				onTopVisible: ->
# 					requestAnimationFrame ->
# 						$(elem).transition('scale in', 750)

# Animate waves
# app.directive "animatedWaves", ["$timeout", ($timeout) ->
# 	directiveDefinitionObject =
# 		restrict: "A"
# 		link: (scope, elem, attrs) ->
# 			time = parseInt(attrs.animatedWaves) or 0

# 			$(elem).visibility
# 				offset         : -30
# 				observeChanges	: false,
# 				once				: false,
# 				continuous		: false,
# 				onTopVisible: ->
# 					requestAnimationFrame ->
# 						setTimeout ->
# 							$(elem)
# 							.transition "vertical flip out", "1000ms"
# 							.transition "vertical flip in", "1000ms"
# 							.transition "vertical flip out", "1000ms"
# 							.transition "vertical flip in", "1000ms"
# 						, time
# ]

# Animate email
# app.animation ".fs-subscribe-email", ["$animateCss", ($animateCss) ->
# 	animateAppear =  (elem, className, done) ->
# 		autoWidth = elem.css("width", "auto").width()
# 		return $animateCss(elem, {
# 			from: {width: 0, opacity: 0}
# 			to: {width: autoWidth, opacity: 1}
# 			duration: 1
# 			easing: "cubic-bezier(0.19, 1, 0.22, 1)"
# 		})

# 	animateHide =  (elem, className, done) ->
# 		autoWidth = elem.css("width", "auto").width()
# 		return $animateCss(elem, {
# 			from: {width: autoWidth, opacity: 1}
# 			to: {width: 0, opacity: 0}
# 			duration: 1
# 			easing: "cubic-bezier(0.19, 1, 0.22, 1)"
# 		})

# 	return {
# 		addClass: animateAppear
# 		removeClass: animateHide
# 	}
# ]