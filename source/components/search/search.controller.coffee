# Main View
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Main controller
# ------------------------------
angular.module "flickstuff"
.controller "SearchController",
	class SearchController

		# Injection annotation for minimization
		@$inject: ["$window", "$location", "$timeout", "$log", "$scope", "$http"]

		# Constructor
		constructor: (@window, @location, @timeout, @log, @scope, @http) ->
			console.log "Main controller init"
			@simulateQuery = false
			@isDisabled = false

			# list of `state` value/display objects
			@states = @loadAll()

		newState: (state) ->
			alert 'Sorry! You\'ll need to create a Constituion for ' + state + ' first!'
			return

		clickedBack: =>
			@window.history.back()

		###*
		# Search for states... use $timeout to simulate
		# remote dataservice call.
		###
		querySearch: (query) =>
			results = if query then @states.filter(@createFilterFor(query)) else @states
			deferred = undefined
			if @simulateQuery
				deferred = @q.defer()
				$timeout (->
					deferred.resolve results
					return
				), Math.random() * 1000, false
				deferred.promise
			else
				results

		searchTextChange: (text) =>
			@log.info 'Text changed to ' + text
			return

		selectedItemChange: (item) =>
			@log.info 'Item changed to ' + JSON.stringify(item)
			return

		###*
		# Build `states` list of key/value pairs
		###
		loadAll: ->
			allStates = """Alabama, Alaska, Arizona, Arkansas, California, Colorado, Connecticut, Delaware,
			Florida, Georgia, Hawaii, Idaho, Illinois, Indiana, Iowa, Kansas, Kentucky, Louisiana,
			Maine, Maryland, Massachusetts, Michigan, Minnesota, Mississippi, Missouri, Montana,
			Nebraska, Nevada, New Hampshire, New Jersey, New Mexico, New York, North Carolina,
			North Dakota, Ohio, Oklahoma, Oregon, Pennsylvania, Rhode Island, South Carolina,
			South Dakota, Tennessee, Texas, Utah, Vermont, Virginia, Washington, West Virginia,
			Wisconsin, Wyoming"""
			allStates.split(/, +/g).map (state) ->
				{
					value: state.toLowerCase()
					display: state
				}

		###*
		# Create filter function for a query string
		###
		createFilterFor: (query) ->
			lowercaseQuery = angular.lowercase(query)
			(state) ->
				state.value.indexOf(lowercaseQuery) is 0

