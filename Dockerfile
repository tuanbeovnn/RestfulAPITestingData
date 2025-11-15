# Build Stage
FROM maven:3.9.5-eclipse-temurin-21 AS build

WORKDIR /opt/app

# Copy only pom.xml first for better layer caching
COPY pom.xml .
RUN --mount=type=cache,target=/root/.m2 mvn dependency:go-offline

# Copy source code and build
COPY src ./src
RUN --mount=type=cache,target=/root/.m2 mvn clean package -DskipTests

# Runtime Stage
FROM eclipse-temurin:21-jre-jammy

# Create non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /opt/app

# Copy the JAR from build stage
COPY --from=build /opt/app/target/*.jar app.jar

# Change ownership to non-root user
RUN chown -R appuser:appuser /opt/app
USER appuser

# Environment variables
ENV PORT=8080
ENV JAVA_OPTS="-Xmx1024M -Xms512M"

EXPOSE $PORT

# Use shell form to allow variable expansion
ENTRYPOINT java $JAVA_OPTS -Dserver.port=${PORT} -jar app.jar