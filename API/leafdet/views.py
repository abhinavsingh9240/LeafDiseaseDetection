from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from joblib import load
from PIL import Image
import numpy as np
import requests
from bs4 import BeautifulSoup
import json
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

    url = "https://www.allthatgrows.in/blogs/posts/vegetable-growing-season-chart-india"

    try:
        response = requests.get(url)
        # print(response.status_code)
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

                data = crop_data
                print(data)
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

def getDLResult(file):
    image = loadImage(file)
    model = tf.keras.models.load_model('F:\Development\Projects\LeafDiseaseDetection\API\models\EfficientNet-Lite_ModelLeaf.keras')
    result = model.predict([image])
    print(result)