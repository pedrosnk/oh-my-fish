# Set OMF_CONFIG if not set.
if not set -q OMF_CONFIG
  set -q XDG_CONFIG_HOME; or set -l XDG_CONFIG_HOME "$HOME/.config"
  set -gx OMF_CONFIG "$XDG_CONFIG_HOME/omf"
end

# Source custom before.init.fish file
source $OMF_CONFIG/before.init.fish ^/dev/null

# Autoload framework structure, keeping user function path as first
set fish_function_path $fish_function_path[1] \
                       $OMF_CONFIG/functions  \
                       $OMF_PATH/{lib,git}    \
                       $fish_function_path[2..-1]

# Read current theme
read -l theme < $OMF_CONFIG/theme

# Prepare Oh My Fish paths
set -l omf_function_path {$OMF_CONFIG,$OMF_PATH}/{themes*/$theme/{,functions},pkg/*/{,functions}}
set -l omf_complete_path {$OMF_CONFIG,$OMF_PATH}/{themes*/$theme/completions,pkg/*/completions}

# Autoload functions
set fish_function_path $fish_function_path[1] \
                       $omf_function_path     \
                       $fish_function_path[2..-1]

# Autoload completions
set fish_complete_path $fish_complete_path[1] \
                       $omf_complete_path     \
                       $fish_complete_path[2..-1]

for init in {$OMF_CONFIG,$OMF_PATH}/{pkg/*/init.fish}
  begin
    source $init >/dev/null ^&1

    set -l IFS '/'
    echo $init | read -la components

    emit init_$components[-2] (printf '/%s' $components[1..-2])
  end
end

# Source custom init.fish file
source $OMF_CONFIG/init.fish ^/dev/null

set -g OMF_VERSION "1.0.0"
