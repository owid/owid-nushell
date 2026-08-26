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

# As of Nushell 0.114.0, `use owid` no longer implicitly imports the
# submodules exported above, so `owid api metadata` etc. stopped resolving
# ("extra positional argument" against `main`). Re-export each submodule's
# contents explicitly to restore `owid <module> <command>` syntax.
# https://www.nushell.sh/blog/2026-07-04-nushell_v0_114_0.html
export use api.nu
export use cache.nu
export use chart.nu
export use configuration.nu
export use datasette.nu
export use indicator.nu
export use mysql.nu
export use r2.nu
export use site.nu
export use tailscale.nu
export use spaces.nu
export use redirects.nu