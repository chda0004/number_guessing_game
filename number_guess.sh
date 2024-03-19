#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_MENU(){


echo Enter your username:
read USER_NAME
RETURN_USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USER_NAME'")

if [[ -z $RETURN_USER_ID ]]
then
  #user not found. Create him
  RETURN_CREATE_USER=$($PSQL "INSERT INTO users(username) VALUES('$USER_NAME')")
  echo Welcome, $USER_NAME! It looks like this is your first time here.
  RETURN_USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USER_NAME'")
else
#user found. go to the play

RETURN_PLAYED_GAMES=$($PSQL "SELECT games_played FROM rank WHERE user_id='$RETURN_USER_ID'")
RETURN_HIGHSCORE=$($PSQL "SELECT best_game FROM rank WHERE user_id='$RETURN_USER_ID'")
echo Welcome back, $USER_NAME! You have played $RETURN_PLAYED_GAMES games, and your best game took $RETURN_HIGHSCORE guesses.
fi
}

GAME(){

echo game
}

MAIN_MENU