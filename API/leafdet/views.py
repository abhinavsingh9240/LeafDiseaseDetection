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
import os


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
    json_file = 'F:\Development\Projects\LeafDiseaseDetection\API\output.json'
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
