# Highlights service
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1


angular.module "flickstuff"
.service "LoginService",
	class BrowserService extends TinyEmitter

		@$inject: ["$location", "$filter", "$timeout", "$log", "$http", "$localStorage", "Restangular", "$rootScope"]

		# Constructor
		constructor: (@location, @filter, @timeout, @log, @http, @localStorage, @Restangular, @rootScope) ->
			@storage = @localStorage.$default
				user: null

			if @storage.user?
				@rootScope.user = @storage.user


		# Set user
		setName: (name) =>
			@storage.user = {name: name}
			@rootScope.user = {name: name}


		logout: =>
			@storage.user = null
			@rootScope.user = null