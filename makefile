.PHONY: all
all:
	stow --verbose --target=$$HOME --restow */

.PHONY: show
show:
	stow --verbose --target=$$HOME --no */

.PHONY: delete
delete:
	stow --verbose --target=$$HOME --delete */

.PHONY: push
push:
	git add -A
	git commit -m "auto: update"
	git push origin master
