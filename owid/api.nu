use configuration.nu

# Fetches the metadata for the indicator with the given id
export def metadata [
    indicatorId: int # Id of the indicator
] {
    let conf = configuration get
    http get $"($conf.apiUrl)($indicatorId).metadata.json"
}

# Fetches the data for the indicator with the given id.
# Returns a table with columns entity, value and year. Note that entity is a number.
export def data [
    indicatorId: int # Id of the indicator
] {
    let conf = configuration get
    let data = http get $"($conf.apiUrl)($indicatorId).data.json"

    # I considered using zip here but nushell only has zip for 2 lists at a time and that made things a bit messier than I liked.
    let numRows = $data.entities | length

    0..($numRows - 1) | each { |row|
        let entity = $data | get entities | get $row
        let year = $data | get years | get $row
        let value = $data | get values | get $row
        { entity: $entity value: $value year: $year }
    }
}

# Fetches the metadata and data for the indicator with the given id and
# expands the data table to include not just entity, value and year but also entityName and entityCode.
export def indicator [
    indicatorId: int # Id of the indicator
] {
    let metadata = metadata $indicatorId
    let data = data $indicatorId
    let lookupTable = $metadata.dimensions.entities.values
    let extendedData = $data | join $lookupTable entity id --left | reject id | rename --column { name: entityName code: entityCode}
    { metadata: $metadata data: $extendedData }
}

# Fetches a chart config from the ourworldindata.org website given a slug
# and returns it as a record.
export def chart [
    chartSlug: string # slug of the chart
] {
    let conf = configuration get
    let chartPage = http get $"($conf.siteUrl)grapher/($chartSlug)"
    let relevantLines = (
        $chartPage
        | lines
        | skip until { |it|  $it | str contains "//EMBEDDED_JSON" }
        | skip 1
        | take until { |it| $it | str contains "//EMBEDDED_JSON" }
        | str join "\n"
    )
    let chartConfig = $relevantLines | from json
    $chartConfig
}

# Fetches the indicators used in a chart and returns them as a table with columns metadata and data
export def chart-indicators [
    chartSlug: string # slug of the chart
] {
    let chartConfig = chart $chartSlug
    let indicators = $chartConfig.dimensions | par-each { |it| indicator ($it.variableId | into int) | insert "property" $it.property }
    $indicators
}

# Commands to interact with our static metadata and json file based API
export def main [] {
}