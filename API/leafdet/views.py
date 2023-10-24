from django.shortcuts import render,HttpResponse

# Create your views here.
def helloworld(req):
    return HttpResponse('Hello World')
