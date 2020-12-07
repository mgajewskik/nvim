# My configs repo

```bash
git init --bare $HOME/.myconfig
alias config='/usr/bin/git --git-dir=$HOME/.myconfig/ --work-tree=$HOME'
myconfig config --local status.showUntrackedFiles no
echo "alias config='/usr/bin/git --git-dir=$HOME/.myconfig/ --work-tree=$HOME'" >> $HOME/.zshrc
myconfig remote add origin git@github.com:MGajewskiK/configs.git
```
