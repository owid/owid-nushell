use mysql.nu

# Fetches all redirects from the currently active mysql DB
export def fetch [] {
    mysql query "select * from redirects"
}

# Checks if the given source and target already exist in the DB
# The check is a starts-with check because query params may or
# may not be relevant in your case.
export def "check" [
    originalSource: string
    target: string
] {
    mut source = $originalSource
    if $source == "" {
        error make {msg: "Source cannot be empty"}
    }
    if $target == "" {
        error make {msg: "Target cannot be empty"}
    }
    if not ($source | str starts-with "/") {
        $source = "/$source"
    }
    if not ($target | str starts-with "/") and not ($target | str starts-with "http") {
        $source = "/$source"
    }
    mysql query $"select * from redirects where source like '($source)%' or source like '($source)%' or target like '($target)%' or target like '($target)%'"
}

# Adds a new redirect to the DB. Does a check first and if
# there are any (partial) matches you need to confirm if you
# want to continue and do the insert.
export def "add" [
    source: string
    target: string
] {

    let existing = check $source $target
    if ($existing | length ) > 0 {
        print "The following redirects already exist:"
        print $existing
        print "Do you want to abort? (yes/no)"
        let answer = input
        if $answer != "no" {
            print "Aborting"
            return
        }
    }
    print $"insert into redirects \(source, target) values \('($source)', '($target)')"
    mysql query $"insert into redirects \(source, target) values \('($source)', '($target)')"
    print "done"
}

# Commands to list or manage redirects
export def "main" [] {
}