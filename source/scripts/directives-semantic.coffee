# Fileheader
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.3.1





# Semantic-UI Module
# ------------------------------
angular.module "ui.semantic", []





# SEMANTIC SEARCH
# ------------------------------
	#
	# @abstract
	# ☐
	#
	# @example
	# div(
	#     sui-search,
	# 		endpoint-url="custom-search/?q={query}"
	#
	# @version 1.1.2
.directive "suiSearch",  ->
	directiveDefinitionObject =
		restrict: "A"
		scope: true
		template: """
			<div class="ui search">
				<div class="ui icon input">
					<input class="prompt" type="text" placeholder="Search...">
					<i class="search icon"></i>
				</div>
				<div class="results"></div>
			</div>
		"""
		controllerAs: "searchCtrl"
		controller:
			class SearchController
				constructor: ->
					retur

		link: (scope, elem, attrs, ngModelCtrl) ->
			elem.find(".ui.search").search
				apiSettings: if attrs.endpointUrl then url: attrs.endpointUrl
				type: "category"
			return





# SEMANTIC CALENDAR
# ------------------------------
	#
	# @abstract
	# ☐
	#
	# @example
	# div(
	#     sui-calendar,
	# 		ng-model="path.to.date.model")
	#
	# @version 1.1.2
.directive "suiCalendar",  ->
	directiveDefinitionObject =
		restrict: "A"
		scope:
			suiOptions: "="
			suiOnChange: "&"
		require: "?ngModel"
		template: """
			<div class="ui grid">
				<div class="row">
					<div class="five wide column">
						<div class="ui circular basic icon tiny button" ng-click="calendarCtrl.clickedPrevMonth()">
							<i class="icon left arrow"/>
						</div>
					</div>
					<div class="six wide center aligned column">
						<div class="ui header">
							{{calendarCtrl.displayDay}}. {{calendarCtrl.displayMonth}} {{calendarCtrl.displayYear}}
						</div>
					</div>
					<div class="five wide right aligned column">
						<div class="ui basic icon tiny button" ng-click="calendarCtrl.clickedToday()">
							Today
						</div>
						<div class="ui circular basic icon tiny button" ng-click="calendarCtrl.clickedNextMonth()">
							<i class="icon right arrow"/>
						</div>
					</div>
				</div>
				<div class="seven column row">
					<div ng-repeat="weekday in calendarCtrl.weekDays track by $index" class="center aligned column">
						{{weekday}}
					</div>
				</div>
				<div ng-repeat="week in calendarCtrl.weeks track by $index" class="seven column row">
					<div ng-repeat="day in week track by $index" class="column">
						<div
							class="ui fluid small button"
							ng-class="{'basic':day.isInMonth && !day.isSelected, 'blue':day.isSelected}"
							ng-click="calendarCtrl.selectDate(day)">
							{{day.dateString}}
						</div>
					</div>
				</div>
			</div>
		"""
		controllerAs: "calendarCtrl"
		controller:
			class ItemEditorController
				@$inject: ["$timeout",  "$location"]

				# Constructor
				constructor: (@timeout, @location) ->
					@weekDays = ["M", "D", "M", "D", "F", "S", "S"]
					@loadDate new Date()

				selectDate: (day) =>
					@loadDate day.date

				clickedNextMonth: =>
					@loadDate @selected.clone().add(1, "months").toDate()

				clickedPrevMonth: =>
					@loadDate @selected.clone().subtract(1, "months").toDate()

				clickedToday: =>
					@loadDate new Date()

				loadDate: (date) =>

					# Set selected
					@selected = moment(date)
					@displayDay = @selected.format "DD"
					@displayMonth = @selected.format "MMMM"
					@displayYear = @selected.format "YYYY"

					# Calc offsets
					firstOfMonth = @selected.clone().date 1
					offset = firstOfMonth.day() #0-6
					offset = if offset is 0 then 6 else offset
					first = firstOfMonth.clone().subtract(offset, "days")

					# Calc weekdays
					@weeks = new Array(6)
					for i in [0...6]
						@weeks[i] = new Array(7)
						for j in [0...7]
							date = first.clone().add(i*7+j, "days")
							@weeks[i][j] = {
								date: date
								dateString: date.format("DD")
								isInMonth: firstOfMonth.isSame(date, "month")
								isSelected: @selected.isSame(date, "day")
							}
					return


		link: (scope, elem, attrs, ngModelCtrl) ->

			# Connect model if there
			if ngModelCtrl?

				ngModelCtrl.$render = ->
					console.log "Rendering date: ", ngModelCtrl.$modelValue
					scope.calendarCtrl.loadDate ngModelCtrl.$modelValue if ngModelCtrl.$modelValue?

				scope.$watch "calendarCtrl.selected", (newVal, oldVal) ->
					unless _.isEqual oldVal, newVal
						console.log "date changed: ", newVal.toDate()
						ngModelCtrl.$setViewValue newVal.toDate()
			return





