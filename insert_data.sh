#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
tail -n +2 games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals

do
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
  TEAM_O_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")
  
  if [[ -z $TEAM_ID ]]
  then
  INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
    if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted team, $winner
      fi
  fi
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")

  if [[ -z $TEAM_O_ID ]]
  then
  INSERT_O_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
  if [[ $INSERT_O_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted team, $opponent
      fi
  fi
  TEAM_O_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")

  echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $TEAM_ID, $TEAM_O_ID, $winner_goals, $opponent_goals)")

done