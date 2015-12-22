# Description
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1<





# Event controller
# ------------------------------
angular.module "tellyb-app"
.controller "ChannelController",
	class ChannelController

		# Injection annotation for minimization
		@$inject: ["$location", "$timeout", "$log", "$scope", "$http", "tellybChannelService"]

		# Constructor
		constructor: (@location, @timeout, @log, @scope, @http, @channelService) ->
			@initChannel()
			@showEventPanel = false
			@selectedDate = new Date()
			@isSelectingDate = false
			@eventToAdd = {
				id: "TestEvent"
				channelId: 1,
				streamIdList: [],
				info: {
					title: "Event Title",
					duration: 0,
					hilight: false,
					startTimeUtcEpoch: Date.now()
					endTimeUtcEpoch: 0
				},
				meta: {}
			}

		# Init channel data
		initChannel: =>
			path = @location.path()
			channelId = path.split("/").pop()
			@channelService.setChannelId channelId





		# Clickhandler
		# ------------------------------

		# Click on edit event
		clickedEditEvent: (eventId) =>
			@location.path("/event/#{eventId}")
			return

		clickedAddEvent: =>
			@showEventPanel = true
			return

		clickedSaveAddEvent: =>
			path = @location.path()
			@eventToAdd.channelId = parseInt path.split("/").pop()
			@eventToAdd.info.endTimeUtcEpoch = @eventToAdd.info.startTimeUtcEpoch + @eventToAdd.info.duration
			console.log @eventToAdd
			@http.post "/events", @eventToAdd
			.then (result) =>
				console.log result
				if result.status is 200
					@channelService.addChannelEvent angular.copy @eventToAdd
			return

		clickedCancelAddEvent: =>
			@showEventPanel = false
			return

		clickedChangeDate: =>
			@isSelectingDate = true
			@backupDate = angular.copy @selectedDate
			console.log "Changing date from: ", @selectedDate, " to ", @backupDate
			return

		clickedLoadDate: =>
			@isSelectingDate = false
			path = @location.path()
			channelId = path.split("/").pop()
			@channelService.loadEventsForChannelAndDate channelId, @selectedDate
			return

		clickedCancleDate: =>
			console.log "Canceling with ", @backupDate
			@isSelectingDate = false
			@selectedDate = @backupDate
			return

		checkIfActive: (event) ->
			debugger
			return event.info.startTimeUtcEpoch < Date.now() and event.info.endTimeUtcEpoch > Date.now()