# Use an official lightweight Python base image
FROM python:3.11-slim

# Install dependencies for tkinter and X11 forwarding (if needed)
RUN apt-get update && apt-get install -y \
    python3-tk \
    tk \
    libx11-6 \
    libxtst6 \
    libxrender1 \
    libxext6 \
    libxi6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements file first (for better layer caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Ensure test script is executable
RUN chmod +x test.sh

# Set display environment variable (used for X11)
ENV DISPLAY=:0

# Default command: run test script (which sleeps 10s)
CMD ["./test.sh"]

