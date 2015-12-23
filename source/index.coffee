# Description
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1
"use strict"





# Title
# ------------------------------
# Declare app level module which depends on filters, and services
flickstuff = angular.module "flickstuff", ["ngRoute", "ngSanitize", "ws", "ui.semantic", "ngStorage", "restangular", "angular.filter", "mwl.bluebird", "ngMaterial"]





# Promise exception handler
# ------------------------------
# angular.module('mwl.bluebird').run ($q, $log) ->
# 	$q.onPossiblyUnhandledRejection (exception) ->
# 		if exception?.message?.match(/transition (superseded|prevented|aborted|failed)/) then return
# 		console.error("Unhandled rejection", exception)
# 		throw exception





# Redirect to auth if username not set
# ------------------------------
flickstuff.run [ "$rootScope", "$location", ($rootScope, $location) ->
	$rootScope.$on "$routeChaneStart", (ev, next, curr) ->
		if next.$$route
			user = $rootScope.user
			auth = next.$$route.auth
			unless auth?(user) then $location.path "/login"
]





# App configuration
# ------------------------------
flickstuff.config ["$routeProvider", "$locationProvider", "$mdIconProvider", "$mdThemingProvider", "$httpProvider"
	($routeProvider, $locationProvider, $mdIconProvider, $mdThemingProvider, $httpProvider, config) ->


		$httpProvider.defaults.useXDomain = true
		delete $httpProvider.defaults.headers.common['X-Requested-With']

		$mdThemingProvider.theme('default')
			.primaryPalette('blue')
			.accentPalette('indigo')


		$mdIconProvider
			.iconSet('action', '/iconsets/action-icons.svg', 24)
			.iconSet('alert', '/iconsets/alert-icons.svg', 24)
			.iconSet('av', '/iconsets/av-icons.svg', 24)
			.iconSet('communication', '/iconsets/communication-icons.svg', 24)
			.iconSet('content', '/iconsets/content-icons.svg', 24)
			.iconSet('device', '/iconsets/device-icons.svg', 24)
			.iconSet('editor', '/iconsets/editor-icons.svg', 24)
			.iconSet('file', '/iconsets/file-icons.svg', 24)
			.iconSet('hardware', '/iconsets/hardware-icons.svg', 24)
			.iconSet('icons', '/iconsets/icons-icons.svg', 24)
			.iconSet('image', '/iconsets/image-icons.svg', 24)
			.iconSet('maps', '/iconsets/maps-icons.svg', 24)
			.iconSet('navigation', '/iconsets/navigation-icons.svg', 24)
			.iconSet('notification', '/iconsets/notification-icons.svg', 24)
			.iconSet('social', '/iconsets/social-icons.svg', 24)
			.iconSet('toggle', '/iconsets/toggle-icons.svg', 24)

		$routeProvider

			.when "/login",
				templateUrl: "/components/login/views/login.html"
				controller: "LoginController"
				controllerAs: "loginCtrl"

			# Main view
			.when "/",
				templateUrl: "/components/main/views/main.html"
				controller: "MainController"
				controllerAs: "mainCtrl"
				auth: (user)->
					return user?.name?

			# Catch rest
			.otherwise({redirectTo: "/"})

		# Without server side support html5 must be disabled.
		$locationProvider.html5Mode(false)
]


