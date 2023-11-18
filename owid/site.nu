# Fetch the sitemap and return a list of all URLs
export def sitemap [] {
    let conf = configuration get
    http get $"($conf.siteUrl)sitemap.xml" | get content | each {|it| $it | get content.0.content.0.content }
}

# Commands related to the live website and sitemap
export def main [] {
}