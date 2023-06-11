# Build stage for Vue front-end
FROM node:14.17.0-alpine as frontend-build
WORKDIR /frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend .
RUN npm run build

# Build stage for Spring Boot back-end
FROM maven:3.8.3-openjdk-17-slim as backend-build
WORKDIR /backend
COPY backend/pom.xml ./
RUN mvn dependency:go-offline
COPY backend/src ./src
RUN mvn package -DskipTests



# Final image with combined front-end and back-end
FROM openjdk:17-jdk-slim
WORKDIR /
COPY --from=frontend-build frontend/dist frontend/dist
COPY --from=backend-build backend/target/swagger-spring-1.0.0.jar .
EXPOSE 8080
CMD ["java", "-jar", "swagger-spring-1.0.0.jar"]