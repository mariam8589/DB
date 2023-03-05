#!/bin/bash
### Script that handles customer info in file customers.db
#BASH script manages user data
#	Data files:
#		customers.db:
#			id:name:email
#		accs.db:
#			id,username,pass
#	Operations:
#		Add a customer
#		Delete a customer
#		Update a customer email
#		Query a customer
#	Notes:
#		Add,Delete, update need authentication
#		Query can be anonymous
#	Must be root to access the script
#################################
### Exit codes:
##	0: Success
##	1: No customers.db file exists
##	2: No accs.db file exists
##	3: no read perm on customers.db
##	4: no read perm on accs.db
##	5: must be root to run the script
##	6: Can not write to customers.db
##	7: Customer name is not found

source ./printmsgs.sh
source ./checkers.sh
source ./fun.sh

## Check if file Customers exists
checkFile "customers.db"
[ ${?} -eq 1 ] && echo "File: customers.db not found" && exit 1
## Check if file accs exists
checkFile "accs.db"
[ ${?} -eq 1 ] && echo "File: accs.db not found" && exit 2
## Check if file customers  has read permission
checkRead "customers.db"
[ ${?} -eq 1 ] && echo "File: customers.db has no read permission" && exit 3
## Check if file accs has read permission
checkRead "accs.db"
[ ${?} -eq 1 ] && echo "File: accs.db has no read permission" && exit 4
## Check if file customers  has write permission
checkWrite "customers.db"
[ ${?} -eq 1 ] && echo "File: customers.db has no write permission" && exit 6
## Check if login user = root
checkUser
[ ${?} -eq 1 ] && echo "Please login as root" && exit 5

i=1
USERID=0
flag=1
flag2=1
flag3=1
while [ $i -eq 1 ]
do
	printMenu
	read OPTION
	case "${OPTION}" in
	##Authenticate
	"1")
		echo "Authentication:"
		echo "-------------------"
		echo -n "Please enter username: "
		read USERNAME
		echo -n "Please enter password: "
		#read -s PASSWORD
		checkAuth $USERNAME $PASSWORD
		USERID=$?
		if [ $USERID -eq 0 ]
		then
			echo -e "\nInvaild username/password\n"
		else
			echo -e "\nWelcome $USERNAME\n"
		fi
	;;
	##Add
        "2")
		if [ $USERID -eq 0 ]
		then 
			echo "You are not authenticated please authenticate first"	
		else
			echo "Adding new customer"
			echo -n "please enter Customer ID: "
			read CID
			
			##Check if Customer ID already used					
			checkID $CID
			CUSTID=$?
			##If customer ID is used or id not integer
			while [ $CUSTID -eq 1 ] || [ $flag -eq 1 ]
			do
			       echo -n "ID is already used please enter a different ID: "
                               read CID
                               checkID $CID
                               CUSTID=$?
 
			##Check if customer ID is integer
                                checkIDint $CID
                                if [ $? -eq 1 ]
                                then
                                        echo -n "please enter integer only: " 
                                        read CID
                                else
                                        flag=0
                                fi 

			
                        done

	

				##asks for customer name
				echo -n "Please enter the customer name: "
				read CNAME
				## check for customer name is only alphabet
				checkName $CNAME
				[ $? -eq 1 ] && echo -n "please enter alphabet  only: " && read CNAME
				
				##asks for customer email
				echo -n "Please enter Email: "
				read CMAIL
                                ## check for customer email is token
                                checkEM $CMAIL
                                [ $? -eq 1 ] && echo -n "please enter an email that not used : " && read CMAIL
				## check for customer email format
                                checkMail $CMAIL
                                [ $? -eq 1 ] && echo -n "please enter a vaild email : " && read CMAIL
				
			
		[ ! -z $CID ] && [ ! -z $CNAME ] && [ ! -z $CMAIL ] && echo "$CID:$CNAME:$CMAIL" >> customers.db			
		
				echo "Added !"				

		fi
   	;; 
	##Delete
	"3")
		if [ $USERID -eq 0 ]
                then
                        echo "You are not authenticated please authenticate first"      
                else
			echo "Deleting existing user"
			#	Read required ID to delete
			echo -n "Please enter ID to delete: "
			read DID
			
			##Check if ID exists                                    
                        checkID $DID
                        CUSTDID=$?
                        ##If customer ID is not used or not integer
                        while [ $CUSTDID -eq 0 ]
                        do     
                               echo -n "ID is not used please enter an existing ID or an integer ID: "
                               read DID
                               checkID $DID
                               CUSTDID=$?
                        done
			
			## Prints details
			query $DID
			
			## ask for confirmation
			echo -n "are u sure you want to delete custome id $DID(y/n): "
			read ans
			if [ $ans == "y" ] 
			then
				 deleteCust $DID
				 echo "Deleted !"	
			else
				echo "Canceled !!"
			fi

 		fi
		
	;;
	##Update
	"4")		
		if [ $USERID -eq 0 ]
                then
                        echo "You are not authenticated please authenticate first"      
                else
			echo "updaing email"
                         #       Read required ID to update
                         echo -n "Please enter ID to update: "
                         read EID
 
                         ##Check if ID exists and if integer                                    
                         checkID $EID
                         CUSTEID=$?
                         ##If customer ID is not used
			while [ $CUSTEID -eq 0 ]
                        do
                               echo -n "ID is not used please enter an existing ID/integer: "
                               read EID
                               checkID $EID
                               CUSTEID=$?
                        done

                        ## Prints details
                        query $EID

                        ## ask for confirmation
                        echo -n "are u sure you want to update customer id $EID(y/n): "
                        read an
                        if [ $an == "y" ]
			then
				echo -n "please enter new email: "
				read NEW
			        ## check for customer email is token
                                checkEM $NEW
                                [ $? -eq 1 ] && echo -n "please enter an email that not used : " && read NEW
                                ## check for customer email format
                                checkMail $NEW
                                [ $? -eq 1 ] && echo -n "please enter a vaild email : " && read NEW
			        ## ask for confirmation
                                echo -n "are u sure you want to update customer id $EID with $NEW (y/n): "
                                read answ
                                if [ $answ == "y" ] 
				then
					updateCust $EID $NEW
					echo "Updated"
				else
				echo "Canceled !!!"
				fi

                        else
				echo "Canceled !!"
			fi	
		fi
	
	;;
	##Query
	"5")
		echo -n "please enter your name: "
		read NAME
		query $NAME
	;;
	##Quit
	"6")
		echo "Thank you"
		i=2	
	;;
	##Default
	*)
		echo "Please enter a vaild option"
	;;

	esac

done






