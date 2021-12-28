# Created by newuser for 5.8
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" ]; then
	exec startx
fi