# SEMANTIC CHECKBOX
# ------------------------------
	#
	# @abstract
	# ☐ Add input child if not there
	#
	# @example
	# .ui.checkbox(
	# 		sui-one-checkbox,
	# 		sui-one-checkbox-on-toggle="callback(checked)"
	# 		ng-model="path.to.model")
	# 		input(type="checkbox")
	# 		label Labeltext
	#
	# @version 1.1.2
.directive "suiCheckbox", ->
	directiveDefinitionObject =
		restrict: "A"
		require: "?ngModel"
		scope:
			suiOnChange: "&"
		link: (scope, elem, attrs, ngModel) ->

			# UI >> MODEL
			elem.checkbox
				fireOnInit:false
				onChecked: ->
					scope.$apply ->
						ngModel.$setViewValue true
						scope.suiOnChange? {checked: true}

				onUnchecked: ->
					scope.$apply ->
						ngModel.$setViewValue false
						scope.suiOnChange? {checked: false}

			# MODEL >> UI
			ngModel?.$render = ->
				elem.find("input").prop "checked", ngModel.$modelValue





# DROPDOWN SELECTION
# ------------------------------
	# @abstract
	# ☐ Make ngModel optional
	#
	# @example Dropdownbutton
	# .ui.dropdown.button(
	# 		sui-selection,
	# 		sui-on-change="callback(selected)"
	# 		sui-options="path.to.options"
	# 		ng-model="path.to.model")
	#
	#
	# @example Dropdown selection
	# .ui.dropdown.selection(
	# 		sui-selection,
	# 		sui-on-change="callback(selected)"
	# 		sui-options="path.to.options"
	# 		ng-model="path.to.model")
	#
	# @version 1.1.2
.directive "suiSelection", ->
	directiveDefinitionObject =
		restrict: "A"
		require: "?ngModel"
		scope:
			suiOptions: "="
			suiPlaceholder: "@"
			suiOnChange: "&"
		template: """
			<input type="hidden">
			<i class="dropdown icon"></i>
			<div class="default text">{{suiPlaceholder}}</div>
			<div class="menu">
				<div class="item" ng-repeat="opt in suiOptions" ng-value="opt">{{opt}}</div>
			</div>
		"""
		link: (scope, elem, attrs, ngModel) ->

			# UI >> MODEL
			elem.dropdown
				fireOnInit:false
				onChange: (val, text, choice) ->
					scope.$apply ->
						ngModel.$setViewValue text
						scope.suiOnChange? {selected: text}
						ngModel.$render()

			# MODEL >> UI
			ngModel?.$render = ->
				elem.find(".text").text ngModel.$modelValue





# DROPDOWN SELECTION
# ------------------------------
	# @abstract
	#
	# @example Dropdownbutton
	# .ui.dropdown.fluid.search.selection(
	# 		ng-model="ssel",
	# 		sui-search-selection,
	# 		sui-options="optionss",
	# 		sui-on-change="selected"
	# 		sui-placeholder="Test1",
	# 		sui-freetext) <- optional
	#
	# @version 1.1.2
.directive "suiSearchSelection", ->
	directiveDefinitionObject =
		restrict: "A"
		require: "?ngModel"
		scope:
			suiOptions: "="
			suiPlaceholder: "@"
			suiOnChange: "&"
			suiFreetext: "="
		template: """
			<input type="hidden">
			<i class="dropdown icon"></i>
			<div class="default text">{{suiPlaceholder}}</div>
			<div class="menu">
				<div class="item" ng-repeat="opt in suiOptions" ng-value="opt">{{opt}}</div>
			</div>
		"""
		link: (scope, elem, attrs, ngModel) ->

			# UI >> MODEL
			elem.dropdown
				fireOnInit:false
				onChange: (val, text, choice) ->
					scope.$apply ->
						ngModel?.$setViewValue? text
						scope.suiOnChange? {selected: text}
						ngModel?.$render?()

			# Change on blur
			elem.find("input")
			.blur ->
				newVal = $(this).val()
				if newVal isnt "" and attrs.suiFreetext?
					ngModel?.$setViewValue? newVal
					scope.suiOnChange? {selected: newVal}
					ngModel?.$render?()

			# MODEL >> UI
			ngModel?.$render = ->
				elem.find(".text").val ngModel?.$modelValue





# DROPDOWN SELECTION
# ------------------------------
	#
	# @example Dropdownbutton
	# .ui.dropdown.button(
	# 		sui-dropdown-button,
	# 		sui-on-change="callback(selected)"
	# 		sui-options="path.to.options")
	#
	# @version 1.1.2
