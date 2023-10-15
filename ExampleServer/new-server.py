import json
import os
import tarfile
import shutil

def update_file(filename, changes):
    with open(filename, 'r') as file:
        content = file.read()
        for old, new in changes.items():
            content = content.replace(old, new)
    with open(filename, 'w') as file:
        file.write(content)

def main():
    # Load the configuration
    with open("config.json", 'r') as file:
        config = json.load(file)
    
    # Unzip the tar.gz file into a folder
    # with tarfile.open("server_files.tar.gz", 'r:gz') as tar:
    #    tar.extractall()

    # Rename the folder to serverName
    #os.rename("extracted_folder_name", config["serverName"])

    # # Update the GameUserSettings.ini
    # update_file(f"{config['serverName']}/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini", {
    #     "ServerName=\"Ark Server\"": f"ServerName=\"{config['serverName']}\"",
    #     "RCONPort=32330": f"RCONPort={config['startingPort']}",
    #     # ... any other changes you need
    # })

    # # Update the Game.ini
    # mods = ','.join(map(str, config['modList']))
    # update_file(f"{config['serverName']}/ShooterGame/Saved/Config/LinuxServer/Game.ini", {
    #     "ActiveMods=": f"ActiveMods={mods}",
    #     # ... any other changes you need
    # })

    # # Rename the arkserver file in the root
    # shutil.move(f"{config['serverName']}/arkserver", f"{config['serverName']}/arkserver-{config['serverName']}")

    # # Update lgsm/config-lgsm/arkserver/arkserver.cfg
    # cfg_path = f"{config['serverName']}/lgsm/config-lgsm/arkserver/arkserver.cfg"
    # update_file(cfg_path, {
    #     "port=\"7778\"": f"port=\"{config['startingPort']}\"",
    #     # ... any other changes you need
    # })

    # # Rename the config file
    # os.rename(cfg_path, f"{config['serverName']}/lgsm/config-lgsm/arkserver/arkserver-{config['serverName']}.cfg")

if __name__ == "__main__":
    main()
