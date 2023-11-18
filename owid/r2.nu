use configuration.nu

# Run the "aws s3api" command against the Cloudflare S3-compatible API
# Needs the aws cli tool to be installed and the $env.owid.cfUserId environment variable to be set
export def query [
    ...rest: string # a command like listbuckets. Run with a bogus command to see the full list of commands
] {
    let stdin = $in
    if ($env.owid.cfUserId == null or $env.owid.cfUserId == "") {
        print 'Please run 'owid configure setup' and set a cfUserId'
    } else {
        if ((which aws | length) < 1) {
            print "Please install the aws cli tool"
        } else {
            $in | aws s3api --endpoint-url $"https://($env.owid.cfUserId).r2.cloudflarestorage.com" $rest
        }
    }
}

# Lists the R2 buckets
export def buckets [] {
    query list-buckets | from json | get Buckets | sort-by Name | get Name
}

# Lists the objects in a bucket with a given prefix. At most 200 results are returned by default
export def objects [
    bucket: string@buckets
    prefix: string
    --limit: number = 200
] {
    query list-objects-v2 "--bucket" $bucket "--prefix" $prefix "--max-items" $"($limit)"
    | from json
    | get Contents
    | update LastModified { into datetime }
    | update Size { into filesize }
}

# Deletes objects in R2. The bucket is passed as a parameter, the keys are streamed in as input
export def delete-objects [
    bucket: string@buckets
    --force
]: table<Key: string> -> table {
    let keys = $in
    mut proceed = $force
    mut result = [[Key]; [""]]
    let whitelisted_buckets = ["owid-api-staging", "owid-catalog-staging"]

    if not ($bucket in $whitelisted_buckets) {
        print $"(ansi red)ATM you can only delete objects in the following buckets: ($whitelisted_buckets).(ansi reset)"
        $proceed = false
    }

    if not $force {
        let count = $keys | length
        print $"(ansi red)This will delete ($count) in the bucket $bucket.(ansi reset) Are you sure? \(y/n\)"
        let answer = (input --numchar 1)
        if $answer != "y" {
            print "Aborting"
            $proceed = false
        } else {
            $proceed = true
        }
    }
    if $proceed {
        let deleted = $keys | { Objects: $in Quiet: true } | to json -r | query delete-objects "--bucket" $bucket "--delete" $in | from json
        $result = $deleted.Deleted
    }
    $result
}

# Commands to interact with our Cloudflare R2 buckets
export def main [] {

}