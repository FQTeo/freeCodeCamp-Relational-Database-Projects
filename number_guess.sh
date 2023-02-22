#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo Enter your username:
read USERNAME_INPUT

USERNAME=$($PSQL "SELECT username FROM users WHERE username='$USERNAME_INPUT'")

if [[ -z $USERNAME ]]
then
  echo Welcome, $USERNAME_INPUT! It looks like this is your first time here.

  INSERT_USERNAME=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME_INPUT')")
else
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT score FROM games WHERE user_id=$USER_ID ORDER BY score ASC LIMIT 1")

  echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
fi

USERNAME=$($PSQL "SELECT username FROM users WHERE username='$USERNAME_INPUT'")
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

RANDOM_NUMBER=$((1 + RANDOM % 1000))
ATTEMPTS=0

echo Guess the secret number between 1 and 1000:
read GUESS

while [[ ! $GUESS =~ ^[0-9]+$ ]]
do
  echo That is not an integer, guess again:
  read GUESS
done

while [[ $GUESS -ne $RANDOM_NUMBER ]]
do
  ((ATTEMPTS++))

  if [[ $GUESS -gt $RANDOM_NUMBER ]]
  then
    echo -e "It's lower than that, guess again:"
  else
    echo -e "It's higher than that, guess again:"
  fi

  read GUESS

  while [[ ! $GUESS =~ ^[0-9]+$ ]]
  do
    echo That is not an integer, guess again:
    read GUESS
  done

done
  
((ATTEMPTS++))
INSERT_RESULT=$($PSQL "INSERT INTO games(score, user_id) VALUES ($ATTEMPTS, $USER_ID)")
echo You guessed it in $ATTEMPTS tries. The secret number was $RANDOM_NUMBER. Nice job!
