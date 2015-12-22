# Main View
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Main controller
# ------------------------------
angular.module "flickstuff"
.controller "EventController",
	class EventController

		# Injection annotation for minimization
		@$inject: ["$window", "$location", "$timeout", "$log", "$scope", "$http", "EventService", "BrowserService"]

		# Constructor
		constructor: (@window, @location, @timeout, @log, @scope, @http, @eventService, @browserService) ->
			console.log "Main controller init"

		clickedBack: =>
			@window.history.back()





# Scroll handler
# ------------------------------
.directive 'scroll', ($window) ->
	(scope, element, attrs) ->

		header = document.querySelector('[md-page-header]')
		baseDimensions = header.getBoundingClientRect()
		title = angular.element(document.querySelector('[md-header-title]'))
		picture = angular.element(document.querySelector('[md-header-picture]'))
		fab = angular.element(document.querySelector('.main-fab'))


		legacyToolbarH = 64
		legacyFabMid = 56 / 2
		titleZoom = 1.6

		### The primary color palette used by Angular Material ###
		primaryColor = [
			63
			81
			181
		]

		styleInit = ->
			title.css 'padding-left', '16px'
			title.css 'position', 'relative'
			title.css 'transform-origin', '24px'
			return

		ratio = (dim) ->
			r = (dim.bottom - (baseDimensions.top)) / dim.height
			if r < 0
				return 0
			if r > 1
				return 1
			num = Number r.toString().match(/^\d+(?:\.\d{0,2})?/)
			console.log "Num: ", num
			return num


		handleStyle = (dim) ->
			fab.css 'top', dim.height - legacyFabMid + 'px'
			if dim.bottom - (baseDimensions.top) > legacyToolbarH
				title.css 'top', dim.bottom - (baseDimensions.top) - legacyToolbarH + 'px'
				element.css 'height', dim.bottom - (baseDimensions.top) + 'px'
				times = (titleZoom - 1) * ratio(dim) + 1
				console.log "times", times
				title.css 'transform', 'scale(' + times + ',' + times + ')'
			else
				title.css 'top', '0px'
				element.css 'height', legacyToolbarH + 'px'
				title.css 'transform', 'scale(1,1)'
			if dim.bottom - (baseDimensions.top) < legacyToolbarH * 2 and !fab.hasClass('hide')
				fab.addClass 'hide'
			if dim.bottom - (baseDimensions.top) > legacyToolbarH * 2 and fab.hasClass('hide')
				fab.removeClass 'hide'
			element.css 'background-color', 'rgba(' + primaryColor[0] + ',' + primaryColor[1] + ',' + primaryColor[2] + ',' + 1 - ratio(dim) + ')'
			picture.css 'background-position', '50% ' + ratio(dim) * 50 + '%'

			### Uncomment the line below if you want shadow inside picture (low performance) ###
			#element.css('box-shadow', '0 -'+(dim.height*3/4)+'px '+(dim.height/2)+'px -'+(dim.height/2)+'px rgba(0,0,0,'+ratio(dim)+') inset');
			return


		styleInit()
		handleStyle baseDimensions

		###Scroll event listener ###
		angular.element($window).bind 'scroll', ->
			handleStyle header.getBoundingClientRect()

		###Resize event listener ###
		angular.element($window).bind 'resize', ->
			baseDimensions = header.getBoundingClientRect()
			handleStyle header.getBoundingClientRect()