.directive "sui-Dropdown-Button", ->
	directiveDefinitionObject =
		restrict: "A"
		transclude:true
		scope:
			suiOptions: "="
			suiOnChange: "&"
		template: """
			<input type="hidden">
			<div class="menu">
				<div class="item" ng-repeat="opt in suiOptions" ng-value="opt">{{opt}}</div>
			</div>
		"""
		link: (scope, elem, attrs, ngModel) ->

			# UI >> MODEL
			elem.dropdown
				fireOnInit:false
				action: 'hide'
				onChange: (val, text, choice) ->
					scope.$apply ->
						scope.suiOnChange? {selected: text}

















# To verify
# ===============================





# SEMANTIC UPLOAD
# ------------------------------
	#
	# @abstract
	# ☐ Example is wrong!!!
	#
	# @example
	# .ui.checkbox(
	# 		sui-upload,
	# 		sui-one-checkbox-on-toggle="callback(checked)"
	# 		ng-model="path.to.model")
	# 		input(type="checkbox")
	# 		label Labeltext
	#
	# @version 1.1.2
.directive 'suiUpload', ($http) ->
	directiveDefinitionObject=
		restrict:   'A'
		replace:    false
		transclude: true
		scope:
			suiOnChange: "&"
		template: """
			<input type="file" style=";opacity:0; position:absolute; width:100%; height:100%; top:0; left:0;">
			</input>
		"""
		link: (scope, element, attrs, ngModel) ->

			# Add change handler
			element.on "change", (changeEvent) ->
				filePath = _.first changeEvent.target.files
				reader = new FileReader()
				reader.onload = (loadEvent) ->
					scope.$apply scope.suiOnChange? {fileContent: loadEvent.target.result}
				reader.readAsText(filePath)





# SEMANTIC PROGRESSBAR
# ------------------------------
	# ☐ Use ngModel
.directive 'suiProgressbar', ->
	directiveDefinitionObject =
		restrict: 'A'
		scope:
			width: '='
		template:
			'<div class="bar"></div>'

		# Link
		link: (scope, elem, attrs) ->

			# Register event hanlder
			scope.$watch 'width', (newVal, oldVal) ->
				unless newVal is oldVal
					percent = parseInt(scope.width)
					unless isNaN(percent)
						percent = Math.max(Math.min(100, percent), 0)
					else
						percent = 0
					elem
					.find '.bar'
					.width("#{percent}%")





# SEMANTIC SIDEBAR
# ------------------------------
.directive 'suiSidebar', ->
	directiveDefinitionObject =
		link: (scope, elem, attrs) ->
			targetSidebar = attrs.suiSidebar ? 'ui.sidebar'
			behaviour = attrs.behaviour ? 'toggle'
			elem.on 'click', ->
				$ targetSidebar
				.sidebar behaviour
				return
			return





# SEMANTIC MODAL
# ------------------------------
	# ☐ Don't use setting like this
.directive 'suiModalToggle', ->
	directiveDefinitionObject =
		scope:
			suiModalCtrl: "="
		link: (scope, elem, attrs) ->
			console.log "This should be called"

			# Init modal
			modalTarget = attrs.suiModalToggle ? '.ui.modal'
			modalTargetElem = $(modalTarget)
			modalTargetElem.modal
				transition: "fade down"

			# Register click hanlder
			elem.on 'click', ->
				modalTargetElem.modal 'toggle'
				return

			# Add modal controller
			console.log "Before Scope:", scope
			scope.suiModalCtrl ?= {}
			scope.suiModalCtrl.showModal = ->
				modalTargetElem.modal "show"

			scope.suiModalCtrl.hideModal = ->
				console.log "Clicked hide modal"
				modalTargetElem.modal "hide"
			console.log "After Scope:", scope
			return



.service "suiTabService",
	class TabService

		# Stream service
		constructor: ->
			@tabControllers = {}
			return

		addTabController: (ctrlName, tabCtrl) =>
			@tabControllers[ctrlName] = tabCtrl

		setActiveTab: (ctrlName, tabName) =>
			@tabControllers[ctrlName]?.setActive tabName





.directive "suiTabs", ->
	directiveDefinitionObject =
		restrict: "A"
		transclude: true
		scope:true
		template: """
			<div ng-transclude/>
		"""
		controllerAs: "suiTabController"
		controller:
			class TabController
				@$inject: ["$timeout", "suiTabService"]
				constructor: (@timeout, @tabService) ->
					@tabs = {}

				registerTabService: (ctrlName) =>
					@tabService?.addTabController ctrlName, this

				setActive: (tabName) =>
					angular.forEach @tabs, (t) ->
						t.menu?.selected = false
						t.pane?.selected = false
					@tabs[tabName]?.menu?.selected = true
					@tabs[tabName]?.pane?.selected = true

				addMenu: (name, menu) =>
					@tabs[name] ?= {}
					@tabs[name].menu = menu
					if Object.keys(@tabs).length is 1 or @tabs[name].pane?.selected
						@setActive name

				addPane: (name, pane) =>
					@tabs[name] ?= {}
					@tabs[name].pane = pane
					if Object.keys(@tabs).length is 1 or @tabs[name].menu?.selected
						@setActive name


		link: (scope, elem, attrs, tabController) ->
			if attrs.suiTabs?
				tabController.registerTabService attrs.suiTabs


