# Description
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Main controller
# ------------------------------
angular.module "tellyb-app"
.controller "MainController",
	class MainController

		# Injection annotation for minimization
		@$inject: ["$location", "$timeout", "$log", "$scope", "$http", "tellybDataService"]

		# Constructor
		constructor: (@location, @timeout, @log, @scope, @http, @dataService) ->
			console.log "Main controller init"
			@seletedDate = new Date()
			@data =
				channels: @dataService.channels

			@view =
				mode: "channels" # channel_today, channel_events, channel_streams
				search: ""
				isAddingEvent: false

		# Clicked channel
		clickedChannel: (channel) =>
			console.log "Clicked channel: ", channel
			@dataService.selectChannel channel
			@location.path("/channel/#{channel.id}")

		# Clicked edit channel
		clickedEditChannel: (channel) =>
			console.log "Clicked edit channel: ", channel
			@dataService.editChannel channel
			@location.path("/channel-editor/#{channel.id}")





.directive "epgProgram", ->
	directiveDefinitionObject =
		restrict: "A"
		template: """
		<div>
			<p ng-if="toShow">
				{{toShow.info.title}}
				<br>
				<i>
					{{from | date:'hh:mm'}}-{{to | date:'hh:mm'}}
				</i>
			</p>
		</div>
		"""
		scope:
			program: "="
		link: (scope, elem, attrs) ->
			scope.toShow = scope.program?[0]
			scope.from = scope.toShow?.info?.startTimeUtcEpoch
			scope.to = scope.toShow?.info?.endTimeUtcEpoch
			return







