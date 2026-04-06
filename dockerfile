FROM eclipse-temurin:17-jre
WORKDIR /app
COPY java-ci-app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
