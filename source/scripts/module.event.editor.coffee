# Description
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1<





# Event controller
# ------------------------------
tellybApp.controller "EventController",
	class EventController

		# Injection annotation for minimization
		@$inject: ["$q", "$timeout", "$log", "$location", "$scope", "$http", "tellybEventService", "tellybStreamService"]

		# Constructor
		constructor: (@q, @timeout, @log, @location, @scope, @http, @eventService, @streamService) ->
			@initEvent()
			@initStream()
			@view = {
				itemEditorIsEnabled: false
			}
			return

		# Init event data
		initEvent: =>
			path = @location.path()
			eventId = path.split("/").pop()
			@eventService.setEventId eventId

		initStream: =>
			path = @location.path()
			streamId = path.split("/").pop()
			@streamService.loadStream streamId







		clickedEditEvent: (event) =>

			# Only if nothing else is beeing proccessed already
			if @data.processedEvent.data is null
				@data.processedEvent.data = event
				@data.processedEvent.json = angular.toJson event, "   "

		clickedDeleteEvent: (event) =>
			@http.delete "/event/#{event.id}"
				.success (data, status) =>
					_.remove @data.events, event
				.error (data, status) =>
					#TODO: show warning
					return this

		# TODO: Make readonly and add spinner
		# TODO: Remove spinner and make editable again
		# TODO: Add warning on failure
		clickedSaveEvent: =>
			newEvent = angular.fromJson @data.processedEvent.json

			# Send to server
			@http.put "/event/#{@data.processedEvent.data.id}", newEvent
			.success (data, status) =>
				_.assign @data.processedEvent.data, newEvent
				@data.processedEvent.data = null
			.error (data, status) =>
				return this

		clickedNewEvent: =>
			@view.newEvent = true

		clickedSaveNewEvent: =>

			# Try to parse
			newEvent = angular.fromJson @data.newEvent.json

			console.log "Posting: ", newEvent

			@http.post "/event", newEvent
			.success (data, status) =>
				@data.events.push newEvent
				@view.newEvent = false
			.error (data, status) =>
				# TODO: show warning
				return this

		clickedShow: (event) =>
			console.log("Selected:", event)
			showId = event.showId or event.meta.kabeldeutschland.progid
			@location.path "/show/#{showId}"

		clickedCollection: (event) ->
			console.log("Selected:", event)
			# @location.path "/collection/#{collectionId}"





		# Stream
		# ------------------------------
		clickedAddItem: =>
			@view.itemEditorIsEnabled = not @view.itemEditorIsEnabled

		clickedDeleteItem: (item) =>
			@streamService.deleteItem item

		clickedEditItem: (item) =>
			@streamService.editItem item

