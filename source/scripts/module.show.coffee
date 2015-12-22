# Show controller
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1<





# Show controller
# ------------------------------
angular.module "tellyb-app"
.controller "ShowController",
	class ShowController

		# Injection annotation for minimization
		@$inject: ["$location", "$timeout", "$log", "$scope", "$http", "showService", "tellybStreamService"]

		# Constructor
		constructor: (@location, @timeout, @log, @scope, @http, @showService, @streamService) ->
			@initShow()
			@initStream()
			@view = {
				itemEditorIsEnabled: false
			}
			return

		# Init show
		initShow: =>
			showId = @location.path().split("/").pop()
			@showService.setShowId showId

		# Init stream
		initStream: =>
			path = @location.path()
			streamId = path.split("/").pop()
			@streamService.loadStream streamId





		# Clickhandler
		# ------------------------------

		# Click on edit event
		clickedDebug: =>
			console.log @showService.storage.show





		# Stream
		# ------------------------------
		clickedAddItem: =>
			@view.itemEditorIsEnabled = not @view.itemEditorIsEnabled

		clickedDeleteItem: (item) =>
			@streamService.deleteItem item

		clickedEditItem: (item) =>
			@streamService.editItem item