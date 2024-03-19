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
else
#user found. go to the play
echo else
fi
}

MAIN_MENU