#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -n $1 ]]
then
  #check if number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    #check if number matches atomic_number in database
    ATOMIC_NUMBER_RESULT=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements
INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number = $1;")

    if [[ -z $ATOMIC_NUMBER_RESULT ]]
    then
      #if not found
      echo "I could not find that element in the database."
    else
      #if found
      echo "$ATOMIC_NUMBER_RESULT" | while IFS='|' read NAME SYMBOL TYPE MASS MELT BOIL
      do
        echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    fi
    
  #else if symbol
  elif [[ $1 =~ ^[a-zA-Z]$ ]]
  then
    #check if number matches symbol in database
    SYMBOL_RESULT=$($PSQL "SELECT atomic_number, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements
INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE symbol = '$1';")

    if [[ -z $SYMBOL_RESULT ]]
    then
      #if not found
      echo "I could not find that element in the database."
    else
      #if found
      echo $"$SYMBOL_RESULT" | while IFS='|' read ATOMIC_NUMBER NAME TYPE MASS MELT BOIL
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($1). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    fi
  else
    echo "This is a string."
  fi
else
  echo "Please provide an element as an argument."
fi
