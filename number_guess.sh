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
  #create rank
  RETURN_CREATE_RANK=$($PSQL "INSERT INTO rank(user_id, best_game, games_played) VALUES($RETURN_USER_ID, 0,0)")
else
#user found. go to the play

RETURN_PLAYED_GAMES=$($PSQL "SELECT games_played FROM rank WHERE user_id='$RETURN_USER_ID'")
RETURN_HIGHSCORE=$($PSQL "SELECT best_game FROM rank WHERE user_id='$RETURN_USER_ID'")
echo "Welcome back, $USER_NAME! You have played $RETURN_PLAYED_GAMES games, and your best game took $RETURN_HIGHSCORE guesses."
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
  NUMBER_PLAYED_GAMES=$($PSQL "SELECT games_played FROM rank WHERE user_id=$RETURN_USER_ID")
  
  HIGH_SCORE=$($PSQL "SELECT best_game FROM rank WHERE user_id=$RETURN_USER_ID")
  if [[ $NUMBER_OF_GUESS -lt $HIGH_SCORE || $HIGH_SCORE -eq 0 ]]
  then
    #push highscore
    RETURNED_VALUE_HIGH=$($PSQL "UPDATE rank SET best_game = $NUMBER_OF_GUESS WHERE user_id=$RETURN_USER_ID")
  fi

  #store played games
  NUMBER_PLAYED_GAMES=$(($NUMBER_PLAYED_GAMES +1))
  RETURNED_VALUE_GAMES=$($PSQL "UPDATE rank SET games_played = $NUMBER_PLAYED_GAMES WHERE user_id=$RETURN_USER_ID")
  #and print end message
  echo "You guessed it in $NUMBER_OF_GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"
  #
}

MAIN_MENU