.directive "suiTab", ->
	directiveDefinitionObject =
		restrict: "A"
		require : "^suiTabs"
		transclude: true
		replace: true
		scope: {
			title: "@"
		}
		template: """
			<a class="item" ng-class="{active:selected}" ng-transclude ng-bind="title"></a>
		"""
		link: (scope, elem, attrs, suiTabCtrl) ->
			suiTabCtrl.addMenu(attrs.suiTab, scope)

			# Do not use ng-click in directive, so users can use it on tab
			elem.on "click", ->
				scope.$evalAsync ->
					suiTabCtrl.setActive(attrs.suiTab)

			# scope.clickedTab = ->
			# 	console.log "Clicked tab"
			# 	suiTabCtrl.setActive(attrs.suiTab)


.directive "suiPane", ->
	directiveDefinitionObject =
		restrict: "A"
		require : "^suiTabs"
		transclude: true
		scope: {}
		replace: true
		template: """
			<div class="ui bottom attached tab segment" ng-class="{active:selected}" ng-transclude></div>
		"""
		link: (scope, elem, attrs, suiTabCtrl) ->
			suiTabCtrl.addPane(attrs.suiPane, scope)





# NATIVE ELEMENTS FOR TESTING
# ===============================
.directive 'suiCheckboxNative', ->
	directiveDefinitionObject =
		link: (scope, elem, attrs) ->
			elem.checkbox()
			return

.directive 'suiAccordionNative', ->
	directiveDefinitionObject =
		link: (scope, elem, attrs) ->
			elem.accordion()
			return

.directive 'suiDropdownNative', ->
	directiveDefinitionObject =
		restrict: 'A'
		link: (scope, elem, attrs) ->
			elem.dropdown()
			return

.directive 'suiTabNative', ->
	directiveDefinitionObject =
		link: (scope, elem, attrs) ->
			elem.tab()
			return


.directive "suiCalendar1", ->
	directiveDefinitionObject =
		restrict: "A"
		require: "?ngModel"
		scope:
			suiOptions: "="
			suiOnChange: "&"
		template: """
			<input type="date">
			<div class="ui grid">
				<div class="seven column row">
					<div ng-repeat="weekday in calendarCtrl.weekDays" class="column">
						{{weekday}}
					</div>
					<pre>
					</pre>
				</div>
			</div>
		"""

		controllerAs: "calendarCtrl1"
		controller: ->
			class ItemEditorController
				@$inject: ["$timeout", "tellybStreamService",  "$location", "suiTabService"]

				constructor: (@timeout, @streamService, @location, @tabService) ->
					return

			# class CalendarController
			# 	@$inject: ["$timeout"]
			# 	constructor: (@timeout) ->
			# 		console.log this
			# 		@weekDays = ["M", "D", "M", "D", "F", "S", "S"]
			# 		@weeks = []


		link: (scope, elem, attrs, ngModel) ->

			# UI MODEL
			# elem.dropdown
			# 	fireOnInit:false
			# 	onChange: (val, text, choice) ->
			# 		scope.$apply ->
			# 			ngModel?.$setViewValue? text
			# 			scope.suiOnChange? {selected: text}
			# 			ngModel?.$render?()

			# # Change on blur
			# input = elem.find("input")
			# input.blur ->
			# 	newVal = $(input).val()
			# 	if newVal isnt "" and attrs.suiFreetext?
			# 		ngModel?.$setViewValue? newVal
			# 		scope.suiOnChange? {selected: newVal}
			# 		ngModel?.$render?()

			# # MODEL UI
			# ngModel?.$render = ->
			# 	elem.find(".text").val ngModel?.$modelValue











# Implementation without javascript
# ===============================





# Semantic Selection
# ------------------------------
	#
	# @abstract
	# 		This directive will translate to selection dropdown.
	#
	# @example
	#		div(sui-selection="[Object]", sui-options="[Array]", sui-on-change="[Function]")
	#
	# @todo
	# 		- Animate the menu
	# 		- Exec callback if provided
	#
	# @version 0.0.1
# .directive 'suiSelectionOwn', () ->
# 	directiveDefinitionObject =
# 		restrict: 'A'
# 		scope:
# 			suiSelection: '='
# 			suiOptions: '='
# 			suiOnChange: '&'
# 		templateUrl: '/directives/directive-semselection.html' # Generated by jade

# 		# Add click hanlder
# 		link: (scope, elem, attrs) ->
# 			scope._dropDownShowing = false
# 			scope.suiSelection = scope.suiSelection or (scope.suiOptions and scope.suiOptions[0])
# 			scope._onSelect = (option) ->
# 				scope._default = false
# 				scope.suiSelection = option
# 				scope.suiOnChange? {option: option}
# 				return
# 			return





