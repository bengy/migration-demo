# Description
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Data service
# ------------------------------
angular.module "tellyb-app"
.service "tellybEventService",
	class EventService extends TinyEmitter

		@$inject: ["$q", "$timeout", "$log", "$http", "$localStorage", "Restangular"]

		# Constructor
		constructor: (@q, @timeout, @log, @http, @localStorage, @Restangular) ->
			@storage = @localStorage.$default
				selectedEvent: {}
				selectedEventShow: {}
				selectedEventItems: []
				tunefindCollections: []
				tunefindCollection: {}
				tunefindSeason: {}
				tunefindShow: {}
				appleSongs: []
			return

		# [void] Set channel from channel editor
		setEventId: (eventId) =>
			@downloadEvent eventId
			.then (event) =>
				console.log "Selected event:", event
				@storage.selectedEvent = event
				return event
			.then (event) =>
				# TODO: use event.showId again, as soon as it is fixed
				@downloadShow event.meta.kabeldeutschland.progid
			.then (show) =>
				console.log "Selected show: ", show
				@storage.selectedEventShow = show
				return show
			.catch (err) ->
				console.log "Error occurred", console.log err


		# [Promise] Return tunefind collection
		loadTunefindCollections: =>
			if @storage.tunefindCollections?.length > 0
				console.log "Using collections:", @storage.tunefindCollections
				return @storage.tunefindCollections
			else
				return @downloadTunefindCollections()
				.then (collections) =>
					console.log "Downloaded collections:", collections
					@storage.tunefindCollections = collections
					return collections

		# [Promise] Return hashtags
		loadHashtagsCurrentCollection: =>
			currentCollectionTitle = @storage.selectedEventShow.info.title
			return @downloadHashtagCollection currentCollectionTitle
			.then (hashtags) =>
				return @storage.hashtags = hashtags

		loadHashtagTweets: (hashtag) =>
			@downloadTopTweets hashtag.title
			.then (tweets) ->
				hashtag.tweets = tweets


		# [Promise] Load current collection
		loadTunefindCurrentCollection: =>
			currentCollectionTitle = @storage.selectedEventShow.info.title
			console.log "Loading collection: #{currentCollectionTitle}"
			return @loadTunefindCollection currentCollectionTitle

		# [Promise] Set collection
		loadTunefindCollection: (collectionTitle) =>
			return @downloadTunefindCollection collectionTitle
			.then (collection) =>
				@storage.tunefindCollection = collection
				return @storage.tunefindCollection

		searchApple:(song) =>
			unless _.isEmpty song.itunesSongList then return
			query = "#{song.title} #{song.artist}"
			@downloadItunesSearchresults query
			.then (results) ->
				song.itunesSongList = results


		# [Promise] Return tunefind collection
		loadTunefindSeason: (season) =>
			@storage.tunefindSeason = season
			return @q.resolve @storage.tunefindSeason

		# [Promise] Return tunefind show
		loadTunefindShow: (show) =>
			@storage.tunefindShow = show
			return @q.resolve @storage.tunefindShow

		crawlTunefindShow: (season, show) =>
			currentCollectionTitle = @storage.selectedEventShow.info.title
			@http.get "/tunefind/crawl/#{encodeURIComponent currentCollectionTitle}/show/#{encodeURIComponent show.url}"
			.then (response) ->
				console.log response.data
				return response.data





		# WebApi
		# ------------------------------

		# [Promise]
		downloadEvent: (eventId) =>
			return @http.get "/events/#{eventId}"
			.then (response) ->
			   return response.data

		# [Promise]
		downloadShow: (showId) =>
			return @http.get "/show/#{showId}"
			.then (response) ->
			   return response.data

		# [Promise<Array<{title}>>] Download collection title list
		downloadTunefindCollections: =>
			return @http.get "/tunefind/collections"
			.then (response) ->
				return response.data
			.catch (err) ->
				return []

		downloadHashtagCollection: (collectionTitle) =>
			return @http.get "twitter/hashtags/#{collectionTitle}"
			.then (response) -> response.data.similar.map (h) -> {title:h}
			.catch (err) -> []

		downloadTopTweets: (queryString) =>
			return @http.get "twitter/hashtagify-top/#{queryString}"
			.then (response) -> response.data
			.catch (err) -> return []

		# [Promise<Object<Collection>>] Download collection by title
		downloadTunefindCollection: (collectionTitle) =>
			return @http.get "/tunefind/collection/#{collectionTitle}"
			.then (response) ->
				return response.data
			.catch (err) ->
				return {}

		# [Promise] Download iTunes search results
		downloadItunesSearchresults: (query) =>
			return @http.get("/itunes/search/music/#{query}")
			.then (response) ->
				return _.filter response.data, (t) -> t.trackPrice >= 0
			.catch (err) ->
				console.log "Error occurred", console.log err
				return []




