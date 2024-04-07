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

data = {
    "Leafdet": {
        "modelPath": "models\Shufflenet_Model_Leaf_Detection.keras",
        "classes": [
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
        "accuracy": 89.48,
        "classes": [
            {
                "name": "Brown Spot",
                "info": "Brown spots on rice leaves, affecting photosynthesis.",
                "cause": "Fungal pathogen Bipolaris oryzae.",
                "cure": "Use fungicides early in infection stages, ensure proper drainage, and maintain field hygiene.",
                "products": "Fungicides: Tricyclazole, Azoxystrobin, Propiconazole.",
            },
            {
                "name": "Healthy",
                "info": "Flourishing rice plants with vibrant green leaves and strong stems.",
                "cause": "Proper cultivation practices, good soil fertility, and adequate water management.",
                "cure": "Regular monitoring for pest or disease outbreaks and timely intervention.",
                "products": "Use Organic fertilizer, proper irrigation, pruning, and weed control are essential.",
            },
            {
                "name": "Hispa",
                "info": "Feeding damage causes white or transparent patches on leaves, reducing yield.",
                "cause": "Infestation by rice hispa insect (Dicladispa armigera).",
                "cure": "Use insecticides like chlorpyrifos, apply biological control agents, and practice integrated pest management.",
                "products": "Insecticides: Chlorpyrifos, Carbaryl, Thiamethoxam.",
            },
            {
                "name": "Leaf Blast",
                "info": "Circular lesions with gray centers on rice leaves, leading to yield loss.",
                "cause": "Fungus Magnaporthe oryzae.",
                "cure": "Apply fungicides at early infection stages, cultivate blast-resistant rice varieties, and ensure proper field drainage.",
                "products": "Fungicides: Tricyclazole, Azoxystrobin, Propiconazole.",
            },
        ],
    },
    "Apple": {
        "modelPath": "models/Shufflenet_Model_apple.keras",
        "accuracy": 100,
        "classes": [
            {
                "name": "Apple-Scab",
                "info": "Dark, scabby lesions on leaves and fruit, leading to defoliation and reduced yield.",
                "cause": "Fungus Venturia inaequalis.",
                "cure": "Apply fungicides preventively, prune infected branches, and practice orchard sanitation.",
                "products": "Fungicides: Captan, Mancozeb, Thiophanate-methyl.",
            },
            {
                "name": "Black Rot",
                "info": "Circular, sunken lesions on fruit, causing rot and mummification.",
                "cause": "Fungus Botryosphaeria obtusa.",
                "cure": "Apply fungicides before flowering, remove infected fruit, and practice good orchard hygiene.",
                "products": "Fungicides: Captan, Mancozeb, Thiophanate-methyl.",
            },
            {
                "name": "Cedar Rust",
                "info": "Rust-colored spots on leaves, leading to premature defoliation and reduced fruit yield.",
                "cause": "Fungus Gymnosporangium juniperi-virginianae.",
                "cure": "Prune nearby juniper trees, apply fungicides, and plant resistant apple varieties.",
                "products": "Fungicides: Myclobutanil, Propiconazole, Thiophanate-methyl",
            },
            {
                "name": "Healthy",
                "info": "Lush foliage, healthy fruit development, and optimal yield.",
                "cause": "Proper orchard management, disease-resistant cultivars, and favorable environmental conditions.",
                "cure": "Regular monitoring for pests and diseases, proper pruning, and maintaining orchard cleanliness.",
                "products": "Use Organic fertilizer, proper irrigation, pruning, and weed control are essential.",
            },
        ],
    },
    "Cherry": {
        "modelPath": "models/Shufflenet_Model_cherry (including sour).keras",
        "accuracy": 100,
        "classes": [
            {
                "name": "Healthy",
                "info": "Vibrant green foliage, vigorous growth, and abundant fruit set.",
                "cause": "Adequate sunlight, balanced nutrition, and disease-resistant cultivars.",
                "cure": "Regular pruning to improve air circulation, proper irrigation, and monitoring for pests and diseases.",
                "products": "Use Organic fertilizer, proper irrigation, pruning, and weed control are essential.",
            },
            {
                "name": "Powdery Mildew",
                "info": "White powdery patches on leaves and fruit, leading to leaf distortion and reduced yield.",
                "cause": "Fungus Podosphaera clandestina.",
                "cure": "Apply fungicides preventively, prune affected branches, and improve orchard airflow to reduce humidity.",
                "products": "Fungicides: Sulfur, Myclobutanil, Potassium bicarbonate.",
            },
        ],
    },
    "Corn": {
        "modelPath": "models/Shufflenet_Model_corn (maize).keras",
        "accuracy": 98.43,
        "classes": [
            {
                "name": "Cercospora Leaf Spot / Gray Leaf Spot",
                "info": "Grayish lesions with brown borders on leaves, reducing photosynthesis.",
                "cause": "Fungus Cercospora zeae-maydis.",
                "cure": "Plant resistant varieties, rotate crops, use fungicides early in the season.",
                "products": "Fungicides: Azoxystrobin, Pyraclostrobin, Propiconazole.",
            },
            {
                "name": "Common Rust",
                "info": "Orange to reddish-brown pustules on leaves, affecting nutrient absorption.",
                "cause": "Fungus Puccinia sorghi.",
                "cure": "Plant rust-resistant corn hybrids, apply fungicides if infection becomes severe.",
                "products": "Fungicides: Azoxystrobin, Pyraclostrobin, Propiconazole.",
            },
            {
                "name": "Healthy",
                "info": "Strong stalks, dark green leaves, and uniform ear development.",
                "cause": "Balanced soil fertility, proper irrigation, and planting disease-resistant varieties.",
                "cure": "Regular monitoring for pests and diseases, timely weed control, and maintaining optimal plant density.",
                "products": "Use Organic fertilizer, proper irrigation, pruning, and weed control are essential.",
            },
            {
                "name": "Northern Leaf Blight",
                "info": "Irregularly shaped lesions with tan centers on leaves, reducing photosynthesis.",
                "cause": "Fungus Exserohilum turcicum.",
                "cure": "Plant resistant hybrids, use fungicides preventively, practice crop rotation.",
                "products": "Fungicides: Azoxystrobin, Pyraclostrobin, Propiconazole.",
            },
        ],
    },
    "Grape": {
        "modelPath": "models/Shufflenet_Model_grape.keras",
        "accuracy": 100,
        "classes": [
            {
                "name": "Black Rot",
                "info": "Brown lesions on leaves and fruit, causing decay and shriveling.",
                "cause": "Fungus Guignardia bidwellii.",
                "cure": "Apply fungicides before bloom, prune for better airflow, and remove infected plant debris.",
                "products": "Fungicides: Captan, Mancozeb, Myclobutanil.",
            },
            {
                "name": "Esca / Black Measles",
                "info": "Yellowing between leaf veins, internal wood necrosis, and leaf malformation.",
                "cause": "Complex of fungi including Phaeoacremonium spp. and Phaeomoniella chlamydospora.",
                "cure": "Prune infected wood, use trunk protectants, and plant resistant varieties.",
                "products": "Fungicides: Propiconazole, Thiophanate-methyl, Boscalid.",
            },
            {
                "name": "Healthy",
                "info": "Vigorous vines, lush green foliage, and abundant fruit clusters.",
                "cause": "Proper vineyard management, disease-resistant cultivars, and favorable growing conditions.",
                "cure": "Regular monitoring for pests and diseases, adequate pruning, and maintaining vineyard sanitation.",
                "products": "Use Organic fertilizer, proper irrigation, pruning, and weed control are essential.",
            },
            {
                "name": "Leaf Blight / Isariopsis Leaf Spot",
                "info": "Circular brown lesions on leaves, reducing photosynthesis.",
                "cause": "Fungus Isariopsis griseola.",
                "cure": "Apply fungicides preventively, prune for better airflow, and remove infected plant material.",
                "products": "Fungicides: Mancozeb, Copper-based fungicides, Myclobutanil.",
            },
        ],
    },
    "Peach": {
        "modelPath": "models/Shufflenet_Model_peach.keras",
        "accuracy": 100,
        "classes": [
            {
                "name": "Bacterial Spot",
                "info": "Dark brown lesions on leaves and fruit, leading to defoliation and reduced yield.",
                "cause": "Bacterium Xanthomonas arboricola pv. pruni.",
                "cure": "Apply copper-based bactericides, prune infected branches, and practice orchard sanitation.",
                "products": "Bactericides: Copper-based bactericides, Streptomycin.",
            },
            {
                "name": "Healthy",
                "info": "Lush foliage, vigorous growth, and abundant fruit set.",
                "cause": "Proper orchard management, disease-resistant cultivars, and optimal growing conditions.",
                "cure": "Regular monitoring for pests and diseases, proper pruning, and maintaining orchard cleanliness.",
                "products": "Use Organic fertilizer, proper irrigation, pruning, and weed control are essential.",
            },
        ],
    },
    "Pepper": {
        "modelPath": "models/Shufflenet_Model_pepper, bell.keras",
        "accuracy": 100,
        "classes": [
            {
                "name": "Bacterial Spot",
                "info": "Circular, water-soaked lesions on leaves and fruit, leading to defoliation and reduced yield.",
                "cause": "Bacterium Xanthomonas campestris pv. vesicatoria.",
                "cure": "Apply copper-based bactericides, practice crop rotation, and remove infected plant debris.",
                "products": "Bactericides: Copper-based bactericides, Streptomycin.",
            },
            {
                "name": "Healthy",
                "info": "Dark green foliage, sturdy stems, and abundant fruit production.",
                "cause": "Proper care, disease-resistant varieties, and suitable growing conditions.",
                "cure": "Regular monitoring for pests and diseases, balanced nutrition, and timely watering.",
                "products": "Use Organic fertilizer, proper irrigation, pruning, and weed control are essential.",
            },
        ],
    },
    "Potato": {
        "modelPath": "models/Shufflenet_Model_potato.keras",
        "accuracy": 100,
        "classes": [
            {
                "name": "Early Blight",
                "info": "Brown lesions on lower leaves, leading to premature defoliation.",
                "cause": "Fungus Alternaria solani.",
                "cure": "Apply fungicides preventively, practice crop rotation, and remove infected plant debris.",
                "products": "Fungicides: Chlorothalonil, Mancozeb, Propiconazole.",
            },
            {
                "name": "Healthy",
                "info": "Vibrant green foliage, robust stems, and abundant tuber production.",
                "cause": "Optimal growing conditions, disease-resistant cultivars, and proper field management.",
                "cure": "Regular monitoring for pests and diseases, balanced fertilization, and adequate irrigation.",
                "products": "Use Organic fertilizer, proper irrigation, pruning, and weed control are essential.",
            },
            {
                "name": "Late Blight",
                "info": "Dark lesions on leaves, leading to rapid defoliation and tuber rot.",
                "cause": "Fungus Phytophthora infestans.",
                "cure": "Apply fungicides preventively, practice good ventilation, and remove infected plant material promptly.",
                "products": "Fungicides: Chlorothalonil, Mancozeb, Metalaxyl.",
            },
        ],
    },
    "Strawberry": {
        "modelPath": "models\Shufflenet_Model_strawberry.keras",
        "accuracy": 100,
        "classes": [
            {
                "name": "Healthy",
                "info": "Lush green foliage, vigorous growth, and abundant fruit production.",
                "cause": "Ideal growing conditions, disease-resistant cultivars, and proper care.",
                "cure": "Regular irrigation, weed control, and monitoring for pests and diseases.",
                "products": "Use Organic fertilizer, proper irrigation, pruning, and weed control are essential.",
            },
            {
                "name": "Leaf Scorch",
                "info": "Reddish-brown lesions on leaf margins, leading to leaf drying and reduced yield.",
                "cause": "Fungus Diplocarpon earlianum.",
                "cure": "Apply fungicides preventively, remove infected leaves, and maintain good air circulation around plants.",
                "products": "Fungicides: Tricyclazole, Azoxystrobin, Propiconazole.",
            },
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
    predicted_class = data[modelName]["classes"][np.argmax(result)]
    return predicted_class


def getDLResult(file):
    image = loadImage(file)
    predicted_class = predictData("Leafdet", image)

    if predicted_class in data:
        result = predictData(predicted_class, image)
        return {
            "leaf": predicted_class,
            "disease": result,
            "accuracy": data[predicted_class]["accuracy"],
        }
    else:
        return {
            "leaf": "Not Found",
            "disease": "Not Found",
            "accuracy": 0,
        }
