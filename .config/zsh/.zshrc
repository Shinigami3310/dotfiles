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
