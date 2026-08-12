ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
# Подключаем плагины...
if [[ -f "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Инициализация промпта Starship (добавляем до syntax-highlighting)
eval "$(starship init zsh)"

# zsh-syntax-highlighting СТРОГО ПОСЛЕДНИМ
if [[ -f "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi


HISTFILE=~/.config/zsh/.zsh_history

# Максимальное количество строк, хранящихся в памяти текущей сессии
HISTSIZE=200
# Максимальное количество строк, сохраняемых в файле истории на диске
SAVEHIST=200

# Опции для мгновенного и умного сохранения
setopt APPEND_HISTORY       # Дописывать историю в файл, а не перезаписывать его
setopt SHARE_HISTORY        # Делиться историей между всеми открытыми терминалами в реальном времени
setopt HIST_IGNORE_DUPS     # Не сохранять дубликаты, если команда введена дважды подряд
setopt HIST_IGNORE_SPACE    # Не сохранять команды, которые начинаются с пробела

if [ "$TERM" = "xterm-kitty" ]; then
    hyprctl switchxkblayout all 0 > /dev/null 2>&1
fi