# Semantic Dropdown
# ------------------------------
	#
	# @abstract
	# 		This directive will add dropdown show and hide functionality
	# 		to given '.ui.dropdown' instance.
	#
	# @example
	#		.ui.dropdown(sui-selection)
	#			.menu
	#				.item Test
	#
	# @todo
	# 		- Animate the menu
	#
	# @version 0.0.1
# .directive 'suiDropdownOwn', ->
# 	directiveDefinitionObject=
# 		restrict: 'A'
# 		transclude: true
# 		link: (scope, elem, attrs, nullController, transclude) ->

# 			# Show and hide on click
# 			elem.on 'click', ->
# 				elem.toggleClass 'active'
# 				elem.toggleClass 'visible'
# 				return

# 			# Transclude all
# 			transclude scope, (clone) ->
# 				elem.append clone
# 				return
# 			return






















# FOR REFERENCE ONLY
# ===============================





	# Semantic Selection Textbox
	# ------------------------------
	# .directive 'suiSelectionText', () ->
	# 	directiveDefinitionObject =
	# 		restrict: 'A'
	# 		scope:
	# 			suiSelection: '='
	# 			suiOptions: '='
	# 			suiOnChange: '&'
	# 		templateUrl: '/directives/directive-semselectiontext.html' # Generated by jade

	# 		# Add click hanlder
	# 		link: (scope, elem, attrs) ->
	# 			scope._dropDownShowing = false
	# 			scope.suiSelectionText = scope.suiSelectionText or (scope.suiOptions and scope.suiOptions[0])
	# 			scope._onSelect = (option) ->
	# 				scope.suiSelectionText = option
	# 				scope.suiOnChange? {option: option}
	# 				return
	# 			return






	# ------------------------------
	# .directive 'extrasuiSelection', ($timeout) ->
	# 	directiveDefinitionObject =
	# 		restrict: 'A'
	# 		controller: ($scope) ->

	# 			$scope.model = ''

	# 			# Data for view state
	# 			$scope.view = {}
	# 			$scope.view.showDropdown = false
	# 			$scope.view.pristine = true

	# 			# Select item
	# 			$scope.selectValue = (value, event) ->
	# 				$scope.model = value
	# 				$scope.view.pristine = false
	# 				$scope.view.showDropdown = false

	# 				# Callback with value
	# 				$scope.suiOnChange()(value)

	# 				# Prevent reopening as the item is under the menu
	# 				event.stopPropagation()
	# 				return
	# 		require: '?ngModel'
	# 		scope:
	# 			# ngModel: '='	# String with value
	# 			suiOptions: '='	# Array with options
	# 			suiOnChange: '&'	# Callback function

	# 		template:
	# 			'<div class="ui fluid selection dropdown" ng-class="{visible: view.showDropdown}",
	# 				ng-click="view.showDropdown = !view.showDropdown">
	# 				<div class="text" ng-class="{default:pristine}">{{model}}</div>
	# 				<i class="dropdown icon"></i>
	# 				<div class="menu">
	# 					<div class="item" ng-repeat="opt in suiOptions track by $index" ng-click="selectValue(opt, $event)" >
	# 						{{opt}}
	# 						</div>
	# 				</div>
	# 			</div>'

	# 		link: (scope, elem, attrs, ngModel) ->
	# 			scope.model = ngModel.$modelValue
	# 			scope.$watch 'model', (newVal, oldVal) ->
	# 				if (newVal != oldVal)
	# 					ngModel.$setViewValue(newVal)
	# 			return





	#
	# ------------------------------
	# .directive 'nextuiSelection', ($timeout) ->
	# 	directiveDefinitionObject =
	# 		restrict: 'A'
	# 		require: '?ngModel'
	# 		scope:
	# 			# ngModel: '='	# String with value
	# 			suiOptions: '='	# Array with options
	# 			suiOnChange: '&'	# Callback function

	# 		template:
	# 			'<div class="ui fluid selection dropdown" ng-class="{visible: view.showDropdown}",
	# 				ng-click="view.showDropdown = !view.showDropdown">
	# 				<div class="text"></div>
	# 				<i class="dropdown icon"></i>
	# 				<div class="menu">
	# 					<div class="item" ng-repeat="opt in suiOptions track by $index" ng-click="selectValue(opt, $event)" >
	# 						{{opt}}
	# 					</div>
	# 				</div>
	# 			</div>'

	# 		link: (scope, elem, attrs, ngModel) ->
	# 			if not ngModel then return

	# 			# Specify how UI should be updated
	# 			ngModel.$render = () ->
	# 				$('.text', elem).text(ngModel.$viewValue)
	# 				return

	# 			# Listen for change events to enable binding
	# 			element.dropdown 'setting', 'onChange' , (val, text) ->
	# 			 	scope.$apply(selected(val))
	# 			selected('Default') # initialize

	# 			selected = (val) ->
	# 				ngModel.$setViewValue(val)

	# 			$timeout (->$('.ui.dropdown', elem).dropdown()), 400

	# 			return





	# SEMANTIC DROPDOWN
	# ------------------------------
		#
		# @abstract
		# ☐ Make ngModel optional
		#
		# @example
		# div(
		# 		sui-dropdown,
		# 		sui-on-change="callback(checked)"
		# 		ng-model="path.to.model"
		# 	)
		#
		# @version 1.1.2
	# .directive "suiOneNotworking", ->
	# 	directiveDefinitionObject =
	# 		restrict: "A"
	# 		require: "ngModel"
	# 		scope:
	# 			suiOptions:"="
	# 		template:"""
	# 			<select class="ui fluid dropdown">
	# 			</select>
	# 		"""
	# 		link: (scope, elem, attrs, ngModel) ->

	# 			# Render options
	# 			renderOptions = ->
	# 				console.log "Rendering"
	# 				# Get selection element
	# 				selectElem = $(elem).find("select")

	# 				# Remove old options
	# 				selectElem.dropdown "destroy"
	# 				selectElem.empty()

	# 				# Check for elements
	# 				unless scope.suiOptions?.length? > 0 then return

	# 				# Add items
	# 				for opt in scope.suiOptions
	# 					selectElem.append $('<option></option>').val(opt).html(opt)

	# 				# Enable dropdown and add callbacks
	# 				selectElem.dropdown "setting",
	# 					onChange: (value, text) ->
	# 						unless scope.$$phase then scope.$apply ->
	# 							ngModel.$setViewValue text


	# 			# Render initial
	# 			scope.$watch "suiOptions", (newVal, oldVal) ->
	# 				if newVal isnt oldVal
	# 					renderOptions()
	# 			renderOptions()

	# 			# Render model changes
	# 			ngModel.$render = ->
	# 				console.log "Rendering selection"
	# 				$(elem).checkbox "set text", ngModel.$modelValue
	# 			return


	# .directive "suiSelectionDropdown", ->
	# 	directiveDefinitionObject =
	# 		restrict: "A"
	# 		require: "?ngModel"
	# 		scope:
	# 			suiDefaultText: "@"
	# 			suiOptions: "@"
	# 			suiOnChange: "&"
	# 		template:"""
	# .directive "suiSelectionDropdownxxx", ->
	# 	directiveDefinitionObject =
	# 		restrict: "A"
	# 		require: "ngModel"
	# 		scope:
	# 			suiOptions:"="
	# 		template:"""
	# 			span TEST
	# 			<div class="ui selection dropdown">
	# 				<input type="hidden" name="">
	# 				<i class="dropdown icon"></i>
	# 				<div class="default text">Gender</div>
	# 				<div class="menu">
	# 					<div ng-repeat="opt in suiOptions" class="item" data-value="{{opt}}">
	# 						{{opt}}
	# 					</div>
	# 				</div>
	# 			</div>
	# 		"""
	# 		link: (scope, elem, attrs, ngModel) ->

				# UI >> MODEL
				# elem
				# .find(".ui.selection.dropdown")
				# .dropdown
				# 	onChange: (val, text) ->
				# 		scope.$apply ->
				# 			ngModel?.$setViewValue = text
				# 			scope.suiOnChange? {selected: text}

				# # MODEL >> UI
				# ngModel?.render = ->
				# 	return
					# Set input
					# Mark selected active
					# Set text





	#
	# ------------------------------
	# .directive 'suiSelection', ($timeout) ->
	# 	directiveDefinitionObject =
	# 		restrict: 'A'
	# 		scope:
	# 			ngModel: '='
	# 			suiOptions: '='
	# 			suiDefault: '@'
	# 			suiOnChange: '&'
	# 		template:
	# 			'<div class="ui fluid selection dropdown">
	# 				<div class="default text">{{suiDefault}}</div>
	# 				<i class="dropdown icon"></i>
	# 				<div class="menu">
	# 					<div class="item" data-value="{{opt}}" ng-repeat="opt in suiOptions track by $index">{{opt}}</div>
	# 				</div>
	# 			</div>'
	# 		link: (scope, elem, attrs) ->

	# 			# Add timeout to make it work
	# 			# TODO: Figure out way without timeout
	# 			$timeout (->
	# 				$('.ui.dropdown', elem)
	# 					.dropdown('setting', 'onChange', (value, text) ->
	# 						console.log "selct changed: ", value, text
	# 						scope.suiOnChange()(value, text) if attrs.suiOnChange?
	# 						scope.ngModel = value
	# 						scope.$apply()
	# 					)
	# 			), 400
	# 			return












	# .directive 'suiCheckboxv2', ->
	# 	directiveDefinitionObject =
	# 		template: '<input type="checkbox", ng-checked="_checkboxChecked">
	# 					  <label ng-click="_checkboxChecked = !_checkboxChecked">Test</label>'
	# 		link: (scope, elem, attrs) ->
	# 			scope._checkboxChecked = false







	# # suiCheckbox="checkBoxBoolean", suiLabel="string", suiClass="class"
	# .directive 'suiCheckboxv3', ->
	# 	directiveDefinitionObject =
	# 		template: """
	# 			<div class="ui checkbox", ng-class="{{suiClass}}">
	# 				<input type="checkbox", ng-checked="suiCheckboxv3">
	# 				<label ng-click="suiCheckboxv3 = !suiCheckboxv3", ng-transclude></label>
	# 			</div>
	# 			"""
	# 		scope: {
	# 			suiCheckboxv3: '=suiCheckboxv3'
	# 			suiClass: '=suiClass'
	# 		}
	# 		replace: true
	# 		transclude: true
	# 		# link: (scope, elem, attrs) ->
	# 		# 	console.log scope.suiCheckboxv3
	# 		# 	scope._checkboxChecked = scope.suiCheckboxv3 or false










	# # ------------------------------
	# # CHECKBOX v1.1.2
	# .directive "suiOnePlainCheckbox", ->
	# 	directiveDefinitionObject =
	# 		restrict: "A"
	# 		link: (scope, elem, attrs) ->
	# 			$(elem).checkbox()









	# # CHECKBOX v1.1.2
	# .directive "suiOneCheckboxv", ->
	# 	directiveDefinitionObject =
	# 		restrict: "A"
	# 		scope:
	# 			suiCheckbox: "="
	# 			suiOnChange: "&"
	# 		link: (scope, elem, attrs) ->

	# 			# Enable checkbox
	# 			$(elem).checkbox()

	# 			# If sui seleciton is available
	# 			if scope.suiCheckbox?

	# 				# Set initial value
	# 				if scope.suiCheckbox
	# 					$(elem).checkbox("check")

	# 				# Add watcher
	# 				scope.$watch "suiCheckbox", (newVal, oldVal) ->
	# 					if newVal?
	# 						scope.suiOnChange? {selected: newVal}
	# 						if newVal is true
	# 							$(elem).checkbox("check")
	# 						else
	# 							$(elem).checkbox("uncheck")

	# 				# Add change listener
	# 				$(elem).on "onChecked", ->
	# 					scope.$apply ->
	# 						scope.suiOnChange? {selected: true}
	# 						scope.suiCheckbox = true

	# 				$(elem).on "onUnchecked", ->
	# 					scope.$apply ->
	# 						scope.suiOnChange? {selected: false}
	# 						scope.suiCheckbox = false













	# # Semantic Checkbox
	# # ------------------------------
	# .directive 'suiCheckboxx', ->
	# 	directiveDefinitionObject=
	# 		restrict: 'A'
	# 		replace: true
	# 		transclude: true
	# 		scope:
	# 			suiCheckbox: "="
	# 			suiType: "@"
	# 			suiSize: "@"
	# 			suiOnChange: "&"
	# 		template: """
	# 			<div ng-class="_checkboxClass">
	# 				<input type="checkbox">
	# 				<label ng-click="_clickedCheckbox()" ng-transclude></label>
	# 			</div>
	# 			"""
	# 		link: (scope, element, attrs, ngModel) ->

	# 			# Set type and size
	# 			scope._checkboxClass = "ui checkbox"
	# 			switch scope.suiType
	# 				when "slider"
	# 					scope._checkboxClass = "ui slider checkbox"
	# 				when "toggle"
	# 					scope._checkboxClass = "ui toggle checkbox"

	# 			switch scope.suiSize
	# 				when "large"
	# 					scope._checkboxClass += " large"
	# 				when "huge"
	# 					scope._checkboxClass += " huge"

	# 			scope._clickedCheckbox = ->
	# 				if scope.suiCheckbox?
	# 					scope.suiCheckbox = !scope.suiCheckbox

	# 			# Add eventhanlder
	# 			scope.$watch "suiCheckbox", (newVal, oldVal) ->
	# 				if newVal?
	# 					scope.suiOnChange? {option: newVal}
	# 					if newVal is true
	# 						element.children()[0].setAttribute('checked', 'true')
	# 					else
	# 						element.children()[0].removeAttribute('checked')












	# # Semantic-UI toggle button
	# # ------------------------------
	# .directive 'suiToggle', ->
	# 	directiveDefinitionObject =
	# 		scope:
	# 			ngModel: '='
	# 			label: '@'
	# 		template:
	# 			'<div class="ui toggle checkbox">
	#   				<input type="checkbox">
	#   				<label>{{label}}</label>
	# 			</div>'
	# 		link: (scope, elem, attrs) ->
	# 			$('.ui.checkbox',elem).checkbox()
	# 			if scope.ngModel then $('.ui.checkbox',elem).checkbox('enable')
	# 			$('.ui.checkbox',elem).checkbox('setting', 'onChange', () ->
	# 				scope.ngModel = !scope.ngModel
	# 				scope.$apply() if not scope.$$phase
	# 				return)
	# 			return












	# SELCTION
	# .directive 'specialsuiSelection', ($timeout) ->
	# 	directiveDefinitionObject =
	# 		restrict: 'A'
	# 		scope:
	# 			model: '=ngModel'
	# 			suiOptions: '='
	# 			suiDefault: '@'
	# 			suiOnChange: '&'
	# 		template:
	# 			'<div class="ui fluid selection dropdown">
	# 				<div class="default text">{{suiDefault}}</div>
	# 				<i class="dropdown icon"></i>
	# 				<div class="menu">
	# 					<div class="item" data-value="{{opt}}" ng-repeat="opt in suiOptions track by $index">{{opt}}</div>
	# 				</div>
	# 			</div><div class="ui segment"><pre>{{model}}</pre></div>'
	# 		link: (scope, elem, attrs) ->

	# 			# Add timeout to make it work
	# 			# TODO: Figure out way without timeout
	# 			$timeout (->
	# 				$('.ui.dropdown', elem)
	# 					.dropdown('setting', 'onChange', (value, text) ->
	# 						console.log "selct changed: ", value, text
	# 						scope.suiOnChange()(value, text) if attrs.suiOnChange?
	# 						scope.model = value
	# 						scope.$apply()
	# 						return
	# 					)
	# 			), 400

	# 			scope.$watch 'model', (newVal, oldVal) ->
	# 				console.log "modelwatch: ", newVal, oldVal
	# 				if (newVal != oldVal)

	# 					console.log "Outside changed, before: ", attrs.ngModel
	# 					scope.$eval(attrs.ngModel + ' = model');
	# 					console.log "after: ",attrs.ngModel
	# 					#scope.$eval(attrs.ngModel + ' = model');
	# 					$timeout (->
	# 						elem.dropdown("set selected", newVal)
	# 						), 400

	# 				return

	# 			return
				# Bring in changes from outside:
				# scope.$watch 'model', (newVal, oldVal) ->
				# 	if(newVal != oldVal)
				# 		"Outside changed"
				# 		attrs.$set('ngModel', 'model')
				# 		#scope.$eval(attrs.ngModel + ' = model');
				# 		$('.ui.dropdown', elem)
				# 			.dropdown("set selected", attrs.ngModel)

				# DOCUMENTATION: ALTERNATIVE TO ABOVE
				# # Bring in changes from outside:
				# scope.$watch 'model', (value) ->
				# 	attrs.$set('ngModel', 'value')
				# 	#scope.$eval(attrs.ngModel + ' = model');
				# 	$('.ui.dropdown', elem)
				# 		.dropdown("set selected", attrs.ngModel)


				# Send out changes from inside:
				# scope.$watch attrs.ngModel, (val) ->
				# 	scope.model = val;



	# # Add timeout to make it work
	# # TODO: Figure out way without timeout
	# $timeout (->
	# 	$('.ui.dropdown', elem)
	# 		.dropdown('setting', 'onChange', (value, text) ->
	# 			console.log "selct changed: ", value, text
	# 			scope.suiOnChange()(value, text) if attrs.suiOnChange?
	# 			scope.model = value
	# 			scope.$apply()
	# 			return
	# 		)
	# ), 400

	# scope.$watch 'model', (newVal, oldVal) ->
	# 	console.log "modelwatch: ", newVal, oldVal
	# 	if (newVal != oldVal)

	# 		console.log "Outside changed, before: ", attrs.ngModel
	# 		scope.$eval(attrs.ngModel + ' = model');
	# 		console.log "after: ",attrs.ngModel
	# 		#scope.$eval(attrs.ngModel + ' = model');
	# 		$timeout (->
	# 			elem.dropdown("set selected", newVal)
	# 			), 400

	# 	return










	# REFERENCE
	# moduleVariable.directive 'directiveName', (injectables) ->
	# 	directiveDefinitionObject =
	# 		priority: Number
	# 		terminal: true|false
	# 		scope: true|false|{} (object hash)
	# 		controller: () ->
	# 			#controller cn func, may access $scope, $element, $attrs, $transclude
	# 		require: 'controllerName|?controllerName|^controllerName'
	# 		restrict: 'E|A|C|M'
	# 		template: 'HTML'
	# 		templateUrl: 'directive.html'
	# 		replace: true|false
	# 		transclude: true|false|'element'
	# 		#only use to transform template DOM
	# 		compile: (tElement, tAttrs, transclude) ->
	# 			compiler =
	# 				pre: (scope, iElement, iAttrs, controller) ->
	# 					#not safe for DOM transformation
	# 					#
	# 				post: (scope, iElement, iAttrs, controller) ->
	# 					#safe for DOM transformation
	# 					#
	# 			return compiler
	# 		#called IFF compile not defined
	# 		link: (scope, iElement, iAttrs) ->
	# 			#register DOM listeners or update DOM
	# 			#
	# 	return directiveDefinitionObject
