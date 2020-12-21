#!/bin/sh

# include Adam Eivy's library helper
source ./lib/util/echos.sh

sudo snap refresh

sudo snap install --classic heroku

ok "done installing dependencies."
