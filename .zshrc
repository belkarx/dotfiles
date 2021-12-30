HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=1000000
SAVEHIST=10000000

export EDITOR=nano
export BROWSER=firefox-developer-edition

unsetopt BEEP
setopt autocd
setopt no_case_glob
setopt share_history
setopt append_history
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt correct
setopt correct_all

CASE_SENSITIVE="false"

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^[[3~' delete-char

PROMPT='%B%F{blue}%~%f%b %#> '
bindkey -e

alias nvimrc="nvim ~/.config/nvim/init.vim"
alias cp="cp -r"
alias ll='ls -la'
alias -s txt="$EDITOR "
alias -s log="tail -f "
alias ls='ls --color=auto'
alias bat="cat /sys/class/power_supply/BAT0/capacity"
alias md="mkdir"
alias rd="rm -rf"
alias rf="rm -rf"
alias psyu="sudo pacman -Syu"
alias pss="sudo pacman -Ss"
alias pr="sudo pacman -Rs"
alias sc="xrandr --output HDMI2 --auto"
alias notgrep="grep -v"
alias sd="shutdown -h 0"
alias symlink="echo 'ln -s [file] [link]'"
alias py="python3"
alias pvc="protonvpn-cli"
alias pvcc="protonvpn-cli connect"
alias grades="python3 ~/projects/py/auto-syn/auto.py"
alias tree2="tree -L 2"
alias ys="yay -S"
alias gc="cd ~/gh && git clone"
alias ...="cd .. && cd .."
alias ccl="clipcatctl list | head -n 10"
alias fmt="pushd ~/projects/startpage/ && nvim unformatted.txt && python3 format.py && popd"
alias CAP="setxkbmap -option"
alias fire="firefox-developer-edition"
alias gord="pushd ~/projects/go/pywal-gord/ && ./pywal-gord > ~/.config/gord/theme.json && popd && gord"
alias umnt="sudo umount /mnt" 
alias check_if_ubuntu="cat /mnt/etc/lsb-release"
alias mntsdc="sudo mount /dev/sdc /mnt"
alias ccl2="clipcatctl list | head -2 | tail -1 | cut -d' ' -f2- | xclip -selection clipboard 2>/dev/null"
alias nzsh="nvim /home/uk000/.zshrc && source /home/uk000/.zshrc"
WEB_PROJ_DIR="/home/uk000/projects/website/posts"
eval "$(lua /usr/local/bin/z.lua --init zsh)"

not() {nvim ~/notes/$1}

add_alias() {
	if [ $# -eq 0 ]; then
		echo "add_alias 'ccl=\"clipcatctl list\"'"
		return 1
	fi
	sed -i '40 a alias '$1'' /home/uk000/.zshrc \
	&& source /home/uk000/.zshrc
}

ddg() {
	lynx "https://duckduckgo.com/html/?q=$1"
}


export PROJ_DIR="/home/uk000/projects/website/"
# touch WEB_FNAME 
export WEB_FNAME=$(cat $PROJ_DIR/posts/drafts/WEB_FNAME)

edt() {
    if [[ $1 == "help" ]] || [[ $1 == "--help" ]]; then
        echo "uasage: edt [filename (no .md)] or jsut 'edt' (edt will open WEB_FNAME: $WEB_FNAME)]. purpose: just opens a file in neovim"
		return 1
    fi
	
	if [ $# -ne 0 ]; then
		export WEB_FNAME=$(echo $1 | cut -d. -f1)
		echo $WEB_FNAME > $PROJ_DIR/posts/drafts/WEB_FNAME
		echo "using $WEB_FNAME"
	fi
    nvim $PROJ_DIR/posts/drafts/$WEB_FNAME.md
}

alias wdir="cd $PROJ_DIR/posts/drafts/"

pub() {
	if [[ $1 == "help" ]] || [[ $1 == "--help" ]]; then
		echo "this command fcks around with the $PROJ_DIR/posts/posts_main.html (and -.md)"
    #elif [ $1 == "all" ]
	else
		if [ $# -eq 0 ]; then
			echo "no arg provided: using $WEB_FNAME"
		else
			WEB_FNAME=$1
		fi 
		pan
		my_date=$(stat -c %y $PROJ_DIR/posts/finished/$WEB_FNAME.html | awk -F. '{print $WEB_FNAME}') &&
		#probably could be cleaned up but it works
		echo "\\> [$WEB_FNAME](finished/$WEB_FNAME.html) || $my_date\n" >> $PROJ_DIR/posts/posts_main.md &&
		my_post="<p>\&gt; <a href=\"finished/$WEB_FNAME.html\">$WEB_FNAME</a> \|\| $my_date</p>"
		sed -zEi "s|(\n[^\n]*){3}$|\n$my_post&|" $PROJ_DIR/posts/posts_main.html
	
		mv $PROJ_DIR/posts/drafts/$WEB_FNAME.md $PROJ_DIR/posts/finished/$WEB_FNAME.md
		pushpost $WEB_FNAME
	fi
}

pushpost() {
    git commit -a -m "Wrote $1"
    git push
}

unpub() {
	if [ $# -eq 0 ]; then
		echo "no arg provided: using $WEB_FNAME"
	else
		WEB_FNAME=$1
	fi 
	mv $PROJ_DIR/posts/finished/$WEB_FNAME.md $PROJ_DIR/posts/drafts
	rm $PROJ_DIR/posts/finished/$WEB_FNAME.html
	echo "(technically not necessary) nvim $PROJ_DIR/posts/posts_main.md && jpan $PROJ_DIR/posts/posts_main"
}

pan() {
	if [ $# -eq 0 ]; then
		echo "using $WEB_FNAME"
		1=$WEB_FNAME
	fi
	#envsubst < $PROJ_DIR/posts/drafts/$1.md
	pandoc --standalone --from markdown --to html5 --mathjax $PROJ_DIR/posts/drafts/$1.md -o $PROJ_DIR/posts/finished/$1.html
}


jpan() {
	pandoc --standalone --from markdown --to html5 $1.md -o $1.html
}

expire() {
    if [ $# -eq 0 ]; then
		echo "enter a time in minutes [usage: expire 5]"
		return 1
	fi
	find . -cmin -$1
	echo "alr ru sure u want to delete these (y/n): "
	read sure
	if [ $sure = "y" ]; then
		find . -cmin -$1 -exec rm -rf {} +
	else
		echo "try again then -> expire [x]"
		return 0
	fi
}

zstyle :compinstall filename ${ZDOTDIR:-$HOME}/.zshrc
autoload -Uz compinit && compinit

zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{240}(%b)%r%f'
zstyle ':vcs_info:*' enable git

setxkbmap -option caps:backspace -option shift:both_capslock

LSCOLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'
