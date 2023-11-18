def "tailscale status" [] {
  /Applications/Tailscale.app/Contents/MacOS/Tailscale status --json | from json
}

export def "users" [] {
  tailscale status 
  | get User 
  | transpose id record 
  | get record 
  | select LoginName DisplayName 
  | rename login name
}

export def "hosts" [] {
  tailscale status 
  | get Peer 
  | transpose peer record 
  | get record 
  | select HostName DNSName Online UserID 
  | rename host dns online userid 
  | join (tailscale users) userid 
  | reject userid name
  | update dns {|it| ($it).dns | str replace -r '\.$' '' }
}