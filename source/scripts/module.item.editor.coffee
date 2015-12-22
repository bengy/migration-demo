tellybApp.directive "itemEditorSegment",  ->
	directiveDefinitionObject =
		restrict: "A"
		scope: true
		templateUrl: "/partials/partial.item.editor.html"
		controllerAs: "itemEditorCtrl"
		controller:
			class ItemEditorController
				@$inject: ["$timeout", "tellybStreamService",  "$location", "suiTabService", "amazonService"]

				constructor: (@timeout, @streamService, @location, @tabService, @amazonService) ->
					@itemJsonString = ""
					return





				# Tabs
				# ------------------------------
				clickedSelectTab: (tabName) =>
					switch tabName
						when "tunefind" then break
						when "hashtag" then break
						when "generic"
							@streamService.setItemType('GENERIC')
							@streamService.currentItem.meta = {}
						when "amazon"
							@streamService.setItemType('AMAZON')
							@streamService.currentItem.meta = {}
						when "itunes_song"
							@streamService.setItemType('ITUNES_SONG')
							@streamService.currentItem.meta = {}
						when "tweet"
							@streamService.setItemType('TWEET')
							@streamService.currentItem.meta = {}
						when "wikipedia"
							@streamService.setItemType('WIKIPEDIA')
							@streamService.currentItem.meta = {}
						when "raw"
							@streamService.setItemType('GENERIC')
							@streamService.stringifyRaw()
						when "debug"
							@itemJsonString = angular.toJson @streamService.currentItem, true

				clickedTest: ->
					console.log "Test worked"

				test: ->
					@tabService.setActiveTab "item-selection", "test1"





				# Fetch buttons
				# ------------------------------

				# Calc amazon id
				# http://www.amazon.de/gp/product/B00HO3QIYS/ref=s9_simh_gw_p23_d4_i1?pf_rd_m=A3JWKAKR8XB7XF&pf_rd_s=desktop-1&pf_rd_r=05MXQQ6QFVXVACN0VGCX&pf_rd_t=36701&pf_rd_p=585296347&pf_rd_i=desktop
				# http://www.amazon.de/Das-Joshua-Profil-Thriller-Sebastian-Fitzek/dp/3785725450/ref=sr_1_7?ie=UTF8&qid=1446555421&sr=8-7&keywords=buch
				clickedFetchAmazon: =>
					amazonId = @amazonService.parseIdOrUrl @streamService.currentItem.meta.amazon.ref
					@streamService.currentItem.meta.amazon.ref = amazonId
					@streamService.fetchAmazonMeta()

				# Fetch Itunes
				# 28096926
				clickedFetchItunes: =>
					@streamService.fetchItunesMeta()

				# Fetch Twitter
				# TODO: Should also parse urls
				# 661533318257745920
				clickedFetchTwitter: =>
					@streamService.fetchTwitterMeta()

				# Fetch Wikipedia
				# https://de.wikipedia.org/wiki/Bundespräsident_(Deutschland)
				clickedFetchWikipedia: =>

					# Parse and replace wiki id
					wikiUrlOrSearchTerm = @streamService.currentItem.meta.wikipedia.ref
					wikiId = wikiUrlOrSearchTerm.replace(" ", "_")
					if _.includes wikiUrlOrSearchTerm, "wikipedia"
						wikiId = wikiUrlOrSearchTerm.match(/de\.wikipedia\.org\/wiki\/(.+)/)?[1]
					@streamService.currentItem.meta.wikipedia.ref = wikiId

					@streamService.fetchWikipediaMeta()





				# Save buttons
				# ------------------------------
				# Save generic
				clickedSaveGeneric: =>
					@streamService.saveItem()

				# Save amazon item
				clickedSaveAmazon: =>
					@streamService.fetchAmazonMeta().then => @streamService.saveItem()


				# Save itunes item
				clickedSaveItunes: =>
					@streamService.fetchItunesMeta().then => @streamService.saveItem()


				# Save twitter item
				clickedSaveTwitter: =>
					@streamService.fetchTwitterMeta().then => @streamService.saveItem()

				# Save wikipedia item
				clickedSaveWikipedia: =>
					@streamService.fetchWikipediaMeta().then => @streamService.saveItem()


				# Save raw item
				clickedSaveRaw: =>
					@streamService.parseRaw()
					@streamService.saveItem()



		link: (scope, elem, attrs)  ->
			return


