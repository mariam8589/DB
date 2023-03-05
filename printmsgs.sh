#!/bin/bash

###Print the menu
function printMenu {
	echo "Main Menu: "
	echo -e "\t1) Authenticate"
	echo -e "\t2) Add new customer"
        echo -e "\t3) Delete a customer"
        echo -e "\t4) Update a customer email"
        echo -e "\t5) Query a customer"
	echo -e "\t6) Quit"
	echo -n "Please select an option: "
}
