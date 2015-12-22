# Fingerprint service
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1


angular.module "flickstuff"
.service "FingerprintService",
	class FingerprintService extends TinyEmitter

		@$inject: ["$filter", "$timeout", "$log", "$http", "$localStorage", "Restangular"]

		# Constructor
		constructor: (@filter, @timeout, @log, @http, @localStorage, @Restangular) ->
			@recorder = null
			@audioContext = null
			return

		startListening: =>
			console.log "Start listening"
			try
				# webkit shim
				window.AudioContext = window.AudioContext or window.webkitAudioContext
				navigator.getUserMedia = navigator.getUserMedia or navigator.webkitGetUserMedia or navigator.mozGetUserMedia or navigator.msGetUserMedia
				window.URL = window.URL or window.webkitURL
				@audioContext = new AudioContext
				console.log 'Audio context set up.'
				console.log 'navigator.getUserMedia ' + (if navigator.webkitGetUserMedia then 'available.' else 'not present!')

				navigator.webkitGetUserMedia {audio: true}, @startUserMedia, (e) ->
					console.log 'No live audio input: ' + e
			catch e
				console.log 'No web audio support in this browser!'
				console.error e

		stopListening: =>
			@recorder.stop()
			@createDownloadLink()
			# @recorder?.exportWAV (blob) ->
			# 	Recorder.forceDownload blob
			return

		startUserMedia: (stream) =>
			input = @audioContext.createMediaStreamSource(stream)
			@recorder = new Recorder(input, {workerPath: "js/recorderWorker.js", numChannels: 1})
			@recorder?.record()
			return

		startSampling: =>
			return this

		createDownloadLink: =>
			console.log "Creating download link"
			console.log @recorder
			@recorder?.exportWAV (blob) ->
				url = URL.createObjectURL(blob)
				li = document.createElement('li')
				au = document.createElement('audio')
				hf = document.createElement('a')
				au.controls = true
				au.src = url
				hf.href = url
				hf.download = (new Date).toISOString() + '.wav'
				hf.innerHTML = hf.download
				li.appendChild au
				li.appendChild hf
				$("#reclist").append li
				return

			return