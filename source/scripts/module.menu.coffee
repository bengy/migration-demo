# MenuController
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# Menu controller
# ------------------------------
angular.module "tellyb-app"
.directive "tellybMenu", ->
	directiveDefinitionObject =
		restrict: "A"
		scope:
			onSearchTextChange: "&"
		templateUrl:"/partials/partial.menu.html"
		link: (scope, elem, attrs) ->

			# sscope.onSearchTextChange = (e) ->

