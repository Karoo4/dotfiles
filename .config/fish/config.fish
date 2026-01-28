source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

fish_add_path /home/karoo/.spicetify
zoxide init --cmd cd fish | source
set -x USER karoo
set -x MAIL karoo@sorbonne.ae
fish_add_path /home/karoo/.cargo/bin

set -gx PATH /usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin /sbin $PATH

# opencode
fish_add_path /home/karoo/.opencode/bin
alias claude-personal="CLAUDE_CONFIG_DIR=~/.claude-personal claude"
