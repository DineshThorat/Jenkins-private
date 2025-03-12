# Use the official Python base image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file (if you have one)
# You may need to create a requirements.txt with flask in it
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# RUN export EXPOSE=$(cat /mnt/secrets-store/EXPOSE)

# Copy the rest of the application code to the container
COPY . .

# Expose the port Flask will run on
EXPOSE 5000

# Set environment variables (Optional but recommended)
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000

# Run the Flask app
CMD ["flask", "run"]
