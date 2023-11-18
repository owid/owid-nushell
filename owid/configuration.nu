const datasetteUrlChoices = ["http://datasette-private/" "https://datasette-public.owid.io/"]

const default = {
    datasetteUrl: "http://datasette-private/"
    apiUrl: "https://api.ourworldindata.org/v1/indicators/"
    cfUserId: null
    siteUrl: "https://ourworldindata.org/"
    mysqlProfileHelper: "~/nu/owid/mysql-profile.py"
    mysqlProfile: "~/.my.cnf"
}

# Fetch the configuration, merging the $env.owid object with the defaults
export def "get" [] {
    let current = $env.owid? | default {}
    $default | merge $current
}

# Interactive setup of the configuration
export def --env setup [] {
    mut current = $env.owid? | default {}
    if ($current.datasetteUrl? == null) {
        let $datasetteUrl = $datasetteUrlChoices | input list "Which datasette instance do you want to use?"
        $current.datasetteUrl = $datasetteUrl
    }

    if ($current.apiUrl? == null) {
        let $apiUrl = input $"Which API URL should be used \(press enter to keep the default ($default.apiUrl)\)"
        $current.apiUrl = if $apiUrl == "" {$default.apiUrl} else {$apiUrl}
    }

    if ($current.cfUserId? == null) {
        let $cfUserId = input "What Cloudflare user ID should be used? (See 1password)"
        $current.cfUserId = $cfUserId
    }

    if ($current.siteUrl? == null) {
        let $siteUrl = input $"What is the site URL? \(press enter to keep the default ($default.siteUrl)\)"
        $current.siteUrl = if $siteUrl == "" {$default.siteUrl} else {$siteUrl}
    }

    if ($current.mysqlProfileHelper? == null) {
        let $mysqlProfileHelper = input $"What is the path to the mysql-profile.py helper script? \(press enter to keep the default ($default.mysqlProfileHelper)\)"
        $current.mysqlProfileHelper = if $mysqlProfileHelper == "" {$default.mysqlProfileHelper} else {$mysqlProfileHelper}
    }

    if ($current.mysqlProfile? == null) {
        let $mysqlProfile = input $"What is the path to the mysql profile? \(press enter to keep the default ($default.mysqlProfile)\)"
        $current.mysqlProfile = if $mysqlProfile == "" {$default.mysqlProfile} else {$mysqlProfile}
    }

    load-env { owid: $current }
    print "Updated OWID config. To persist it, add an entry to your env.nu that persists the current value of $env.owid:"
    print $"$env.owid | to nuon --indent 2 | \"\\n$env.owid = \" ++ $in | save --append ($nu.env-path)"
}

# Commands to change the configuration or retrieve configuration values
export def main [] {

}