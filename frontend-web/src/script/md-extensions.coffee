angular.module "mdExtension", []
.directive "mdeButtonRipple", ->
	directiveDefinitionObject =
		restrict: "A"
		scope:
			mdeButtonRipple: "&"
		link: (scope, elem, attrs, ngModel) ->
			buttonRef = elem
			buttonChildrenRef = elem.children()
			handleClick = ->
				buttonColor = $(buttonRef).css("background-color")
				buttonClone = $(buttonRef).clone()
				buttonClone.children().remove()
				$("body").append(buttonClone)
				$(buttonClone)
				.animate {scale: 30, backgroundColor: "#FFF"},
					easing: "swing"
					duration: 200
					step: (now, fx) -> $(buttonClone).css("transform", "scale(#{now})")
					complete: ->
						setTimeout ->
							scope.$applyAsync ->
								scope.mdeButtonRipple()
								$(buttonClone).detach()
								return
						, 300
						return

				# $.Velocity.animate buttonClone, {
				# 	scale: 30
				# 	backgroundColor: "#FFF"
				# },
				# 	easing: "easeInOut"
				# 	duration: 200
				# .then ->
				# 	console.log "Remove"
				# 	#scope.mdeButtonRipple()
				# 	setTimeout ->
				# 		scope.$applyAsync ->
				# 			scope.mdeButtonRipple()
				# 			$(buttonClone).detach()
				# 	, 200
				# 	return
				# 	# .animate {backgroundColor: "#FFF"},
				# 	# 	easing: "swing"
				# 	# 	duration: 50
				# 	# 	complete: ->
				# 	# 		scope.mdeButtonRipple()
				# 	# 		console.log "Remove"
				# 	# 		$(buttonClone).remove()
				return


			elem.on "click", handleClick



.animation ".info-panel", ->
	return {
		enter:(elem, done) ->
			autoHeight = elem.css("height", "auto").height()
			elem.css("height", 0)
			elem.animate({height: autoHeight}, 500, "easeInOutQuart", done)
			return

		leave:(elem, done) ->
			elem.animate({height: 0}, 200, "easeInOutQuart", ->
				destinationHeight = $("#commenter").height()
				$("html").height(destinationHeight)
				if self?.port?.emit?
					# console.log "Should resize: ", 0
					self.port.emit "resize", 0
				done()
			)
			return
	}