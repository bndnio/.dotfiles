# When setting up a new computer

## Device settings
* Trackpad -> enable "Tap to Click"
* Trackpad -> speed up pointer speed
* Accessibility -> Pointer Control -> Trackpad Options -> enable dragging w/ "Three Finger Draging"

## Pre-Requisites for running setup.sh
* [Create an ssh key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) using `ssh-keygen -t ed25519 -C "your_email@example.com"`
* Clone the .dotfiles repo `git clone https://github.com/bndnio/.dotfiles.git .dotfiles`
* Run `git clone https://github.com/bndnio/.dotfiles.git .dotfiles` in the home directory
* run `chmod 744 setup.sh` in the repo to allow execution

## After running setup.sh
* [Add public ssh key to GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
