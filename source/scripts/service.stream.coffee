# Description
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Stream service
# ------------------------------
angular.module "tellyb-app"
.service "tellybStreamService",
	class StreamService
		@$inject: ["$localStorage", "$http", "Restangular", "$location", "suiTabService"]

		# Stream service
		constructor: (@localStorage, @http, @Restangular, @location, @tabService) ->
			@storage = @localStorage.$default
				items:[]
			@currentStreamId = null
			@currentItem = @genericItem()
			@currentItemJsonString
			# @stream = @Restangular.all "items/"
			return





		# Item
		# ------------------------------
		setItemType: (typeName) =>
			@currentItem.info.type = typeName
			switch typeName
				when "GENERIC", "SONG", "AMAZON", "ITUNES_SONG"
					@currentItem.info.category = "PRODUCT"
				when "TWEET", "WIKIPEDIA"
					@currentItem.info.category = "SOCIAL"





		# Stream
		# ------------------------------
		loadStream: (streamId) =>
			@currentStreamId = streamId
			@http.get "/stream/#{streamId}"
			.then (response) =>
				@storage.items = response.data

		# Add item
		addItem: (item) =>
			console.log "Adding item:", item
			@http.post "items", item
			.then (response) =>
				item.id = response.data
				@storage.items.push item

		# Save
		saveItem: =>
			@currentItem.streamId = @currentStreamId
			if @currentItem.id?
				@http.put "items/#{@currentItem.id}", @currentItem
				.then (response) =>
					console.log "Put response: ", response
					item = _.find @storage.items, {id:@currentItem.id}
					item.info = @currentItem.info
					item.meta = @currentItem.meta
			else
				sendItem = angular.copy @currentItem
				@http.post "items", sendItem
				.then (response) =>
					sendItem.id = response.data
					@storage.items.push sendItem

		parseRaw: =>
			@currentItem = angular.fromJson @currentItemJsonString

		stringifyRaw: =>
			@currentItemJsonString = angular.toJson @currentItem, true

		# @pram item string
		# @return Promise
		fetchItunesMeta: =>
			@http.get "itunes/meta/#{@currentItem.meta.itunes.ref}"
			.then (response) =>
				if response.data?
					@currentItem.meta.itunes = response.data
					@currentItem.info.title = response.data.data.title


		# @pram item string
		# @return Promise
		fetchAmazonMeta: =>
			@http.get "amazon/meta/#{@currentItem.meta.amazon.ref}"
			.then (response) =>
				if response.data?
					@currentItem.meta.amazon = response.data
					@currentItem.info.title = response.data.data.title


		# @pram item string
		# @return Promise
		fetchTwitterMeta: =>
			@http.get "twitter/meta/#{@currentItem.meta.twitter.ref}"
			.then (response) =>
				if response.data?
					@currentItem.meta.twitter = response.data
					@currentItem.info.title = "#{response.data.data.author}:#{_.trunc(response.data.data.text, {length:20})}"


		# @pram item string
		# @return Promise
		fetchWikipediaMeta: =>
			@http.get "wikipedia/meta/#{@currentItem.meta.wikipedia.ref}"
			.then (response) =>
				if response.data?
					@currentItem.meta.wikipedia = response.data
					@currentItem.info.title = response.data.data.title


		# @pram item string
		# @return Promise
		deleteItem: (item) =>
			@http.delete "items/#{item.id}"
			.then (response) =>
				@storage.items.splice @storage.items.indexOf(item), 1

		editItem: (item) =>
			@currentItem = item
			@stringifyRaw()
			@tabService.setActiveTab "item-selection", "raw"

		postItunesSong: (itunesSong) =>
			item = {
				streamId: @currentStreamId
				info:
					category: "PRODUCT"
					startTimeRelative: 0
					title: "#{itunesSong.artistName} - #{itunesSong.trackName}"
					type: "ITUNES_SONG"
				meta:
					itunes:
						data: {
							title: itunesSong.trackName
							artist: itunesSong.artistName
							artworkImageUrl: itunesSong.artworkUrl100
							trackId: itunesSong.trackId
						}
						ref: "#{itunesSong.trackId}"
						cache: itunesSong
			}
			@addItem item


		postTweet: (tweet) =>
			item =
				streamId: @currentStreamId
				info:
					category: "SOCIAL"
					startTimeRelative: 0
					title: "#{tweet.user.name} - #{tweet.text}"
					type: "TWEET"
				meta:
					twitter:
						data:
							author: tweet.user.screen_name
							text: tweet.text
							profileImageUrl: tweet.user.profile_image_url
						ref: tweet.id
						cache: tweet
			@addItem item

		postAmazonItem: (asin) =>
			@http.get "amazon/meta/#{asin}"
			.then (response) =>
				item =
					streamId: @currentStreamId
					info:
						category: "PRODUCT"
						startTimeRelative: 0
						title: response.data.data.title
						type: "AMAZON"
					meta:
						amazon: response.data
				@addItem item





		# Utils
		# ------------------------------
		genericItem: ->
			streamId: ""
			info:
				category: "PRODUCT"
				startTimeRelative: 0
				title: "Title"
				type: "GENERIC"
			meta: generic: data: url: "www.google.com"

