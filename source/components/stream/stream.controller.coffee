# Main View
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Main controller
# ------------------------------
angular.module "flickstuff"
.controller "StreamController",
	class StreamController

		# Injection annotation for minimization
		@$inject: ["$window", "$location", "$timeout", "$log", "$scope", "$http", "StreamService", "BrowserService"]

		# Constructor
		constructor: (@window, @location, @timeout, @log, @scope, @http, @streamService, @browserService) ->
			console.log "Stream controller init"

		clickedGeneric: (item) =>
			console.log "Clicked generic: ", item
			url = encodeURIComponent item.meta.generic.data.url
			@browserService.setUrl item.meta.generic.data.url
			@location.path "/browser/#{url}"
			return

		clickedTweet: (item) =>
			url = "https://twitter.com/#{item.meta.twitter.data.author}/status/#{item.meta.twitter.ref}"
			@window.open url, "_blank"
			return
		clickedAmazon: (item) =>
			@window.open item.meta.amazon.data.url, "_blank"
			# url = encodeURIComponent item.meta.amazon.data.url
			# @browserService.setUrl item.meta.amazon.data.url
			# @location.path "/browser/#{url}"
			return

		clickedWikipedia: (item) =>
			@window.open item.meta.wikipedia.data.url, "_blank"
			return

		clickedItunes: (item) =>
			return this

		draggedRight: (item) ->
			console.log "Should save item", item
			return





# Stream
# ------------------------------
.directive "streamComponent", ->
	directiveDefinitionObject =
		restrict: "A"
		scope: true
		templateUrl:"/components/stream/views/stream.html"
		controller: "StreamController"
		controllerAs: "streamCtrl"
		link: (scope, elem, attrs, ngModel) ->
			return



.directive "draggableItem", ["$document", (document) ->
	directiveDefinitionObject =
		restrict: "A"
		scope:
			onClick: "&"
			onDragRight: "&"
			onDragLeft: "&"
		link: (scope, elem, attrs, ngModel) ->

			console.log "Link draggableItem"
			# debugger
			scope.initialMousePosition = null
			scope.initialMouseTime = null
			scope.initialCardX = null
			scope.dX = 0
			scope.isDragging = false
			heartElem = elem.find ".st-item-heart"
			heartIcon = elem.find ".material-icons"
			itemElem = elem.find ".st-item"

			mouseDown = (event) ->
				console.log "Mousedown"
				scope.initialMouseTime = Date.now()
				scope.initialMousePosition = event.screenX or event.originalEvent.pageX

				# Setup heart
				# debugger
				containterHeight = itemElem.height()
				heartHeight = heartElem.height()
				offset = (containterHeight / 2) - (heartHeight / 2)
				heartElem.css top: "#{offset}px"

			mouseMove = (event) ->
				console.log "Scrolling: ", event
				scope.dX = Math.max(Math.min((event.screenX or event.originalEvent.pageX) - scope.initialMousePosition, 100), -100)
				if scope.dX > 10 or scope.dX < -10
					scope.isDragging = true
				console.log scope.dX
				itemElem.css {transform: "translateX(#{scope.dX}px)"}
				heartElem.css {opacity: scope.dX/100}
				heartIcon.css {color:"hsl(119,#{scope.dX}%, 45%)"}

			mouseUp = (event) ->
				if scope.isDragging
					if scope.dX > 50
						scope.$evalAsync ->
							scope.onDragRight()
						console.log "Dragged right"
					if scope.dX < -50
						scope.$evalAsync ->
							scope.onDragLeft()
						console.log "Dragged left"
				else
					if Date.now() - scope.initialMouseTime <= 300
						scope.$evalAsync ->
							scope.onClick()
						console.log "Clicked"
				document.off "mousemove"
				document.off "touchmove"
				itemElem.css {transform: "translateX(0px)"}
				isDragging = false

			# Start dragging
			# itemElem.on "mousedown", (event) ->
			# 	mouseDown event
			# 	document.on "mousemove", mouseMove
			# 	return
			# document.on "mouseup", mouseUp

			# Start dragging
			itemElem.on "touchstart", (event) ->
				console.log "Touch down"
				mouseDown event
				document.on "touchmove", mouseMove
				return
			document.on "touchend", mouseUp
			document.on "touchcancel", mouseUp
]





# Stream
# ------------------------------
.controller "ItemAmazonController",
	class ItemAmazonController
		@$inject: ["$window", "$location", "$timeout", "$log", "$scope", "$http", "StreamService", "BrowserService"]
		constructor: (@window, @location, @timeout, @log, @scope, @http, @streamService, @browserService) ->
			console.log "Amazon item: ", @scope.item.info.title

.directive "itemAmazon", ->
	directiveDefinitionObject =
		restrict: "A"
		scope:
			item: "="
		templateUrl:"/components/stream/views/item.amazon.html"
		controller: "ItemAmazonController"
		controllerAs: "itemAmazonCtrl"
		link: (scope, elem, attrs, ngModel) ->
			return

.directive "itemWikipedia", ->
	directiveDefinitionObject =
		restrict: "A"
		scope:
			item: "="
		templateUrl:"/components/stream/views/item.wikipedia.html"
		link: (scope, elem, attrs, ngModel) ->
			return


.directive "itemTwitter", ->
	directiveDefinitionObject =
		restrict: "A"
		scope:
			item: "="
		templateUrl:"/components/stream/views/item.twitter.html"
		link: (scope, elem, attrs, ngModel) ->
			return

.directive "itemItunes", ->
	directiveDefinitionObject =
		restrict: "A"
		scope:
			item: "="
		templateUrl:"/components/stream/views/item.itunes.html"
		link: (scope, elem, attrs, ngModel) ->
			# elem.on "click", ->
				# url = "https://twitter.com/#{scope.item.meta.twitter.data.author}/status/#{scope.item.meta.twitter.ref}"
				# window.open url, "_blank"
			return

.directive "itemGeneric", ->
	directiveDefinitionObject =
		restrict: "A"
		scope:
			item: "="
		templateUrl:"/components/stream/views/item.generic.html"
		link: (scope, elem, attrs, ngModel) ->
			# elem.on "click", ->
				# url = "https://twitter.com/#{scope.item.meta.twitter.data.author}/status/#{scope.item.meta.twitter.ref}"
				# window.open url, "_blank"
			return


.filter "priceFromCents", ["$filter", (filter) ->
	(cent) ->
		centString = "#{cent}"
		cent = centString.substr(centString.length-2, centString.length)
		euro = centString.substr(0, centString.length-2)
		return "#{euro}.#{cent}€"
]