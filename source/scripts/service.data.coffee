# Description
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Data service
# ------------------------------
angular.module "tellyb-app"
.service "tellybDataService",
	class DataService extends TinyEmitter

		@$inject: ["$filter", "$timeout", "$log", "$http", "$localStorage", "Restangular"]

		# Constructor
		constructor: (@filter, @timeout, @log, @http, @localStorage, @Restangular) ->

			# Storage
			@storage = @localStorage.$default
				channels: []
				events: []
				eventsMap: {}

				selectedChannel: {}
				selectedChannelEvents: []

				selectedEvent: {}

				selectedStreamId: ""
				selectedItems: []

				selectedItem: {}
				selectedItemJsonString: ""

				editChannel: {}

			@channels = @Restangular.all("supported-channels")
			@channels.getList()
			.then (channels) =>
				@storage.channels = channels
				console.log @storage.channels

			@downloadEventsFromServer()
			return



		# Add channel
		addViewChannels: =>
			console.log "Add more channels"
			if @viewChannels.length < @storage.channels.length
				diff = @viewChannels.length + Math.min 10, @storage.channels.length - @viewChannels.length
				@viewChannels.push channel for channel in @storage.channels.slice @viewChannels.length, diff

		# Get channel list
		downloadChannelsFromServer: =>
			console.log "Downloading from server"
			@http.get("/channels")
			.success (data, status) =>
				if _.isArray data
					@storage.channels = data
					@storage.lastChannelUpdate = Date.now()
					@viewChannels = @storage.channels.slice 0, 10

		# Get events for channel
		downloadEventsFromServer: =>
			@http.get("/events?select=now")
			.then (result) =>
				console.log "Now events: ", result.data
				@storage.events = result.data
				@storage.lastEventsUpdate = Date.now()
				@storage.eventsMap = _.groupBy result.data, "channelId"

		downloadEventsFromServerForDate: (date) =>
			date = @filter("date")(date, "yyyy-MM-dd")
			@http.get "/events?channelId=#{channel.id}"
			.success (data, status) =>
				@storage.selectedChannelEvents = _.sortBy data, (e) -> return e.info.startTimeUtcEpoch
			.error (data, status) =>
				@storage.selectedChannelEvents = []
				return
			return this




		# Edit channel
		editChannel: (channel) =>
			@storage.editChannel = channel



		# Select channel
		selectChannel: (channel) =>
			@storage.selectedChannel = channel
			console.log @storage.selectedChannel
			@http.get "/events?channelId=#{channel.id}"
			.success (data, status) =>
				console.log "Sorted"
				@storage.selectedChannelEvents = _.sortBy data, (e) -> return e.info.startTimeUtcEpoch
			.error (data, status) ->
				return

		# Select event
		selectEvent: (eventId) ->
			# TODO: show single event
			return

		# Select stream
		selectStream: (streamId) =>
			@storage.selectedStreamId = streamId
			@http.get "/stream/#{streamId}"
			.success (data, status) =>
				@storage.selectedItems = data
				console.log data

		# Events for channel
		eventsForChannel: (channelId) =>
			return @storage.eventsMap[channelId]






		# Select item
		selectItem: (item) =>
			@storage.selectedItem = item
			console.log "Selected: ", @storage.selectedItem
			@storage.selectedItemJsonString = JSON.stringify item.meta, null, 3
			return

		# Delete item
		deleteItem: (item) =>
			@http.delete "/item/#{item.id}"
			.success (data, status) =>
				deleteIdx = @storage.selectedItems.indexOf item
				@storage.selectedItems.splice deleteIdx, 1

		# Save item
		saveItem: =>
			newMeta = angular.fromJson @storage.selectedItemJsonString
			@storage.selectedItem.meta = newMeta
			@storage.selectedItem.stream = @storage.selectedStreamId
			console.log "Saving: ", @storage.selectedItem

			if @storage.selectedItem.id?
				@http.put "/item/#{@storage.selectedItem.id}", @storage.selectedItem
			else
				@http.post "/item", @storage.selectedItem
				.success (data, status) =>
					@storage.selectedItem.id = data.key
					@storage.selectedItems.push @storage.selectedItem


		# New item
		prepareNewItem: =>
			@storage.selectedItem = {
				stream: ""
				info: {
					category: "PRODUCT"     # PRODUCT | SOCIAL
					type:     "TWEET"       # GENERIC | TWEET | SONG
					title: ""
					startTimeRelative: 0
				}
				meta:{
					generic: {url:""},
					twitter: {author: "", text: ""}
					song: {title: "", artist: "", imageUrlSquare: ""}
					itunes: {}
					amazon: {}
				}
				metaReference:{ # Optional pointer to source for easy lookup
					twitter: {}
					itunes: {}
				}
				metaCache: { # Optional cache for faster processing
					twitter: {}
					itunes: {}
				}
			}
			@storage.selectedItemJsonString = JSON.stringify @storage.selectedItem.meta, null, 3







		# Depricated: Save event to server
		saveEvent: (event) =>
			console.log "Saving event: ", event
			console.log "Events: ", @selectedChannel.events
			if (existingEvent = _.find @selectedChannel.events, {id: event.id})?
				console.log "Existing event: ", existingEvent
				@http.put "/events/#{existingEvent.id}", event
				.success (data, status) ->
					angular.extend existingEvent, event
			else
				console.log "New event"
				@http.post "/events", event
				.success (data, status) =>
					(@selectedChannel?.events ?= []).push event










		# 	# Generate socket
		# 	host = window.location.host
		# 	socketUrl = "ws://#{host}"
		# 	@socket = io.connect(socketUrl)

		# 	# Add error messsages
		# 	@socket.on 'reconnect', @_emitError
		# 	@socket.on 'error', @_emitError
		# 	@socket.on 'disconnect', @_emitError
		# 	@socket.on 'reconnect_failed', @_emitError
		# 	return

		# joinRoom: (roomName) =>
		# 	@socket.emit "subscribe", {room: roomName}

		# leaveRoom: (roomName) =>
		# 	@socket.emit "unsubscribe", {room: roomName}

		# _emitError: (error) =>
		# 	console.log "Websocket disconnected."
		# 	@emit "connectionError", "Error message"















