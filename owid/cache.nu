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