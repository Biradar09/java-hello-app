# Stage 1: Build with Maven
FROM maven:3.8.6-openjdk-11 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Run App in Lightweight Container
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=build /app/target/helloapp-1.0.jar app.jar
CMD ["java", "-jar", "app.jar"]

