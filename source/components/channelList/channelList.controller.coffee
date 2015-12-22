# Main View
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Main controller
# ------------------------------
angular.module "flickstuff"
.controller "ChannelListController",
	class ChannelListController

		# Injection annotation for minimization
		@$inject: ["$location", "$timeout", "$log", "$scope", "$http", "ChannelListService", "ChannelService"]

		# Constructor
		constructor: (@location, @timeout, @log, @scope, @http, @channelListService, @channelService) ->
			console.log "Main controller init"


		clickedChannel: (channel) =>
			@channelService.setChannel channel
			@location.path "/channel/#{channel.id}"




.directive "channelListComponent", ->
	directiveDefinitionObject =
		restrict: "A"
		scope:
			fingerprintOnFind: "&"
		templateUrl:"/components/channelList/views/channelList.html"
		controller: "ChannelListController"
		controllerAs: "channelListCtrl"
		link: (scope, elem, attrs, ngModel) ->
			return



