##| sample miller data	
MillerData =
	'categoryId': 'cat-1'
	'categoryName': 'Category 1'
	'parentId': null
	'isLowestLevel': true
	'items': [
		{
			'itemId': 'item-1'
			'isDeleteable': true
			'itemName': 'Category 1 item 1'
			'hasChildren': true
			'categoryId': 'cat-1'
			'parentId': null
		}
		{
			'itemId': 'item-2'
			'isDeleteable': true
			'itemName': 'Category 1 item 2'
			'hasChildren': true
			'categoryId': 'cat-1'
			'parentId': 'item-1'
		}
		{
			'itemId': 'item-3'
			'isDeleteable': true
			'itemName': 'Category 1 item 2 item 3'
			'hasChildren': false
			'categoryId': 'cat-1'
			'parentId': 'item-2'
		}
		{
			'itemId': 'item-4'
			'isDeleteable': true
			'itemName': 'Category 1 item 2 item 3'
			'hasChildren': false
			'categoryId': 'cat-1'
			'parentId': 'item-3'
		}
	]


$ ->

	##|
	##|  Simple miller column using this
	##|
    addTestButton "Miller Columns", "Open", ()->

    	div = addHolderWidget("renderTest1")
    	div.setView "Miller", (view)=>
    		view.setData(MillerData)
    		view.show()
    		view.millerColumn.onSelected = (e, data) ->
    			console.log('custom event callback from miller column', data)
    	true

    ##|
    ##|  Simple miller column using this
    ##|
    addTestButton "Miller Columns popup", "Open", ()->
    	doPopupView 'Miller', 'Miller Columns', 'miller_popup', 1000, 450, (view) ->
    		## remove existing millerColumn instance to force render in popup
    		delete view.millerColumn
    		view.setData(MillerData)
    		view.show()
    		view.millerColumn.onSelected = (e, data) ->
    			console.log('custom event callback from miller column', data)
    	true

	##|
    ##|  Simple miller column using this
    ##|
    addTestButton "Miller Columns tab", "Open", ()->
    	addHolder()
    	.setView "DynamicTabs", (tabs) ->
	    	tabs.doAddViewTab("Miller", "MillerTab", (view)->
	    		view.setData MillerData
	    		view.show()
	    		view.millerColumn.onSelected = (e, data) ->
	    			console.log('custom event callback from miller column', data)
	    	)   
	    	tabs.addTab "EmptyTab", '<h2>Another tab</h2>'
	    	
    	true
    go()