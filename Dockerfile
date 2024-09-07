# Use an official Python runtime as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install Python dependencies (Flask)
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port that Flask listens on
EXPOSE 8080

# Define environment variable for Flask
ENV FLASK_APP=counter-app.py

# Run the Flask app
CMD ["flask", "run", "--host=0.0.0.0", "--port=8080"]
