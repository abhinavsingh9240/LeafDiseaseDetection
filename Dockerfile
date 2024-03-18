# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.11.4

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

# Copy local code to the container image.
COPY /api/requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt
COPY . /tmp/


ENV /api /app
WORKDIR $app
COPY . ./

RUN ls .

# Install production dependencies.
# RUN pip install -r $app/requirement.txt

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app