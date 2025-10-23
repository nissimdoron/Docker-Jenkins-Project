# Use official Python base image
FROM python:3.11-slim

# Prevent tzdata or debconf from asking interactive questions
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies (for tkinter + evdev)
RUN apt-get update && apt-get install -y \
    python3-tk \
    tk \
    libx11-6 \
    libxtst6 \
    libxrender1 \
    libxext6 \
    libxi6 \
    build-essential \
    python3-dev \
    libevdev-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Copy dependency list
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip setuptools wheel \
    && pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Default command (you can change this)
CMD ["python", "app.py"]

