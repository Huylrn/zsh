# all Tab widgets
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes

# all history widgets
zstyle ':autocomplete:*history*:*' insert-unambiguous yes

# ^S
zstyle ':autocomplete:menu-search:*' insert-unambiguous yes

# Autocompletion
zstyle -e ':autocomplete:list-choices:*' list-lines 'reply=( $(( LINES / 3 )) )'

# Override history search.
zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 8

# History menu.
zstyle ':autocomplete:history-search-backward:*' list-lines 15

#auto-complete
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
# (){
#    zle -A {.,}history-incremental-search-backward
#    zle -A {.,}vi-history-search-backward
#    bindkey -M emacs '^S' history-incremental-search-forward
#    bindkey -M vicmd '/' vi-history-search-forward
# }
() {
   local -a prefix=( '\e'{\[,O} )
   local -a up=( ${^prefix}A ) down=( ${^prefix}B )
   local key=
   for key in $up[@]; do
      bindkey "$key" up-line-or-history
   done
   for key in $down[@]; do
      bindkey "$key" down-line-or-history
   done
}
