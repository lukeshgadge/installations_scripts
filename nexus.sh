#!/bin/bash

# Update package manager repositories
sudo apt-get update

# Install necessary dependencies
sudo apt-get install -y ca-certificates curl

# Create directory for Docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker's GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

# Ensure proper permissions for the key
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to Apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package manager repositories
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 

################################
docker run -d --name nexus -p 8081:8081 sonatype/nexus3:latest

################################

'''
Get Nexus initial password

Your provided commands are correct for accessing the Nexus password stored in the container. Here's a breakdown of the steps:

    Get Container ID: You need to find out the ID of the Nexus container. You can do this by running:
'''
    docker ps
'''
This command lists all running containers along with their IDs, among other information.

Access Container's Bash Shell: Once you have the container ID, you can execute the docker exec command to access the container's bash shell:
'''
docker exec -it <container_ID> /bin/bash
'''
Replace <container_ID> with the actual ID of the Nexus container.

Navigate to Nexus Directory: Inside the container's bash shell, navigate to the directory where Nexus stores its configuration:
'''
cd sonatype-work/nexus3

##  View Admin Password: Finally, you can view the admin password by displaying the contents of the admin.password file:

cat admin.password

## Exit the Container Shell: Once you have retrieved the password, you can exit the container's bash shell:

exit
