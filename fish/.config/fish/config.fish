### ENV / PATH ###
fish_add_path $HOME/.local/bin
set -gx EDITOR nvim 
set -gx VISUAL nvim
set -U fish_greeting

### ALIASES ###
alias aria="aria2c -x16 -s16"
alias vid="yt-dlp --cookies-from-browser chrome"
alias ins="yt-dlp --cookies ~/.cookies/instagram.txt"

### INTERACTIVE ONLY ###
if status is-interactive
    # Prompt behavior
    set -g fish_prompt_pwd_dir_length 0

    # fzf
    fzf --fish | source

    # zoxide
    zoxide init fish | source
end

