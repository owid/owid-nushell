use configuration.nu

# Query the private OWID datasette instance with SQL
export def query [
    sql: string # SQL query to run
    jsonColumn? # Indicate a column as json which will return it as an object as opposed to a string
] {
    let conf = configuration get
    let args = { sql: $sql }
    let args = if $jsonColumn != null { $args | insert "_json" $jsonColumn } else { $args}
    let escaped = $args | url build-query # | str replace --all '%20' '+' | str replace --all '%' '~'
    let url = $"($conf.datasetteUrl)owid.json?_shape=objects&($escaped)"
    let response = http get -e -f $url
    let body = $response.body
    if $response.status != 200 or $body.ok != true {
        let span = (metadata $sql).span;
        error make {msg: $"Datasette returned an error \(status code was ($response.status))", label: {
            text: $response.body.error
            start: $span.start
            end: $span.end
        }}
    }
    return $response.body.rows
}

# Fetch the list of tables from the private OWID datasette instance
export def tables [] {
    let conf = configuration get
    http get $"($conf.datasetteUrl)owid.json" | get tables
}

# Fetch the list of views from the private OWID datasette instance
export def views [] {
    let conf = configuration get
    http get $"($conf.datasetteUrl)owid.json" | get views
}

# Fetch the list of tables and views from the private OWID datasette instance
export def targets [] {
    (tables | get name) ++ (views | get name)
}

# Fetch the list of columns for a given table from the private OWID datasette instance
export def columns [
    name: string@targets # Name of the table to fetch columns for
] {
    let conf = configuration get
    http get $"($conf.datasetteUrl)owid.json"| get tables | where name == $name | get columns
}

# Commands to query our datasette instances
export def main [] {

}