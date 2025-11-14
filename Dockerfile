# Build Stage
FROM maven:3.9.5-eclipse-temurin-21 AS build

WORKDIR /opt/app

COPY ./ /opt/app
RUN --mount=type=cache,target=/root/.m2 mvn clean install -DskipTests

# Runtime Stage
FROM eclipse-temurin:21-jdk-jammy

WORKDIR /opt/app
COPY --from=build /opt/app/target/*.jar app.jar

ENV PORT=8080
EXPOSE $PORT

ENTRYPOINT ["java","-jar","-Xmx1024M","-Dserver.port=${PORT}","app.jar"]
