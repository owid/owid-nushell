export def main [] {
    print $"(ansi blue_bold)Welcome to the Our World In Data Nuscript tools!(ansi reset)"
    print $"(ansi white_dimmed)The following subcommands exist:(ansi reset)"
    print $"(ansi cyan)api(ansi reset) - fetch data from our OWID file API \(metadata and data json files in R2\)"
    print $"(ansi cyan)chart(ansi reset) - tools for working with charts"
    print $"(ansi cyan)configuration(ansi reset) - set up or modify how the tools work"
    print $"(ansi cyan)datasette(ansi reset) - run SQL queries against our datasette instance"
    print $"(ansi cyan)r2(ansi reset) - interact with our R2 buckets \(needs aws cli and credentials\)"
    print $"(ansi cyan)mysql(ansi reset) - run SQL queries against a MySQL database"
    print $"(ansi cyan)site(ansi reset) - tools for working with our website and sitemap"
}

# As of Nushell 0.89.0, submodule auto-export was removed
# https://github.com/nushell/nushell/pull/11157
export module api.nu
export module cache.nu
export module chart.nu
export module configuration.nu
export module datasette.nu
export module indicator.nu
export module mysql.nu
export module r2.nu
export module site.nu
export module tailscale.nu
export module spaces.nu
export module redirects.nu