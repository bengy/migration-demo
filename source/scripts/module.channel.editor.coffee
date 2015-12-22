# Description
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1<





# Event controller
# ------------------------------
angular.module "tellyb-app"
.controller "ChannelEditController",
	class ChannelEditController

		# Injection annotation for minimization
		@$inject: ["$location", "$timeout", "$log", "$scope", "$http", "tellybDataService"]

		# Constructor
		constructor: (@location, @timeout, @log, @scope, @http, @dataService) ->
			console.log('dataService', @dataService.storage.editChannel)
			@channel = angular.copy(@dataService.storage.editChannel)






		# Clickhandler
		# ------------------------------

		# Click on edit event
		clickedSave: ->
			@http.put "/supported-channel/#{@channel.id}", @channel
			.then (res) ->
				console.log('res', res)
