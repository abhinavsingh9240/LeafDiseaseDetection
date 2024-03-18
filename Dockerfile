# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.11.4

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

# Copy local code to the container image.

RUN pip install --upgrade pip

WORKDIR /api/

COPY /api/requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt
COPY /api .

CMD [ "python", "manage.py",  "runserver", "0.0.0.0:8080"]