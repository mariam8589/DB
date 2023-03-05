##Function takes a parameters. which is file name and return 0 if the file exists
function checkFile {
	FILENAME=${1}
	[ ! -f ${FILENAME} ] && return 1
	return 0
}
##Function takes a parameter which is filename and return 0 if the file has read perm
function checkRead {
	FILENAME=${1}
	[ ! -r ${FILENAME} ] && return 1
	return 0
}
##Function takes a paremter which is filename and returns 0 if the file has write permission
function checkWrite {
	FILENAME=${1}
        [ ! -w ${FILENAME} ] && return 1
        return 0
}

## Function takes a parameter with username, and return 0 if the user requested is the same as current user
function checkUser {
	[ "root" == ${USER} ] && return 0
	return 1
}

### Function takes a username, and password then check them in accs.db, and returns 0 if no match otherwise returns userID

function checkAuth {
	USERNAME=${1}
	USERPASS=${2}
	##Check for user in accs.db
	USERLINE=$(grep ":${USERNAME}:" accs.db)
	[ -z ${USERLINE} ] && return 0
	##generate the hashed passwd from accs.db
	PASSHASH=$(echo ${USERLINE} | awk ' BEGIN { FS=":" } { print $3} ') ## $1$SALT$HASHED_PASSWORD
	## Generate the hashed password from the entered password with the same Salt
	SALTKEY=$(echo ${PASSHASH} | awk ' BEGIN { FS="$" } { print $3 } ')
	NEWHASH=$(openssl passwd -salt ${SALTKEY} -1 ${USEPASS})

	if [ "${PASSHASH}" == "${NEWHASH}" ]
	then
		USERID=$(echo ${USERLINE} | awk ' BEGIN { FS=":" } { print $1} ')
		return ${USERID}
	else
		return 0
	fi
}


## Funtion to check if customer is in customers.db if so returns 0 otherwise returns 1
function query {
	CNAME=${1}
	LINE=$(grep "${CNAME}" customers.db )
	if [ -z ${LINE} ] 
	then
		echo "Sorry, ${CNAME} is not found" 
		return 1
	else
	echo "Information for the customer: "
	echo  "${LINE}"
	return 0
	fi
}



## Function to check if customerID already token, if not used return 0 otherwise returns 1
function checkID {
       
        IDLINDE=$(grep "^${1}:" customers.db )
        [ -z ${IDLINDE} ] && return 0
        return 1
	

}



## Function to check if customerID is integer only and  return 0 otherwise returns 1
function checkIDint {
        IDint=$(echo "$1"|grep -c "^[0-9]*$")
        [ $IDint -eq 0 ] && return 1
        return 0

}

## Function to check if customer name is alpha only and return 0 otherwise returns 1
function checkName {
        CUSname=${1}
        nameLINE=$(echo "$CUSname"| grep -c "^[[:alpha:]]*$") 
        [ $nameLINE -eq 0 ] && return 1
        return 0

}

## Function to check if customer email is vaild and return 0 otherwise returns 1
function checkMail {
        CM=${1}
	## Before @
        B=$(echo "$CM"| awk 'BEGIN{FS="@"} {print $1}')
	##Before .com
	BC=$(echo "$CM"| awk 'BEGIN{FS="@"} {print $2}'| awk 'BEGIN{FS="."} {print $1}')
	##After .com
        AC=$(echo "$CM"| awk 'BEGIN{FS="@"} {print $2}'| awk 'BEGIN{FS="."} {print $2}')
	if [ "${CM}" == "${B}@${BC}.${AC}" ] 
 	then 	
		return 0
	else
        	return 1
	fi

}

## Function to check if customer email already token, if not used return 0 otherwise returns 1
function checkEM {

        IDLINEs=$(grep ":${1}$" customers.db )
        [ -z ${IDLINEs} ] && return 0
        return 1


}


