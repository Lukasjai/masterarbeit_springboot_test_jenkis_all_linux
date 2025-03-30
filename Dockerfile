FROM openjdk:17-jdk-slim as builder
WORKDIR /workspace/app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

# Baue die Applikation
RUN ./mvnw install -DskipTests
# extrahiere die jar files
#RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)

FROM openjdk:17-jdk-slim
VOLUME /tmp
WORKDIR /app
#COPY target/*.jar /app.jar
COPY --from=builder /workspace/app/target/*.jar /app.jar

ENV PORT=${PORT}
#startet JVM und fuehrt jar aus
ENTRYPOINT ["java", "-Dserver.port=${PORT}", "-jar", "/app.jar"]

