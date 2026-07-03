#!/bin/bash
set -e  # Exit if any command fails

# Update system
sudo apt update -y

# Install Java (OpenJDK 17)
echo "Installing Java..."
sudo apt install openjdk-17-jdk -y
java -version

# Install Jenkins
echo "Installing Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install jenkins -y

# Try to start Jenkins (if systemd is supported)
if command -v systemctl &> /dev/null; then
  sudo systemctl enable jenkins || true
  sudo systemctl start jenkins || true
  sudo systemctl status jenkins --no-pager || true
else
  echo "Systemd not available — if running on WSL, start Jenkins manually:"
  echo "  sudo java -jar /usr/share/java/jenkins.war"
fi

# Install Docker
echo "Installing Docker..."
sudo apt install docker.io -y
sudo usermod -aG docker "$USER"
sudo chmod 666 /var/run/docker.sock

# Run SonarQube in Docker
echo "Starting SonarQube container..."
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community || true

# Install Trivy
echo "Installing Trivy..."
sudo apt install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt update -y
sudo apt install trivy -y

echo "✅ All installations completed successfully!"