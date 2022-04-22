#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=postgres -t --no-align -c"

COUNTER=0
GAME(){
  echo "Guess the secret number between 1 and 1000:"
  RANDOM_NUM=$(( $RANDOM % 1000 + 1 ))

  while [[ $GUESS != $RANDOM_NUM ]]
  do
    read GUESS
    if [[ ! $GUESS =~ [0-9]+ ]]
    then
      echo "That is not an integer, guess again:"
    else
      if [[ $GUESS -gt $RANDOM_NUM ]]
        then
          echo "It's lower than that, guess again:"
      fi

      if [[ $GUESS -lt $RANDOM_NUM ]]
        then
          echo "It's higher than that, guess again:"
      fi
      let COUNTER++
    fi
  done
  echo "You guessed it in $COUNTER tries. The secret number was $RANDOM_NUM. Nice job!"
  PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE name='$1';")
  INSRT=$($PSQL "INSERT INTO games(player_id, number_of_tries) VALUES($PLAYER_ID, $COUNTER);")
}

echo "Enter your username:"
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

  echo "Welcome back, $USER! You have played $PLAYED games, and your best game took $BEST guesses."
  done
  GAME $USER

else
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSRT=$($PSQL "INSERT INTO players(name) VALUES('$USERNAME');")
  GAME $USERNAME
fi