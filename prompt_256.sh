if [ -n "$BASH_VERSION" ];
	then export PS1='\[\e[38;5;135m\]\u\[\e[0m\]@\[\e[38;5;166m\]\h\[\e[0m\] \[\e[38;5;118m\]\w\[\e[0m\] \$ '
else 
	if [ "$UID" -eq 0 ]; then
	       	export PROMPT="%F{135}%n%f@%F{166}%m%f %F{118}%~%f %# " 
	else 
		export PROMPT="%F{135}%n%f@%F{166}%m%f %F{118}%~%f \$ " 
	fi 
fi
