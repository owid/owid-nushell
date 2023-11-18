use mysql.nu
use api.nu

# Fetch a chart from mysql via the slug
export def "from slug" [
    slug: string
]  {
    let slug = if $slug starts-with 'http' { $slug | split row "/" | last} else { $slug }
    let sql = $"select config from charts where slug = '($slug)'"
    let chart = mysql query $sql
    $chart | get config
}



# Simplify a chart config by rejecting verbose fields
export def simplify [] {
    reject data
}

# Commands to quickly work with charts
export def main [] {

}