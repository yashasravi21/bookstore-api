# syntax=docker/dockerfile:1

# ---------- Stage 1: build the jar ----------
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /build

# Copy the POM first so the dependency layer is cached until dependencies change.
COPY pom.xml .
RUN mvn -B dependency:go-offline

# Copy sources and package.
COPY src ./src
RUN mvn -B clean package -DskipTests

# ---------- Stage 2: runtime image ----------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Run as a non-root user.
RUN adduser -D -u 1001 spring

COPY --from=build /build/target/*.jar app.jar

RUN chown spring:spring /app/app.jar
USER spring

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
