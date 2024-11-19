all:
	stow --verbose --target=$$HOME --restow */

show:
	stow --verbose --target=$$HOME --no */

delete:
	stow --verbose --target=$$HOME --delete */

