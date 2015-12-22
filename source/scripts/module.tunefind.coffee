# Tunefind
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Tunefind segment
# ------------------------------
tellybApp.directive "tunefindSegment",  ->
	directiveDefinitionObject =
		restrict: "A"
		scope: true
		templateUrl: "/partials/partial.tunefind.html"
		controllerAs: "tunefindCtrl"
		controller:
			class ItemEditorController
				@$inject: ["$timeout", "$location", "tellybEventService", "tellybStreamService", "$sce"]

				constructor: (@timeout, @location, @eventService, @streamService, @sce) ->
					@isTunefindActive = false
					return

				trustSource: (src) =>
					@sce.trustAsResourceUrl src

				loadSeries: =>
					@isTunefindActive = not @isTunefindActive
					@eventService.loadTunefindCurrentCollection()

				autoLoadSeries: =>
					@eventService.loadTunefindCurrentCollection()
					.bind this
					.then (tunefindResult) =>
						show = @eventService.storage.selectedEventShow
						season = show.meta?.kabeldeutschland?.relay
						show = show.meta?.kabeldeutschland?.series_number

						if season? and show?
							season = _.findWhere tunefindResult.seasonList, {title: "Season #{season}"}
							show = _.findWhere season.showList, {episodeNumber: "#{show}"}
							return show?.songList
					.then (songList) ->
						if _.isEmpty songList then throw new Error "No song available"
						return songList.map (s) -> return "#{s.title} #{s.artist}"
					.map (queryTerm) =>
						return @eventService.downloadItunesSearchresults queryTerm
					.map (itunesList) ->
						console.log itunesList
						sorted = _.sortBy itunesList, "trackPrice"
						first = _.first sorted
						return first
					.map (itunesSong) =>
						@streamService.postItunesSong itunesSong
					.catch (err) ->
						console.log "Error occurred", console.log err


				searchSong: (song, songList) =>
					@eventService.searchApple song
					if song.isActive then song.isActive = false
					else
						songList.forEach (s) -> s.isActive = false
						song.isActive = not song.isActive
					return

				addItunesSong:(itunesSong) =>
					@streamService.postItunesSong itunesSong

				clickedCrawlShow: (season, show)=>
					@eventService.crawlTunefindShow season, show


		link: (scope, elem, attrs)  ->
			return


