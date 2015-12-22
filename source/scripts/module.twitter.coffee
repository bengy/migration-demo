# Tunefind
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Tunefind segment
# ------------------------------
tellybApp.directive "twitterSegment",  ->
	directiveDefinitionObject =
		restrict: "A"
		scope: true
		templateUrl: "/partials/partial.twitter.html"
		controllerAs: "twitterCtrl"
		controller:
			class ItemEditorController
				@$inject: ["$timeout", "$location", "tellybEventService", "tellybStreamService", "$sce"]

				constructor: (@timeout, @location, @eventService, @streamService, @sce) ->
					@isTwitterActive = false
					return

				trustSource: (src) =>
					@sce.trustAsResourceUrl src

				loadSeries: =>
					@isTwitterActive = not @isTwitterActive
					@eventService.loadHashtagsCurrentCollection()

				clickedLoadHashtagTweets: (hashtag) =>
					hashtag.isActive = not hashtag.isActive
					@eventService.loadHashtagTweets(hashtag)

				clickedAddTweet:(tweet) =>
					@streamService.postTweet tweet



		link: (scope, elem, attrs)  ->
			return


