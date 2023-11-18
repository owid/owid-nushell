use api.nu
use mysql.nu

# Get the metadat for an indciator by indicator id
export def "metadata from id" [
    indicatorId: int
] {
    api metadata $indicatorId
}

# Get the metadata for an indicator by etl path (needs the full ETL path including the #columnname)
export def "metadata from path" [
    etlPath: string
] {
    if $etlPath !~ '#' {
        error make {msg: $"Invalid etl path: ($etlPath)"}
    }
    let id = mysql query $"SELECT id FROM variables WHERE catalogPath = ($etlPath)" | get 0.id | into int
    api metadata $id
}

# Get metadata for all indicators in a chart config
export def "metadata from chart" [
] {
    let chart = $in
    let indicatorIds = $chart | get dimensions | each {$in.variableId} | flatten
    $indicatorIds | par-each {|it| api metadata ($it)}
}

# Simplify a chart config by rejecting verbose fields
export def "metadata simplify" [] {
    reject dimensions
}

# Commands to quickly work with indicators
export def main [] {

}