import sys
import requests
from bs4 import BeautifulSoup

# Check if mod_ids were provided
if len(sys.argv) < 2:
    print("Usage: python mod-list.py 1623256655,1989252120")
    sys.exit(1)

# List of mod IDs
mod_ids = sys.argv[1].replace(' ', '').split(',')

# Base URL for mod page
base_url = 'https://steamcommunity.com/sharedfiles/filedetails/?id='

for mod_id in mod_ids:
    # Concatenate the base URL and mod ID to create the full URL
    url = base_url + str(mod_id)
    
    # Send a GET request to the mod page URL
    response = requests.get(url)
    
    # Parse the HTML content using BeautifulSoup
    soup = BeautifulSoup(response.content, 'html.parser')
    
    # Extract the mod name from the title tag
    mod_name = soup.title.string.replace('Steam Workshop::', '').split(' - ')[0]    
    updated_date_divs = soup.find_all('div', {'class': 'detailsStatsContainerRight'})[0].find_all('div', {'class': 'detailsStatRight'})
    if len(updated_date_divs) > 2:
        # Extract updated date from the detailsStatsContainerRight container
        updated_date = updated_date_divs[2].text.strip()
    else:
        # Extract created date instead
        updated_date = updated_date_divs[1].text.strip()

    # Check if mod is discontinued
    description = soup.find('div', {'class': 'workshopItemDescription'}).text
    if 'discontinued' in description.lower():
        # Mod is discontinued
        print(f"Mod ID {mod_id} corresponds to the mod named {mod_name}, which is discontinued")
    else:
        # Mod is not discontinued
        # Extract the updated/created date from the detailsStatsContainerRight container
        updated_date_divs = soup.find_all('div', {'class': 'detailsStatsContainerRight'})[0].find_all('div', {'class': 'detailsStatRight'})
        if len(updated_date_divs) > 2:
            # Extract updated date
            updated_date = updated_date_divs[2].text.strip()
        else:
            # Extract created date instead
            updated_date = updated_date_divs[1].text.strip()


    # Print the mod name
    print(f"{mod_id} - {mod_name} - last updated on {updated_date}")