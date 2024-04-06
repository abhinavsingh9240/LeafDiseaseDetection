from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from PIL import Image
import numpy as np
import requests
from bs4 import BeautifulSoup
import json
import os

os.environ["TF_ENABLE_ONEDNN_OPTS"] = "0"
import tensorflow as tf
import keras
from tensorflow.keras import layers

leafNames = []

data = {
    "Leafdet": {
        "modelPath": "models\Shufflenet_Model_Leaf_Detection.keras",
        "classNames": [
            "Cassava",
            "Rice",
            "Apple",
            "Cherry",
            "Corn",
            "Grape",
            "Orange",
            "Peach",
            "Pepper",
            "Potato",
            "Squash",
            "Strawberry",
            "Tomato",
        ],
    },
    "Rice": {
        "modelPath": "models/Shufflenet_Model_Rice.keras",
        "classNames": [
            "BrownSpot",
            "Healthy",
            "Hispa",
            "LeafBlast",
        ],
    },
    "Apple": {
        "modelPath": "models/Shufflenet_Model_apple.keras",
        "classNames": [
            "Apple Scab",
            "Black Rot",
            "Cedar Apple Rust",
            "Healthy",
        ],
    },
    "Cherry": {
        "modelPath": "models/Shufflenet_Model_cherry (including sour).keras",
        "classNames": [
            "Healthy",
            "Powdery Mildew",
        ],
    },
    "Corn": {
        "modelPath": "models/Shufflenet_Model_corn (maize).keras",
        "classNames": [
            "Cercospora Leaf Spot",
            "Common Rust",
            "Healthy",
            "Northern Leaf Blight",
        ],
    },
    "Grape": {
        "modelPath": "models/Shufflenet_Model_grape.keras",
        "classNames": [
            "Black Rot",
            "Esca",
            "Healthy",
            "Leaf Blight",
        ],
    },
    "Peach": {
        "modelPath": "models/Shufflenet_Model_peach.keras",
        "classNames": [
            "Bacterial Spot",
            "Healthy",
        ],
    },
    "Pepper": {
        "modelPath": "models/Shufflenet_Model_pepper, bell.keras",
        "classNames": [
            "Bacterial Spot",
            "Healthy",
        ],
    },
    "Potato": {
        "modelPath": "models/Shufflenet_Model_potato.keras",
        "classNames": [
            "Early Blight",
            "Healthy",
            "Late Blight",
        ],
    },
    "Strawberry": {
        "modelPath": "models\Shufflenet_Model_strawberry.keras",
        "classNames": [
            "Healthy",
            "Leaf Scorch",
        ],
    },
}


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
    result = getDLResult(file)

    return Response(
        status=status.HTTP_200_OK,
        data={
            "status": "success",
            "data": result,
        },
    )


def channel_shuffle(x, groups):
    height, width, channels = x.shape.as_list()[1:]
    channels_per_group = channels // groups
    x = tf.reshape(x, [-1, height, width, groups, channels_per_group])
    x = tf.transpose(x, [0, 1, 2, 4, 3])
    x = tf.reshape(x, [-1, height, width, channels])
    return x


def loadImage(file):
    img = Image.open(file)
    img = img.resize(
        (256, 256)
    )  # Resize the image to match the input size of the model
    img = np.array(img) / 255.0  # Normalize pixel values
    img = np.expand_dims(img, axis=0)  # Add batch dimension
    return img


def fetch_crop_data():
    json_file = "F:\Development\Projects\LeafDiseaseDetection\API\output.json"
    with open(json_file, "r") as f:
        data = json.load(f)

        return data


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
        links = {a for a in row.find_all("a")}  # Extract links

        # Extract PDF links
        pdf_links = [link["href"] for link in links if link["href"].endswith(".pdf")]

        # Extract regular links
        links = {link["href"] for link in links if not link["href"].endswith(".pdf")}

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


@tf.keras.utils.register_keras_serializable(package="Custom", name="channel_shuffle")
class ChannelShuffle(layers.Layer):
    def __init__(self, groups=2, **kwargs):
        super(ChannelShuffle, self).__init__(**kwargs)
        self.groups = groups

    def call(self, inputs):
        return channel_shuffle(inputs, self.groups)

    def get_config(self):
        config = super(ChannelShuffle, self).get_config()
        config.update({"groups": self.groups})
        return config

    @classmethod
    def from_config(cls, config):
        return cls(**config)


def predictData(modelName, image):
    leafDetModel = os.path.join(os.getcwd(), data[modelName]["modelPath"])
    with tf.keras.utils.custom_object_scope({"ChannelShuffle": ChannelShuffle}):
        model = tf.keras.models.load_model(leafDetModel)
    result = model.predict(image)
    predicted_class = data[modelName]["classNames"][np.argmax(result)]
    return predicted_class


def getDLResult(file):
    image = loadImage(file)
    predicted_class = predictData("Leafdet", image)

    if predicted_class in data:
        result = predictData(predicted_class, image)
        return {
            "leaf": predicted_class,
            "disease": result,
        }
    else:
        return {
            "leaf": 'Not Found',
            "disease": 'Not Found', 
        }
