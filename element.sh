#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"


if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi


ELEMENT_QUERY=$($PSQL "
  SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
  FROM elements
  INNER JOIN properties USING(atomic_number)
  INNER JOIN types USING(type_id)
  WHERE atomic_number::text = '$1' OR symbol ILIKE '$1' OR name ILIKE '$1';
")


if [[ -z $ELEMENT_QUERY ]]; then
  echo "I could not find that element in the database."
  exit 0
fi


echo "$ELEMENT_QUERY" | while IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done

