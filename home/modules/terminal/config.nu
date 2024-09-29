mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

let carapace_completer = {|spans| carapace $spans.0 nushell $spans | from json }
$env.config = {
  show_banner: false,
  completions: {
    case_sensitive: false,
    quick: true, 
    partial: true, 
    algorithm: "fuzzy",
    external: {
      enable: true, 
      max_results: 8, 
      completer: $carapace_completer
    }
  }
}
$env.path = ($env.path | split row (char esep) | prepend /home/lisan/.apps | append /user/bin/env)

