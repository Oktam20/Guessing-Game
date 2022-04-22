#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=postgres -t --no-align -c"

read USERNAME

USER=$($PSQL "SELECT name FROM players WHERE name='$USERNAME';")
if [[ ! -z $USER ]]
then
  echo $($PSQL "SELECT COUNT(*),MIN(number_of_tries) FROM players INNER JOIN games USING(player_id) WHERE name='$USERNAME';") | while IFS='|' read PLAYED BEST
  do
  if [[ -z $PLAYED ]]
  then
    PLAYED=0
    BEST=0
  fi

  echo "Welcome back $USER! You have played $PLAYED games, and your best game took $BEST guesses."
  done

else
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSRT=$($PSQL "INSERT INTO players(name) VALUES('$USERNAME');")
fi