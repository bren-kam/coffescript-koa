globalOpenEditor = (e) ->
    ##|
    ##|  Clicked on an editable field
    path = $(e).attr("data-path")
    DataMap.getDataMap().editValue path, e
    false


root = exports ? this
class DataMap

    constructor: ()->

        @data  = {}
        @types = {}

    ##|
    ##|  Returns a global instance of the data map
    @getDataMap: () =>
        if !root.globalDataMap
            root.globalDataMap = new DataMap()

        return root.globalDataMap

    ##|
    ##|  Set the data type for a given type of data
    ##|  Called statically to
    @setDataTypes: (tableName, columns) =>

        dm = DataMap.getDataMap()

        if !dm.types[tableName]?
            dm.types[tableName] = new DataTypeCollection(tableName)

        dm.types[tableName].configureColumns columns
        true

    ##|
    ##|  Return the columns associated with a given table
    ##|  reduceFunction is called with every table name,
    ##|  and return the columns that return true.
    @getColumnsFromTable: (tableName, reduceFunction) =>

        dm = DataMap.getDataMap()

        columns = []
        if !dm.types[tableName]
            return columns

        for i in dm.types[tableName].colList
            col = dm.types[tableName].col[i]

            keepColumn = true
            if reduceFunction?
                keepColumn = reduceFunction(col)

            if keepColumn
                columns.push col

        return columns

    @getValuesFromTable: (tableName, reduceFunction) =>

        dm = DataMap.getDataMap()
        # console.log "D[", tableName, "]=", dm.data[tableName]
        if !dm.data[tableName]? then return []

        results = []

        for key, obj of dm.data[tableName]
            keepRow = true
            if reduceFunction?
                keepRow = reduceFunction(obj)

            if keepRow
                results.push
                    key   : key
                    table : tableName

        return results

    editValue: (path, el) =>

        ##| Split the path name
        ##| ["", "zipcode", "03105", "lon"]
        parts = path.split '/'
        tableName = parts[1]
        keyValue  = parts[2]
        fieldName = parts[3]

        existingValue = @data[tableName][keyValue][fieldName]
        console.log "Existing:", existingValue
        formatter     = @types[tableName].col[fieldName].formatter
        console.log "F=", formatter
        formatter.editData el, existingValue, path, @updatePathValue
        true

    updatePathValue: (path, newValue) =>

        ##| Split the path name
        ##| ["", "zipcode", "03105", "lon"]
        parts = path.split '/'
        tableName = parts[1]
        keyValue  = parts[2]
        fieldName = parts[3]

        existingValue = @data[tableName][keyValue][fieldName]
        console.log "Compare ", existingValue, " to ", newValue
        if existingValue == newValue then return true
        @data[tableName][keyValue][fieldName] = newValue

        result = $("[data-path='#{path}']")
        if result.length > 0

            currentValue = newValue

            if @types[tableName]? and @types[tableName].col[fieldName]?
                formatter    = @types[tableName].col[fieldName].formatter
                currentValue = formatter.format currentValue, @types[tableName].col[fieldName].options, path

            result.html currentValue
            .addClass "dataChanged"

        true

    @addData: (tableName, keyValue, values) =>

        dm = DataMap.getDataMap()

        # console.log "addData[", tableName, "][", keyValue, "][", values ,"]"

        if !dm.data[tableName]
            dm.data[tableName] = {}

        if !dm.data[tableName][keyValue]
            ##|
            ##|  Entirely new value, don't check for updates
            dm.data[tableName][keyValue] = values
            return true

        for varName, value of values
            path = "/#{tableName}/#{keyValue}/#{varName}"
            dm.updatePathValue path, value

        true

    @getDataField: (tableName, keyValue, fieldName) =>

        dm = DataMap.getDataMap()
        if !dm.data[tableName]? or !dm.data[tableName][keyValue]?
            return ""
        return dm.data[tableName][keyValue][fieldName]

    @renderField: (tagNam, tableName, fieldName, keyValue, extraClassName) =>

        dm = DataMap.getDataMap()

        path = "/" + tableName + "/" + keyValue + "/" + fieldName
        currentValue = ""

        className = "data"

        if dm.data[tableName]? and dm.data[tableName][keyValue]? and dm.data[tableName][keyValue][fieldName]?
            currentValue = dm.data[tableName][keyValue][fieldName]

        ##|
        ##|  Other modification to the HTML such as edit events
        otherhtml = ""

        ##|
        ##|  See if there is a formatter attached
        if dm.types[tableName]? and dm.types[tableName].col[fieldName]?

            formatter = dm.types[tableName].col[fieldName].formatter

            if formatter? and formatter
                currentValue = formatter.format currentValue, dm.types[tableName].col[fieldName].options, path
                className += " " + formatter.name

            if dm.types[tableName].col[fieldName].render? and typeof dm.types[tableName].col[fieldName].render == "function"
                currentValue = dm.types[tableName].col[fieldName].render(currentValue, path)

            if dm.types[tableName].col[fieldName].editable
                otherhtml += " onClick='globalOpenEditor(this);' "
                className += " editable"

        if extraClassName? and extraClassName.length > 0
            className += " #{extraClassName}"

        if !currentValue? or currentValue == null
            currentValue = ""


        # console.log "path=", path, dm.types[tableName].col[fieldName]

        html = "<#{tagNam} data-path='#{path}' class='#{className}' #{otherhtml}>" +
            currentValue + "</#{tagNam}>"

        return html