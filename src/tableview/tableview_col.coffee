##|
##|  Global functions required to use tables.  The cell id is a counter
##|  used to create elements with a new unique ID
##|

class TableViewCol

	##|
	##| Create a new column object.
	##|
	##| @param name [string] The name of the column
	##| @param title [string] The title to show in the header
	constructor : (@tableName, @col) ->
		@visible = @col.visible
		@width   = @col.width

		if !@visible? then @visible = true
		if !@width? then @width = ""

	RenderHeader: (extraClassName) =>
		if @visible == false then return ""

		html = "<th style='";
		if (@width) then html += "width: " + @width + ";"

		html += "'"

		if @col.extraClassName? and @col.extraClassName.length > 0
			html += "class='#{@col.extraClassName}'"

		if @col.tooltip? and @col.tooltip.length > 0
			html += " tooltip='simple' data-title='#{@col.tooltip}'"

		html += ">";
		html += @col.name;
		html += "</th>";

		return html

	onClickLink: ()=>

		window.open(@link, "showWindow", "height=800,width=1200,menubar=no,toolbar=no,location=no,status=no,resizable=yes")






