# Use official SonarQube Community Edition image
FROM sonarqube:community

# Expose SonarQube web port
EXPOSE 8080

# Volumes for persistence (important for AWS)
VOLUME ["/opt/sonarqube/data", "/opt/sonarqube/extensions", "/opt/sonarqube/logs"]

# Default command
CMD ["bin/sonar.sh", "-Dsonar.web.context=/"]
