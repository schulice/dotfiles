.PHONY: all
all:
	stow --verbose --target=$$HOME --restow */

.PHONY: show
show:
	stow --verbose --target=$$HOME --no */

.PHONY: delete
delete:
	stow --verbose --target=$$HOME --delete */

.PHONY: pull
pull:
	git fetch origin master
	git pull origin master

.PHONY: push
push:
	@sh -c '\
	git add -A &&\
	git commit -m "auto: update" &&\
	git push origin master\
	'
