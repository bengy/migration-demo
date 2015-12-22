# Description
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Data service
# ------------------------------
angular.module "tellyb-app"
.service "amazonService",
	class AmazonService extends TinyEmitter

		@$inject: ["$filter", "$timeout", "$log", "$http", "$localStorage", "Restangular"]

		# Constructor
		constructor: (@filter, @timeout, @log, @http, @localStorage, @Restangular) ->
			@amazonResults = []
			return





		# Utils
		# ------------------------------

		# [String] Parse amazon id or url
		parseIdOrUrl: (amazonUrlOrItemId) ->
			amazonId = amazonUrlOrItemId
			if _.includes amazonUrlOrItemId, "amazon"
				productId = amazonUrlOrItemId.match(/product\/(.+)\//)?[1]
				if productId? then amazonId = productId
				ibanId = amazonUrlOrItemId.match(/dp\/(.+)\//)?[1]
				if ibanId? then amazonId = ibanId

			return amazonId





		# Rest api
		# ------------------------------

		# [Promise]
		search: (query) =>
			@http.get "/amazon/search?q=#{query}"
			.then (response) =>
				@amazonResults = response.data

		# [Promise]
		lookup: (item) =>
			@http.get("/amazon/lookup/#{item.asin}")
			.then (response) ->
				item.details = response.data


