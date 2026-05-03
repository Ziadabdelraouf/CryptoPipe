# Start with the official Mage image
FROM mageai/mageai:latest

# Set the working directory
WORKDIR /home/src

# 1. Install System Dependencies & Terraform
RUN apt-get update && apt-get install -y \
    gnupg \
    software-properties-common \
    wget \
    curl \
    unzip \
    && wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update && apt-get install -y terraform \
    && rm -rf /var/lib/apt/lists/*

# 2. Copy the Python requirements file into the container
COPY requirements.txt .

# 3. Install all the necessary Python libraries (including dbt)
RUN pip3 install -r requirements.txt