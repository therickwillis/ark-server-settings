echo "Adding Links for server configuration files"

# Run Conditions
# - executed from the root of the server

# Context
# todo: - get the name of the server to support linking to the lgsm config

# Variables
gameIniPath="./serverfiles/ShooterGame/Saved/Config/LinuxServer/Game.ini"
gameUserSettingsIniPath="./serverfiles/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini"

ln -s $gameIniPath ./
ln -s $gameUserSettingsIniPath ./