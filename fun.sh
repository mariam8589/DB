## Function to delete customer
function deleteCust {
	CustID=${1}
	LINE=$(grep "^$CustID:" customers.db)
	sed -i "s/$LINE//" customers.db
}

## Function to update email 
function updateCust {
	CID=${1}
	CMAIL=${2}
	OLDLINE=$(grep "^$CID:" customers.db)
	OLDMAIL=$(echo $OLDLINE | awk 'BEGIN{FS=":"} {print $3}')
	sed -i "s/${OLDMAIL}/${CMAIL}/" customers.db

	

}
