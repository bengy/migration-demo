# Tunefind
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Tunefind segment
# ------------------------------
tellybApp.directive "amazonSegment",  ->
	directiveDefinitionObject =
		restrict: "A"
		scope: true
		templateUrl: "/partials/partial.amazon.html"
		controllerAs: "amazonCtrl"
		controller:
			class ItemEditorController
				@$inject: ["$timeout", "$location", "tellybEventService", "tellybStreamService", "$sce", "amazonService"]

				constructor: (@timeout, @location, @eventService, @streamService, @sce, @amazonService) ->
					@isAmazonActive = false
					return

				trustSource: (src) =>
					@sce.trustAsResourceUrl src

				onSearch: (term) =>
					console.log "Should load #{term}"
					@amazonService.search term
					.then (result) =>
						@isAmazonActive = true
						console.log "Amazon results:", result

				onClear: =>
					@isAmazonActive = false

				clickedShowItem: (item) =>
					if item.isActive then item.isActive = false; return
					@amazonService.lookup item
					.then -> item.isActive = true

				clickedAddItem: (item) =>
					@streamService.postAmazonItem item.asin


		link: (scope, elem, attrs)  ->
			return





# Amazon search
# ------------------------------
# @example
# div(sui-amazon-search)
tellybApp.directive "suiAmazonSearch",  ->
	directiveDefinitionObject =
		restrict: "A"
		scope: {
			onSearch: "&"
			onClear: "&"
		}
		template: """
			<div class="ui fluid search">

				<div class="ui right action left icon input">
					<i class="search icon"></i>
					<input class="prompt" type="text" placeholder="Search..." ng-keydown="searchCtrl.pressedKey($event)">
					<div class="ui floating button", ng-click="searchCtrl.clickedSearchOrClear()">
						{{searchCtrl.isSearchActive ? "Clear" : "Search"}}
					</div>
				</div>

				<div class="results"></div>
			</div>
		"""
		controllerAs: "searchCtrl"
		controller:
			class SearchController
				@$inject: ["$scope"]
				constructor: (@scope) ->
					@isSearchActive = false
					return

				pressedKey: (event) =>
					if event.keyCode is 13
						@scope.hideResults()
						@scope.onSearch? {term: @scope.getValue()}

				clickedSearchOrClear: =>
					if @isSearchActive
						@scope.clear()
						@isSearchActive = false
					else
						@scope.hideResults()
						@scope.onSearch? {term: @scope.getValue()}
						@isSearchActive = true



		link: (scope, elem, attrs) ->

			# Add search with autocompletion
			elem.find(".ui.search").search
				apiSettings:
					url: "/amazon/autocomplete?q={query}"
					type: "category"
				minCharacters: 3
				onSelect: (val) ->
					scope.onSearch? {term: val.title}
					scope.searchCtrl.isSearchActive = true

			# Add hide function
			scope.hideResults = ->
				elem.search("hide results")

			scope.getValue = ->
				elem.search("get value")

			scope.clear = ->
				elem.search("set value", "")
				scope.hideResults()
				scope.onClear?()

			return
