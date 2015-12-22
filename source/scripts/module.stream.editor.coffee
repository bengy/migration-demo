# Description
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1<





# Config
# ------------------------------
angular.module "tellyb-app"
.config (wsProvider) ->

	# Set websocket url
	host = window.location.host
	console.log "Socket: #{host}"
	socketUrl = "ws://#{host}"
	wsProvider.setUrl socketUrl
	return





# Amazon controller
# ------------------------------
angular.module "tellyb-app"
.controller "StreamEditorController",
	class StreamEditorController

		# Injection annotation for minimization
		@$inject: ["$timeout", "$log", "$scope", "$http", "ws", "$location", "TellyItemService", "SUIErrorService", "tellybStreamService"]

		# Constructor
		constructor: (@timeout, @log, @scope, @http, @ws, @location, @itemService, @streamService) ->

			# View
			@view =
				warning:
					parsingError: false
					missingStreamIdError: false

				add:
					product:
						generic: null
						byAppleId: null

					social:
						generic: null
						byTweetId: null

			@timers =
				jsonParseErrorTimer: null
				missingStreamIdTimer: null



			# Init websocket
			# @itemService.loadStreamByUrl @location.path()
			url = @location.path()
			streamId = url.substr url.lastIndexOf('/') + 1
			@streamService.loadStream streamId
			return





		# PERODUCTS
		# ------------------------------

		# Add generic product
		clickedAddProductGeneric: =>
			@view.add.product.generic = @itemService.getItemPrototype "PRODUCT"

		# Save button
		clickedAddProductGenericSave: =>
			@itemService.addItemFromJson @view.add.product.generic
			@view.add.product.generic = null
s
		# Reset button
		clickedAddProductGenericReset: =>
			@view.add.product.generic = @itemService.getItemPrototype "PRODUCT"





		# SOCIAL
		# ------------------------------


		# Add generic social item
		clickedSocialItemAddGeneric: =>
			@view.add.social.generic = @itemService.getItemPrototype "SOCIAL"

		# Save social item
		clickedSocialItemAddGenericSave: =>
			@itemService.addItemFromJson @view.add.social.generic
			@view.add.social.generic = null

		# Reset social item
		clickedSocialItemAddGenericReset: =>
			@view.add.social.generic = @itemService.getItemPrototype "SOCIAL"




		# Remove item
		clickedRemoveItem:(item) =>
			@itemService.delteItem item





# Directives
# ------------------------------
tellybApp.directive "editorSegment",  ->
	directiveDefinitionObject =
		restrict: "A"
		scope: true
		templateUrl: "/partials/partial.stream.editor.html"
		controller: "StreamEditorController"
		controllerAs: "editorCtrl"
		link: (scope, elem, attrs)  ->
			return


tellybApp.service "SUIErrorService",
	class ErrorService
		constructor: ->
			@messages = []
			return

		addMessage: (message) =>
			@messages.push message
			@timeout do(message) =>
				@removeMessage message
			, 1000
			return

		removeMessage: (message) =>
			if message in @messages then @messages.splice @messages.indexOf(message), 1
			return

tellybApp.directive "suiError",  ->
	directiveDefinitionObject =
		restrict: "A"
		scope: true
		template: """
		<div class="ui negative message" ng-repeat="message in messageCtrl.messages">
			<i class="close icon" ng-click="messageCtrl.removeMessage(message)"></i>
			<div class="header">
				{{message}}
			</div>
		</p></div>
		"""
		controller:
			class MessageController
				@$inject: ["$timeout", "suiErrorService"]
				constructor: (@timeout, @errorService) ->
					@messages = @errorService.messages
					return

		controllerAs: "messageCtrl"
		link: (scope, elem, attrs)  ->
			return



tellybApp.directive "suiDropdown",  ->
	directiveDefinitionObject =
		restrict: "A"
		scope: true
		link: (scope, elem, attrs)  ->
			$(elem).dropdown()
			return


