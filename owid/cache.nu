#
#  CACHING LAYER
#
#  The basic pattern for any command that needs to cache its results is to wrap
#  the real work in a command like this:
#
#  def "my command" [--refresh] {
#    let key = "my-cache-key" # XXX
#    if ($refresh or (not (cache exists $key))) {
#      (do the real work) # XXX
#  	   | cache tee $key
#    } else {
#      cache fetch $key
#    }
#  }
#
#  The command then caches 3-hourly unless you pass --refresh to force a re-cache.
#

# Cache wrapper command. Takes a key and a command, and caches the output of the
# command to the given key to a file. If the key already exists, the file content will be returned
# instead of running the command. You can pass 0 to 9 arguments to the command. Flags can't be passed
# in via the ...args mechanism - insted you have to include those in the closure.
#
# Example:
# owid cache all-posts {|q| owid mysql query $q } "select * from posts"
# or:
# owid cache all-posts {|q| owid mysql query "select * from posts" }
#
# to bust the cache above use --refresh like this:
# owid cache --refresh all-posts {|q| owid mysql query $q } "select * from posts"
#
# If you want to use flags you have to write them inside the closure:
# owid cache ten-charts {|table| owid mysql table $table --limit 10 } "charts"
export def main [
    key: string      # the cache key
    --refresh        # flag to force a re-evaluation of the command
    command: closure # the command - a closure that will be applied to the given args
    ...args          # the arguments to the command (up to 10 args are supported)
] {
   if ($refresh or (not (exists $key))) {
     do $command $args.0? $args.1? $args.2? $args.3? $args.4? $args.5? $args.6? $args.7? $args.8? $args.9?
 	   | tee $key
   } else {
      fetch $key
   }
}

# Return the filename that a given key should be cached to
export def "filename" [key] {
  if ($key == 'key') {
    error make {'msg': 'programming error: you should use $key instead'}
  }
  let now = (date now | format date '%Y-%m-%d.%H')
  $"($env.HOME)/.cache/owid/nu/($now)/($key).json"
}

# Save input to the given filename and pass it through
export def "file-tee" [filename] {
  let x = $in
  $x | save -f $filename
  $x
}

# Return true if the key exists in the cache
export def "exists" [key] {
  filename $key | path exists
}

# Fetch the given key from the cache
export def "fetch" [key] {
  open (filename $key)
}

# Save a copy of the input to the cache in passing
export def "tee" [key] {
  let x = $in
  let filename = (filename $key)
  mkdir ($filename | path dirname)
  cleanup
  $x | file-tee $filename
}

# Delete any cache entries older than 3 days
def "cleanup" [] {
  ls $"($env.HOME)/.cache/owid/nu"
  | get name
  | each {|d|
    let age = ((date now) - ($d | path basename | str replace -r '\..*' '' | into datetime ))
    if ($age > 3day) {
      rm -rf $d
    }
  }
  return
}