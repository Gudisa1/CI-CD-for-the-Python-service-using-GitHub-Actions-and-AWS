# Use an official Python runtime as the base image
FROM python:3.9-slim

# Update package lists and upgrade packages
RUN apt-get update && apt-get upgrade -y

# Install dependencies
RUN apt-get install -y \
    zlib1g \
    libexpat1

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install Python dependencies (Flask)
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port that Flask listens on
EXPOSE 80  # Changed to match Docker Compose port mapping

# Define environment variable for Flask
ENV FLASK_APP=counter-app.py

# Run the Flask app
CMD ["flask", "run", "--host=0.0.0.0", "--port=80"]  # Changed port to 80
