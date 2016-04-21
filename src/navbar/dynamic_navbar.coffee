## -------------------------------------------------------------------------------------------------------------
## class to create dynamicNavBar
##
class DynamicNav

	# @property [Boolean] staticTop weather to make it static-top
	staticTop = false

	# @property [Boolean] inverse weather to use nav-bar-inverse
	inverse = false

	## -------------------------------------------------------------------------------------------------------------
	## constructor to create dynamic nav
	##
	## @param [String] holderElement the id of the element in which the nav bar should be rendered
	##
	constructor: (holderElement) ->
		if !$(holderElement).length
			throw new Error "Element with selector #{holderElement} not found for nav"

		@gid = GlobalValueManager.NextGlobalID()

		@navElements = []

		@elementHolder = $ holderElement

		## create nav element
		@navBarHolder = $ "<nav />",
			class: "navbar navbar-default",
			role: "navigation"
			id: "nav_#{@gid}"

		## add container for the nav
		@navBarBody = $ "<div />",
			class: "container-fluid"

	## -------------------------------------------------------------------------------------------------------------
	## internal function to process the associated elements in the navbar
	##
	internalProcessElements: ->
		## prepare navbody by evaluating the elements
		for e in @navElements
			if e.__proto__.hasOwnProperty('getHtml') and typeof e.__proto__.getHtml == 'function'
				@navBarBody.append e.getHtml()
			else
				console.log "The element #{e.constructor.name} has not implemented getHtml() method"
		## prepare nav element
		@navBarHolder.html @navBarBody
		@navBarHolder.addClass "#{if @staticTop then 'navbar-static-top'} #{if @inverse then 'navbar-inverse' }"

	## -------------------------------------------------------------------------------------------------------------
	## render function to display the navbar that is built programatically
	##
	render: ->
		@internalProcessElements()
		@elementHolder.append @navBarHolder

	## -------------------------------------------------------------------------------------------------------------
	## function to add element to the navbar
	##
	## @param [Object] element a valid defined navbar object which must implement getHtml() method
	##
	addElement: (element) ->
		if !(element.__proto__.hasOwnProperty("getHtml") and typeof element.__proto__.getHtml == 'function')
			console.log "element #{element.constructor.name} has not implemented .getHtml method";
		@navElements.push(element)
