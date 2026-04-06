FROM eclipse-temurin:17-jre
WORKDIR /app
COPY java-ci-app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
