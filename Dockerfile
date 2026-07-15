# Step 1: Use a minimal Ubuntu-based JRE image that natively supports Apple Silicon and AWS Intel chips
FROM eclipse-temurin:17-jre

# SRE Best Practice: Create a non-root system user for security isolation (Ubuntu syntax)
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Set a dedicated, clean runtime directory
WORKDIR /app

# Copy your newly compiled local jar file directly into the image filesystem
COPY target/sre-app-1.0.0-SNAPSHOT.jar app.jar

# SRE Best Practice: Change file ownership to your restricted non-root user
RUN chown -R appuser:appgroup /app
USER appuser

# SRE Best Practice: Configure JVM container awareness flags to prevent memory crashes
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

# Define the network port your microservice listener opens (Default Spring port)
EXPOSE 8080

# The execution command string that starts your Java process safely inside the cluster
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
