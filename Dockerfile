FROM maven:3.8.3-openjdk-17-slim AS build
WORKDIR /app
COPY . .
RUN mvn clean install -U

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/swagger-spring-1.0.0.jar .
EXPOSE 8080
CMD ["java", "-jar", "swagger-spring-1.0.0.jar"]