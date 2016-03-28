# Event services
#
# *Author:* Dominique Rau
# *Version:* 0.0.1-alpha.0
"use strict"





# Event service
# ------------------------------
app = angular.module "refugee-app"
app.service "TabService",
	class TabService

		# Injection annotation for minimization

		# Constructor
		constructor: ->
			@tabsMap = {}
			return

		setCurrent: (tabsId, index) =>
			@tabsMap[tabsId] = index

		getCurrent: (tabsId) =>
			return @tabsMap[tabsId] or 0
