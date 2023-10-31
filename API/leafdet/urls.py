"""
URL configuration for API project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.urls import path,include
from . import views

urlpatterns = [
    path('apple',views.apple,name='apple'),
    path('cherry',views.cherry,name='cherry'),
    path('corn',views.corn,name='corn'),
    path('grape',views.grape,name='grape'),
    path('peach',views.peach,name='peach'),
    path('pepper',views.pepper,name='pepper'),
    path('potato',views.potato,name='potato'),
    path('rice',views.rice,name='rice'),
    path('strawberry',views.strawberry,name='strawberry'),
]
