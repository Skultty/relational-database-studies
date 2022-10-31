#! /bin/bash

  PSQL="psql --username=postgres --dbname=worldcup -t --no-align -c"

  export PGPASSWORD="z"

# Check if the input file exists
INPUT_FILE="games.csv"
if [ ! -f "$INPUT_FILE" ]; then
  echo "File $INPUT_FILE does not exist"
  exit 1
fi

echo "Inserting data into the database..."

# delete the data from tables

echo "$($PSQL "TRUNCATE TABLE teams, games")"

#insert each unique team into the teams table from the games.csv file
tail -n +2 "$INPUT_FILE" | while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
  #check if the winning team is already in the table if not insert it
  if [ $($PSQL "SELECT COUNT(*) FROM teams WHERE name = '$winner'") -eq 0 ]; then
    echo "$($PSQL "INSERT INTO teams (name) VALUES ('$winner')")"
  fi
  #check if the losing team is already in the table if not insert it
  if [ $($PSQL "SELECT COUNT(*) FROM teams WHERE name = '$opponent'") -eq 0 ]; then
    echo "$($PSQL "INSERT INTO teams (name) VALUES ('$opponent')")"
  fi
done

#insert each game into the games table from the games.csv file

tail -n +2 "$INPUT_FILE" | while IFS="," read -r year round winner opponent winner_goals opponent_goals
do 
  #find the id of the winning team
  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
  #find the id of the losing team
  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")
  #insert the game into the games table
  echo "$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$year', '$round', '$winner_id', '$opponent_id', '$winner_goals', '$opponent_goals')")"
done