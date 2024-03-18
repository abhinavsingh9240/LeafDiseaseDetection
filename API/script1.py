import requests
from bs4 import BeautifulSoup
import json


def fetch_crop_data():

    url = "https://www.allthatgrows.in/blogs/posts/vegetable-growing-season-chart-india"

    try:
        response = requests.get(url)
        print(response.status_code)
        if response.status_code == 200:
            soup = BeautifulSoup(response.content, "html.parser")
            table = soup.find("table")
            if table:
                crop_data = []
                headings = [
                    th.get_text().strip() for th in table.find("thead").find_all("th")
                ]
                for row in table.find("tbody").find_all("tr"):
                    crop = {}
                    cells = row.find_all("td")
                    for i in range(len(cells)):
                        if headings[i] == "Links":
                            crop[headings[i]] = (
                                cells[i].find("a")["href"] if cells[i].find("a") else ""
                            )
                        else:
                            crop[headings[i]] = cells[i].get_text().strip()
                    crop_data.append(crop)

                data = json.dumps(crop_data, indent=4)

                return data
            else:
                print("No table found on the page.")
                return None
        else:
            print("Failed to fetch page:", response.status_code)
            return None
    except Exception as e:
        print("Error fetching data:", e)
        return None


# def filter_crop_data_by_month(crop_data, month):
#     filtered_data = []
#     for crop in crop_data:
#         growing_season_north = crop.get("Growing Season - North India", "")
#         growing_season_south = crop.get("Growing Season - South India", "")
#         if (
#             month.lower() in growing_season_north.lower()
#             or month.lower() in growing_season_south.lower()
#         ):
#             filtered_data.append(crop)
#     return filtered_data


# URL of the website containing the table
# url = "https://www.allthatgrows.in/blogs/posts/vegetable-growing-season-chart-india"

# Fetch crop data
crop_data = fetch_crop_data()


# print(type(data))

print(crop_data)

# f = open("./data.json", "w")
# f.write(data)
# f.close()


# Month you want to filter the data for
# search_month = input("Enter month: ")

# # Filter crop data by month
# filtered_data = filter_crop_data_by_month(crop_data, search_month)

# # Display the filtered data
# if filtered_data:
#     print(f"Crop Data for {search_month}:")
#     for crop in filtered_data:
#         print(f"Vegetable Name: {crop['Vegetable Name']}")
#         print(f"Germination Temp. (in °C): {crop['Germination Temp. (in °C)']}")
#         print(f"Sowing Method: {crop['Sowing Method']}")
#         print(f"Sowing Depth (inches): {crop['Sowing Depth (inches)']}")
#         print(f"Sowing Distance (inches/feet): {crop['Sowing Distance (inches/feet)']}")
#         print(f"Days to Maturity: {crop['Days to Maturity']}")
#         print(f"Link to buy seed: {crop['Links']}")
#         print()  # Add an empty line between crops for better readability
# else:
#     print("No crop data found for the given month.")
