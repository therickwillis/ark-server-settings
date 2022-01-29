
function updateGameUserSettings() {	
	echo "Updating GameUserSettings";	

	# verify file exists
	if [ -w $1 ]; 
	then
		echo "Found File - $1"
	else
		echo "File Not Found - $1"
		exit 2
	fi

	# loop through replacements
	declare replacements=(
		"TamingSpeedMultiplier=5.0"
		"XPMultiplier=3.0"
		"somethingNew=1.4"
	)
	cmd="sed "
	for i in "${replacements[@]}"
	do
		updateProperty $i $1
	done
}

function updateProperty() {
	file=$2	

	# split the setting into the property and the value
	readarray -d = -t split<<< "$1"
	property=${split[0]}
	value=${split[1]%$'\n'}
	
	echo "Updating Property $property to $value"
	
	#result=$(cat $file | grep -c "$property");
		
	# if [ $result -gt 0 ];	
	if [ $(cat $file | grep -c "$property") -gt 0 ];	
	then
		echo "Property Found - Replacing $property"
		sed -i "s/^\($property=\).*/\1$value/" $file
	else
		echo "Property Not Found - Adding $property"
	fi
		
}

# adds mods to the provided folder

# get mods list

# update Game.ini


# update GameUserSettings.ini
updateGameUserSettings $1
