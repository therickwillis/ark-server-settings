RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

INFO="${GREEN} [ INFO ] ${NC}"
ERROR="${RED} [ INFO ] ${NC}"

function updateGameUserSettings() {	
	file=$1
	modList=$2

	declare replacements=(
		# todo: use a better delimiter
		# todo: read from file
		"[ServerSettings]=TamingSpeedMultiplier=5.0"
		"[ServerSettings]=XPMultiplier=3.0"
		"[ServerSettings]=ActiveMods=$modList"		
		"[ServerSettings]=AllowThirdPersonPlayer=True"
		"[ServerSettings]=EnablePvPGamma=True"
		"[ServerSettings]=DifficultyOffset=1.0"
		"[ServerSettings]=OverrideOfficialDifficulty=5.0"
		"[ServerSettings]=XPMultiplier=3.0"
		"[ServerSettings]=HarvestAmountMultiplier=4.0"
		"[ServerSettings]=TamingSpeedMultiplier=4.0"
		"[ServerSettings]=ItemStackSizeMultiplier=4.0000"
		"[ServerSettings]=ServerCrosshair=True"
		"[/Script/Engine.GameSession]=MaxPlayers=30"
	)
	
	updateFile $1 $replacements
}

function updateGame() {
	file=$1
	modList=$2

	declare replacements=(
		"[ModInstaller]=ModIDS=$modList"
		"[/script/shootergame.shootergamemode]=MatingIntervalMultiplier=0.5"
		"[/script/shootergame.shootergamemode]=EggHatchSpeedMultiplier=4.0"
		"[/script/shootergame.shootergamemode]=BabyMatureSpeedMultiplier=8.0"
		"[/script/shootergame.shootergamemode]=BabyImprintAmountMultiplier=4.0"
		"[/script/shootergame.shootergamemode]=HexagonRewardMultiplier=1.5"
		"[/script/shootergame.shootergamemode]=BabyCuddleIntervalMultiplier=0.6"
	)

	updateFile $1 $replacements
}

function updateFile() {
	file=$1
	replacements=$2
	
	echo -e "${INFO} Starting Update: $file"	
	verifyFile $file	

	for i in "${replacements[@]}"
	do
		updateProperty $i $file
	done

	echo -e "${INFO} Finished Update: $file"
}

function updateProperty() {
	# split the setting into the section, property, and value
	readarray -d = -t split<<< "$1"
	section=${split[0]}
	section_escaped=$(echo $section | sed -e 's/\//\\&/g' -e 's/[][]/\\&/g')	

	property=${split[1]}
	value=${split[2]%$'\n'}	
	file=$2	

	echo -e "${INFO} Updating Property $property to $value in Section $section"

	# check to see if the property exists	
	if [ $(cat $file | grep -c "$property") -gt 0 ];	
	then
		# update the property
		echo -e "${INFO} Replacing Property: $property"
		sed -i "s/^\($property=\).*/\1$value/" $file
	else
		# check to see if the section exists		
		if [ $(cat $file | grep -c "$section_escaped") -eq 0 ];
		then
			# add the section to the end of the file
			echo -e "${INFO} Adding Section: $section"
			echo "" >> $file
			echo $section >> $file
		fi

		# add the property to the top of the section
		echo -e "${INFO} Adding Property: $property"
		sed -i "s/^\($section_escaped\).*/\1\n$property=$value/" $file
	fi
}

function verifyFile() {
	if [ -w $1 ]; 
	then
		echo -e "${INFO} File Found: $1"
	else
		echo -e "${ERROR} File Not Found: $1"
		exit 2
	fi
}


# set the root and strip any trailing slash
root=${1%$'/'}
echo -e "${INFO} Using Root Path: $root"

modList="793605978,2357644511,2473361032,1380777369,2147192126,1984936918,670764308,731604991,2664227681"
echo -e "${INFO} Mods: $modList"

if [ -d $root ];
then
	basePath="$root/serverfiles/ShooterGame/Saved/Config/LinuxServer"
	
	# update GameUserSettings.ini
	gameUserSettingsPath="$basePath/GameUserSettings.ini"
	updateGameUserSettings $gameUserSettingsPath $modList
	
	# update Game.ini
	gamePath="$basePath/Game.ini"
	updateGame $gamePath $modList
else
	echo -e "${ERROR} Root Folder Not Found"
fi

echo -e "${INFO} Update Successful"