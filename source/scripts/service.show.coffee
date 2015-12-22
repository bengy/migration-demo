# Show service
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Data service
# ------------------------------
angular.module "tellyb-app"
.service "showService",
	class ShowService extends TinyEmitter

		@$inject: ["$q", "$timeout", "$log", "$http", "$localStorage", "Restangular"]

		# Constructor
		constructor: (@q, @timeout, @log, @http, @localStorage, @Restangular) ->
			@storage = @localStorage.$default
				show: null

		# [void] Set channel from channel editor
		setShowId: (ShowId) =>
			@downloadShow ShowId
			.then (show) =>
				console.log "ShowService show:", show
				@storage.show = show
				return show





		# WebApi
		# ------------------------------

		# [Promise]
		downloadShow: (showId) =>
			@http.get "/show/#{showId}"
			.then (response) -> response.data
			.catch (err) -> console.log "Error occurred", err; return null






