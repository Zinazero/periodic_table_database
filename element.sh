#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -n $1 ]]
then
  echo "Argument received."
else
  echo "Please provide an element as an argument."
fi
