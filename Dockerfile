# Build stage
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
# Download dependencies first (caching)
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package

# Run stage
FROM tomcat:10.1-jdk21
# Remove default webapps (optional but good for clean root)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR as ROOT.war for context path /
COPY --from=build /app/target/noobs-codeshare.war /usr/local/tomcat/webapps/ROOT.war

# Render provides the PORT environment variable.
# We modify Tomcat's server.xml to listen on $PORT instead of default 8080.
# If PORT is not set, it defaults to 8080.
CMD sed -i -e "s/port=\"8080\"/port=\"${PORT:-8080}\"/g" /usr/local/tomcat/conf/server.xml && catalina.sh run
