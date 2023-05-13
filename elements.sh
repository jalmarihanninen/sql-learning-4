#!/bin/bash

# This script seaches the periodic_table database with the argument it is given on executing the file.
# The argument can be in Atomic Number, Symbol, or Name format. 

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


MAIN() {

  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
    return
  fi

  if [[ $1 =~ [0-9]+ ]]
  then
    INFO=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$1")
  fi

  if [[ -z $INFO ]]
  then
    INFO=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol='$1'")
  fi
  
  if [[ -z $INFO ]]
  then
    INFO=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$1'")
  fi

  if [[ -z $INFO ]]
  then
    echo "I could not find that element in the database."
    return
  fi

  IFS="|" read TYPE_ID AN SYMBOL NAME AM MP BP TYPE <<< $INFO
  echo "The element with atomic number $AN is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AM amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
}

MAIN $1
