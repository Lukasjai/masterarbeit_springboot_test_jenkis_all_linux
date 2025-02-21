FROM openjdk:17-jdk-slim
WORKDIR /workspace/app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN ./mvnw install -DskipTests
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)


FROM openjdk:17-jdk-slim
VOLUME /tmp
WORKDIR /app
COPY target/*.jar /app.jar
ENV SERVER_PORT=8080
ENTRYPOINT ["java", "-Dserver.port=${SERVER_PORT}", "-jar", "/app.jar"]

