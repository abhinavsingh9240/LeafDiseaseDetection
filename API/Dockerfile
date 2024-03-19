# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.11.4
# ENV PORT 8080
# EXPOSE $PORT
# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True
RUN pip install --upgrade pip
WORKDIR /API
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
RUN ls

CMD [ "python", "manage.py",  "runserver", "0.0.0.0:8080"]
