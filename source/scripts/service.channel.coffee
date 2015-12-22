# Description
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Data service
# ------------------------------
angular.module "tellyb-app"
.service "tellybChannelService",
	class ChannelService extends TinyEmitter

		@$inject: ["$filter", "$timeout", "$log", "$http", "$localStorage", "Restangular"]

		# Constructor
		constructor: (@filter, @timeout, @log, @http, @localStorage, @Restangular) ->
			@storage = @localStorage.$default
				selectedChannel: {}
				selectedChannelEvents: []
			return

		# Set channel from channel editor
		setChannelId: (channelId) =>
			@http.get "/events?channelId=#{channelId}"
			.then (result) =>
				@storage.selectedChannelEvents = _.sortBy result.data, (e) -> return e.info.startTimeUtcEpoch
			.catch (e) ->
				return

		loadEventsForChannelAndDate: (channelId, date) =>
			date = @filter("date")(date, "yyyy-MM-dd")
			console.log "Loading events for #{channelId} and date #{date}"
			@http.get "/events?channelId=#{channelId}&date=#{date}"
			.then (result) =>
				@storage.selectedChannelEvents = _.sortBy result.data, (e) -> e.info.startTimeUtcEpoch
			.catch (err) ->
				console.log "Error occurred", console.log err


		addChannelEvent: (event) =>
			@storage.selectedChannelEvents.push event

