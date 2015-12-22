# Highlights service
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1


angular.module "flickstuff"
.service "BrowserService",
	class BrowserService extends TinyEmitter

		@$inject: ["$location", "$filter", "$timeout", "$log", "$http", "$localStorage", "Restangular"]

		# Constructor
		constructor: (@location, @filter, @timeout, @log, @http, @localStorage, @Restangular) ->
			@url = null
			@init()

		init: =>
			unless @url?
				@setUrl @parseUrl()

		setUrl: (url) =>
			@url = @addHttp url
			console.log "Url: ", @url

		addHttp: (url) ->
			unless _.startsWith url, "http://"
				return "http://#{url}"
			else
				return url

		parseUrl: =>
			path = @location.path()
			url = path.split("/").pop()
			return decodeURIComponent url


.filter 'baseUrl', ["$filter", (filter) ->
	(url) ->
		return url.replace(/(http(s)?:\/\/)|(\/.*){1}/g, '')
]
