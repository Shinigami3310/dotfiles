ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(starship init zsh)"

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

HISTFILE=~/.config/zsh/.zsh_history

HISTSIZE=200
SAVEHIST=200

setopt APPEND_HISTORY       # Дописывать историю в файл, а не перезаписывать его
setopt SHARE_HISTORY        # Делиться историей между всеми открытыми терминалами в реальном времени
setopt HIST_IGNORE_DUPS     # Не сохранять дубликаты, если команда введена дважды подряд
setopt HIST_IGNORE_SPACE    # Не сохранять команды, которые начинаются с пробела

if [ "$TERM" = "xterm-kitty" ]; then
    hyprctl switchxkblayout all 0 > /dev/null 2>&1
fi
