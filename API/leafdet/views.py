from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from joblib import load
from PIL import Image
import numpy as np

@api_view(['POST'])
def apple(request):
    file = request.FILES.get('file')
    return getResult(file,'apple')

@api_view(['POST'])
def cherry(request):
    file = request.FILES.get('file')
    return getResult(file,'cherry')

@api_view(['POST'])
def corn(request):
    file = request.FILES.get('file')
    return getResult(file,'corn')

@api_view(['POST'])
def grape(request):
    file = request.FILES.get('file')
    return getResult(file,'grape')

@api_view(['POST'])
def peach(request):
    file = request.FILES.get('file')
    return getResult(file,'peach')

@api_view(['POST'])
def pepper(request):
    file = request.FILES.get('file')
    return getResult(file,'pepper')

@api_view(['POST'])
def potato(request):
    file = request.FILES.get('file')
    return getResult(file,'potato')

@api_view(['POST'])
def rice(request):
    file = request.FILES.get('file')
    return getResult(file,'rice')

@api_view(['POST'])
def strawberry(request):
    file = request.FILES.get('file')
    return getResult(file,'strawberry')

def getResult(file,model_name):
    images = loadImage(file)
    path = 'F:\Development\Projects\LeafDiseaseDetection\API\models\\' + model_name + '_RF.jblib' 
    model = load(path)
    result = model.predict(images) 
    return Response(status=status.HTTP_200_OK,data={
        'status': 'success',
        'data': {
            'disease': result[0],
            'confidence': '100%'
        }
    })

def loadImage(file):    
    image = Image.open(file)
    image = image.resize((224,224))
    image = np.array(image)
    input = []
    input.append(image)
    input = np.array(input)
    input = input.reshape(input.shape[0],-1)
    return input

