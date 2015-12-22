tellybApp.directive "hilightsSegment",  ->
	directiveDefinitionObject =
		restrict: "A"
		scope: true
		templateUrl: "/partials/partial.hilight.hero.html"
		controllerAs: "hilightsCtrl"
		controller:
			class HilightsController
				@$inject: ["$timeout", "$http", "$location"]

				constructor: (@timeout, @http, @location) ->
					@hilights = []

					@loadHilights()
					.then (hilightEventList) =>
						topHilights = _.slice hilightEventList, 0, 4
						Promise.map topHilights, @loadHilightShow
						.then =>
							@hilights = topHilights
					return





				# Clickhandler
				# ------------------------------
				clickedEvent: (hilight) =>
					console.log hilight
					@location.path "/event/#{hilight.id}"





				# REST API
				# ------------------------------
				loadHilights: =>
					@http.get("/events?select=hilights")
					.then (response) ->
						return response.data
					.catch (err) ->
						console.error err
						return []

				loadHilightShow: (hilightEvent) =>
					url = "/show/#{hilightEvent.showId}"
					@http.get(url)
					.then (response) ->
						hilightEvent.show = response.data
					.catch (err) ->
						console.error "Error occurred", err
						hilightEvent.show = null
