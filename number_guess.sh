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

GAME_INIT

}

GAME_INIT(){
#generate random number
RANDOM_NUMBER=$(($RANDOM%1000+1))
echo $RANDOM_NUMBER
echo Guess the secret number between 1 and 1000:
NUMBER_OF_GUESS=$((0))
GAME
}

GAME(){
read NUMBER_GUESS
NUMBER_OF_GUESS=$(($NUMBER_OF_GUESS +1))
if [[ $NUMBER_GUESS =~ ^[0-9+$]  ]]
then
  #hier spiellogik
  if (( $RANDOM_NUMBER < $NUMBER_GUESS ))
  then
    echo "It's lower than that, guess again:"
    GAME
  elif (( $RANDOM_NUMBER > $NUMBER_GUESS ))
  then 
    echo "It's higher than that, guess again:"
    GAME
  elif [[ $RANDOM_NUMBER -eq $NUMBER_GUESS ]]
  then
    FINAL
  fi

else
  echo That is not an integer, guess again:
  GAME
fi
}

FINAL(){
#store values 


#and print end message
echo You guessed it in $NUMBER_OF_GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!
#
}

MAIN_MENU