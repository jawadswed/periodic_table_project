#! /bin/bash



PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

PRINT_ELEMENT() {
    INPUT=$1

    if [[ $INPUT =~ ^[0-9]+$ ]]
    then
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT")
    else
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$INPUT' OR symbol='$INPUT'")
    fi

    if [[ -z $ATOMIC_NUMBER ]]
    then
        echo -e "I could not find that element in the database."
    else
        NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
        TYPE=$($PSQL "SELECT type FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER ")
        ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

        echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

    fi
}

if [[ -z $1 ]]
then
    echo -e "Please provide an element as an argument."
else
    PRINT_ELEMENT $1
fi