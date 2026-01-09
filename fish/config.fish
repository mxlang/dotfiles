if ! status is-interactive
    exit
end

# disable fish greeting message
set -U fish_greeting

# load better prompt
if command -sq starship
    starship init fish | source
    enable_transience
end

# activate better shell history
if command -sq atuin
    atuin init fish | source
end