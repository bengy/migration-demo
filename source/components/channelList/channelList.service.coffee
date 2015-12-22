# Highlights service
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1


angular.module "flickstuff"
.service "ChannelListService",
	class ChannelListService extends TinyEmitter

		@$inject: ["$filter", "$timeout", "$log", "$http", "$localStorage"]

		# Constructor
		constructor: (@filter, @timeout, @log, @http, @localStorage) ->
			@storage = @localStorage.$default
				tvChannelList: []

			@init()
			return

		init: =>
			unless @storage.tvChannelList.length > 0
				@fetchChannelList().then (channelList) =>
					@storage.tvChannelList = channelList
					return

		fetchChannelList: =>
			@http.get "/supported-channels"
			.then (response) -> return response.data
			.catch (err) -> console.log "Error occurred", err; return []





