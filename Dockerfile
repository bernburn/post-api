# Build stage
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Run stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/facebookapi-0.0.1-SNAPSHOT.jar app.jar

# Let Render know we’ll expose whatever port Render assigns
EXPOSE 8080

# Tell Spring Boot to use Render’s assigned PORT (not just 8080)
ENTRYPOINT ["sh", "-c", "java -jar app.jar --server.port=${PORT:-8080} --server.address=0.0.0.0"]
