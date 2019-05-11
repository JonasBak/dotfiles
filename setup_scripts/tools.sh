SETUP_SCRIPTS=$DOTFILES/setup_scripts

source $SETUP_SCRIPTS/utils.sh

tools=(
  dmenu
  entr
)

for tool in "${tools[@]}"
do
  install_if_needed $tool
done
