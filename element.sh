#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

# no argument: ./element.sh
if [[ -z $1 ]]
then
    echo "Please provide an element as an argument."
else
    REGEX='^[0-9]+$'
    if [[ $1 =~ $REGEX ]]
    then
        QUERY=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
    else
        #  OR symbol='$1' OR name='$1'
        QUERY=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1' OR name='$1'")
    fi

    if [[ -z $QUERY ]]
    then
        echo "I could not find that element in the database."
    else
        echo "$QUERY" | while IFS="|" read ATOMIC_NUMBER  NAME  SYMBOL  TYPE  ATOMIC_MASS MELTING BOILING
        do
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
            #     The element with atomic number 1              is Hydrogen (H)   . It's a nonmetal, with a mass of 1.008 amu    . Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
        done
    fi
fi
