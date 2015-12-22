# Main View
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Main controller
# ------------------------------
angular.module "flickstuff"
.controller "FingerprintController",
	class FingerprintController

		# Injection annotation for minimization
		@$inject: ["$location", "$timeout", "$log", "$scope", "$http", "FingerprintService"]

		# Constructor
		constructor: (@location, @timeout, @log, @scope, @http, @fingerprintService) ->
			console.log "Fingerprint controller init"
			@isListeing = false

		clickedListen: =>
			@isListeing = true
			@fingerprintService.startListening()


		clickedListenAbort: =>
			@fingerprintService.stopListening()
			@isListeing = false


.directive "fingerprintComponent", ->
	directiveDefinitionObject =
		restrict: "A"
		require: "?ngModel"
		scope:
			fingerprintOnFind: "&"
		templateUrl:"/components/fingerprint/views/fingerprint.html"
		controller: "FingerprintController"
		controllerAs: "fingerprintCtrl"
		link: (scope, elem, attrs, ngModel) ->

			# Wave
			siriWave = null

			# add siri wave
			addWave = ->
				waveBox = $('#fingerprint-container')
				console.log waveBox.width()
				console.log waveBox.height()

				siriWave = new SiriWave9({
					width: waveBox.width(),
					height: 60,
					speed: 0.2,
					amplitude: 0.7,
					container: document.getElementById('fingerprint-container')
					autostart: true
				})
				scope.stopAnimation = -> siriWave.stop()
				scope.startAnimation = -> siriWave.start()

			# remove
			removeWave = ->
				siriWave?.stop()
				$('#fingerprint-container').empty()

			# resize
			$(window).on 'resize', ->
				if scope.fingerprintCtrl.isListeing
					removeWave()
					addWave()

			# Add wave if listening
			scope.$watch "fingerprintCtrl.isListeing", (newVal, oldVal) ->
				if newVal
					addWave()
				else
					removeWave()

			return
