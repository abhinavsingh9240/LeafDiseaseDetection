from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from joblib import load
from PIL import Image
import numpy as np
import requests
from bs4 import BeautifulSoup
import json
import os
os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'
import tensorflow as tf

from tensorflow import keras



@api_view(["GET"])
def plantdata(request):
    data = fetch_crop_data()
    return Response(
        status=status.HTTP_200_OK,
        data={
            "status": "success",
            "data": data,
        },
    )

@api_view(["GET"])
def schemes(request):
    data = getSchemesData()
    return Response(
        status=status.HTTP_200_OK,
        data={
            "status": "success",
            "data": data,
        },
    )

@api_view(["POST"])
def leafdet(request):

    file = request.FILES.get("file")
    print(file)
    getDLResult(file)

    return Response(
        status=status.HTTP_200_OK,
        data={
            "status": "success",
            "data": "Hello World",
        },
    )


@api_view(["POST"])
def apple(request):
    file = request.FILES.get("file")
    return getResult(file, "apple")


@api_view(["POST"])
def cherry(request):
    file = request.FILES.get("file")
    return getResult(file, "cherry")


@api_view(["POST"])
def corn(request):
    file = request.FILES.get("file")
    return getResult(file, "corn")


@api_view(["POST"])
def grape(request):
    file = request.FILES.get("file")
    return getResult(file, "grape")


@api_view(["POST"])
def peach(request):
    file = request.FILES.get("file")
    return getResult(file, "peach")


@api_view(["POST"])
def pepper(request):
    file = request.FILES.get("file")
    return getResult(file, "pepper")


@api_view(["POST"])
def potato(request):
    file = request.FILES.get("file")
    return getResult(file, "potato")


@api_view(["POST"])
def rice(request):
    file = request.FILES.get("file")
    return getResult(file, "rice")


@api_view(["POST"])
def strawberry(request):
    file = request.FILES.get("file")
    return getResult(file, "strawberry")


def getResult(file, model_name):
    images = loadImage(file)
    path = (
        "F:\Development\Projects\LeafDiseaseDetection\API\models\\"
        + model_name
        + "_RF.jblib"
    )
    model = load(path)
    result = model.predict(images)
    return Response(
        status=status.HTTP_200_OK,
        data={
            "status": "success",
            "data": {"disease": result[0], "confidence": "100%"},
        },
    )


def loadImage(file):
    image = Image.open(file)
    image = image.resize((224, 224))
    image = np.array(image)
    input = []
    input.append(image)
    input = np.array(input)
    input = input.reshape(input.shape[0], -1)
    return input


def fetch_crop_data():
    json_file = "F:\Development\Projects\LeafDiseaseDetection\API\output.json"
    # print(json_file)
    #  "./API/output.json"
    with open(json_file, "r") as f:
        data = json.load(f)
        # print(data)
        return data


def getDLResult(file):
    image = loadImage(file)
    model = tf.keras.models.load_model(
        "F:\Development\Projects\LeafDiseaseDetection\API\models\EfficientNet-Lite_ModelLeaf.keras"
    )
    result = model.predict([image])
    print(result)


def getSchemesData():

    url = "https://agriwelfare.gov.in/en/Major"


    # Fetch the webpage content
    response = requests.get(url)
    soup = BeautifulSoup(response.content, "html.parser")

    # Find the table containing crop data
    table = soup.find("table")

    # Extract table headings
    headings = [th.text.strip() for th in table.find_all("th")]

    # Extract table rows
    rows = table.find_all("tr")[1:]  # Exclude the header row

    # Initialize a list to store data
    data = []

    # Extract data from each row
    for row in rows:
        row_data = [td.text.strip() for td in row.find_all("td")]
        links = { a for a in row.find_all("a")} # Extract links

        # Extract PDF links
        pdf_links = [link["href"] for link in links if link["href"].endswith(".pdf")]

        # Extract regular links
        links = {
            link["href"] for link in links if not link["href"].endswith(".pdf")
        }

        pdf_download_links = {}
        regular_links = {}

        # Format PDF links as download links
        pdf_download_links["Download Link"] = {
            "https://agriwelfare.gov.in" + link for link in pdf_links
        }

        # Format regular links
        regular_links["link"] = [link for link in links]

        # Combine regular and PDF links
        combined_links = regular_links | pdf_download_links

        row_data[-1] = combined_links  # Replace "DETAILS" with links
        data.append(dict(zip(headings, row_data)))
    
    return data