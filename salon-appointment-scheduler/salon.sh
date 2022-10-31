#!/bin/bash

PSQL="psql --username=postgres --dbname=salon -t --no-align -c"

# Welcoming message
echo -e "\n~~~~ Salon Management System ~~~~\n"
echo -e "\nWelcome my Salon, how can I help you today?\n"

# MAIN MENU function

MAIN_MENU () {

    # Print available services
    SERVICES=$($PSQL "SELECT * FROM services ORDER BY service_id" | sed 's/|/) /g')

    # Use while loop to display formatted services
    echo "$SERVICES"
    
    # read user input
    read SERVICE_ID_SELECTED

    # check if user input is valid (1-5)
    if [[ $SERVICE_ID_SELECTED =~ ^[1-5]$ ]]; then
        CHECK_CUSTOMER
    else
        echo "I could not find that service."
        MAIN_MENU
    fi
    
}

# function to create appointment
CREATE_APPOINTMENT () {
    #get customer name from database
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")
    
    # ask for appointment time
    echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"

    # read user input
    read SERVICE_TIME

    # insert appointment into database
    APPOINTMENT_INSERT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")

    # get service name from database
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

    # print confirmation
    echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
}

#function to create a new customer
CREATE_CUSTOMER () {
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # insert customer into database
    CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")

    # get customer id from database and store it in a variable for appointment function to use
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

    # call CREATE_APPOINTMENT function
    CREATE_APPOINTMENT
}

# function to check if customer exists
CHECK_CUSTOMER () {
    
    echo "What is your phone number?"
    # read user input
    read CUSTOMER_PHONE

    # check if users phone number exists in database
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    if [[ -z $CUSTOMER_ID ]]; then
        CREATE_CUSTOMER
    else
        CREATE_APPOINTMENT
    fi
}

# Call MAIN_MENU function
MAIN_MENU