.service "TellyItemService",
	class SocketService
		@$inject: ["$timeout", "$log", "$http", "ws", "$localStorage"]

		constructor: (@timeout, @log, @http, @ws, @localStorage) ->
			@connected = false
			@streamId = ""

			@items =
				SOCIAL: []
				PRODUCT: []
			return

		# Download
		_downloadStreamByID: (streamId) =>
			@http.get("/stream/#{streamId}")
			.success (data, status) =>
				items          = _.groupBy data, (item) -> item.info.category
				@items.SOCIAL  = items.SOCIAL or []
				@items.PRODUCT = items.PRODUCT or []

		# Websocket
		_tryToReconnect: =>
			@ws.connect()
			.then (result) =>
				@connected = true
				@_listenersAddWebsocket()
			.catch (errorObject) =>
				@timeout @_tryToReconnect, 5000

		# Add websocket event listeners
		_listenersAddWebsocket: =>

			# Socket callbacks
			@ws.on "message", (m) =>
				{type, data} = angular.fromJson m.data
				switch type
					when "ITEM_ADD"    then @items[data.info.category].push data
					when "ITEM_CHANGE" then data
					when "ITEM_DELETE" then _.remove @items[data.info.category], (i) -> i.id is data.id

			@ws.on "open",  =>
				console.log "Websocket connected"
				@state.websocket.connected = true

			@ws.on "close",  =>
				console.log "Websocket closed"
				@state.websocket.connected = false
				@_tryToReconnect()

			@ws.on "error",  =>
				console.log "Websocket threw error"
				@state.websocket.connected = false
				@_tryToReconnect()

		# UUID
		_newuuid:  ->
			"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace /[xy]/g, (c)  ->
				r = Math.random() * 16 | 0
				v = (if c is "x" then r else (r & 0x3 | 0x8))
				v.toString 16





		# Public
		# ------------------------------

		# Load
		loadStreamByUrl: (url) =>
			@loadStreamId url.substr url.lastIndexOf('/') + 1
			return

		# Load
		loadStreamId: (@streamId) =>
			@_downloadStreamByID @streamId
			@_tryToReconnect()
			.then  =>
				@ws.send angular.toJson {type:"STREAM_SUBSCRIBE", data:@streamId}

		# Get item prototype
		getItemPrototype: (type) =>
			return angular.toJson {
				"id": @_newuuid(),
				"stream": @streamId,
				"info": {
					"category": type ?= "PRODUCT",
					"type":     "GENERIC",
					"title":    "",
					"startTimeRelative": 0
				},
				"meta":{},
				"metaReference":{},
				"metaCache": {}
			}, true

		# Add item
		addItemFromJson: (itemString) =>

			# Get item
			try
				item = angular.fromJson itemString
			catch e
				console.log "Not able to parse object.", e
				return

			@ws.send angular.toJson
				type: "ITEM_ADD"
				data: item
			return

		# Delete item
		delteItem: (item) ->
			@ws.send angular.toJson
				type: "ITEM_DELETE"
				data: item





		# FILTER
		# ------------------------------



		# Get data
		getData: ->
			@data =
				add:
					product:
						generic:
							time: 0
							default:
								{
									"id": "",
									"stream": "",
									"info": {
										"category": "PRODUCT",
										"type":     "GENERIC",
										"title":    "",
										"startTimeRelative": 0
									},
									"meta":{},
									"metaReference":{},
									"metaCache": {}
								}
							item: ""

						byAppleId:
							time: 0
							trackId: "922498199"

					social:
						generic:
							time:0
							default: """
								{
									"id": "",
									"stream": "",
									"info": {
										"category": ,
										"type":     "GENERIC",
										"title":    "",
										"startTimeRelative": 0
									},
									"meta":{},
									"metaReference":{},
									"metaCache": {}
								}
							"""
							item:""

						byTweetId:
							time: 0
							tweetId: "542480085576851457"

				streamId:"__Test Stream__"
				items:
					SOCIAL: []
					PRODUCT: []

		# Socket add item
		socketAPIAddItem:(item) =>
			@ws.send angular.toJson
				type: "ITEM_ADD"
				data: item

		# Socket item delte
		socketAPIItemDelete:(item) =>
			@ws.send angular.toJson
				type: "ITEM_DELETE"
				data: item

		# Get description from item
		filterParseItem:(item) ->
			description = ""

			# TODO: remove this
			return item.info.title

			# Try to get song description
			if item.info.type is "SONG"
				description = item.info.artist + " - " + item.info.title
			if item.info.type is "TWEET"
				description = item.info.author + ": " + item.info.text
			if item.info.type is "GENERIC"
				switch item.category
					when "SOCIAL"
						description = item.info.author + " - " + item.info.text
					when "PRODUCT"
						description = item.info.artist + ": " + item.info.name

			return description


			# Product item from apple lookp response

		# Make item from apple lookup
		helperAddProductItemFromAppleLookup:(lookupResult) =>
			item = {
				id: 					"#{lookupResult.trackId}"
				stream: @data.streamId
				info:
					category: "PRODUCT"
					type: "SONG"
					title:             lookupResult.trackName
					artist:            lookupResult.artistName
					startTimeRelative: @data.add.product.byAppleId.time
					imageUrlSquare:    lookupResult.artworkUrl100
					imageUrlLarge:     lookupResult.artworkUrl100.replace "100x100", "600x600"
				metaHandles:
					itunes:
						trackId:        lookupResult.trackId
						collectionId:   lookupResult.collectionid
				meta:
					itunes:            lookupResult
			}
			console.log "Adding item", item
			@socketAPIAddItem item

		# Make
		helperAddSocialItemFromTwitterLookup:(lookupResult) =>
			item = {
				id: lookupResult.id_str
				stream: @data.streamId
				info: {
					category: "SOCIAL",
					type: "TWEET"
					startTimeRelative: @data.add.social.byTweetId.time
					text:    lookupResult.text,
					author:  lookupResult.user.screen_name,
					avatar:  lookupResult.user.profile_image_url,
				}
				metaHandles:
					twitter:
						tweetId: lookupResult.id_str
				meta:
					twitter: lookupResult
			}
			console.log "Adding item", item
			@socketAPIAddItem item




		# Add by tweet id
		# clickedSocialItemAddByTweetIdSave:  =>
		# 	@http.get "/search/lookup/tweet/#{@data.add.social.byTweetId.tweetId}"
		# 	.success (data) =>
		# 		@helperAddSocialItemFromTwitterLookup data
		# 	.catch (errorObject) ->
		# 		console.log "Error: ", errorObject
		# 	return


		# Add by apple id
		# clickedAddProductbyAppleIdSave: =>

		# 	# Check for stream id
		# 	if @data.streamId is ""
		# 		@presentMissingStreamId()
		# 		return

		# 	# Lookup online
		# 	@http.get "/search/lookup/apple/#{@data.add.product.byAppleId.trackId}"
		# 	.success (data) =>
		# 		@helperAddProductItemFromAppleLookup data
		# 		return
		# 	.catch (errorObject) ->
		# 		console.log "Error: ", errorObject
		# 		return


