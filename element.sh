#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  INPUT=$1
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    QUERY="SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
           FROM elements e 
           INNER JOIN properties p ON e.atomic_number = p.atomic_number 
           INNER JOIN types t ON p.type_id = t.type_id 
           WHERE e.symbol='$INPUT' OR e.name='$INPUT';"
  else
    QUERY="SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
           FROM elements e 
           INNER JOIN properties p ON e.atomic_number = p.atomic_number 
           INNER JOIN types t ON p.type_id = t.type_id 
           WHERE e.atomic_number=$INPUT;"
  fi

  RESULT=$($PSQL "$QUERY")
  
  
  if [[ -z $RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS <<< "$RESULT"
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
fi
