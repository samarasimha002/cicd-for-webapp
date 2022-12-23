# Pull base image 
#From tomcat:8-jre8 

# Maintainer 
#MAINTAINER "bharathreddyv88@gmail.com" 
#COPY ./cicd-for-webapp.war /usr/local/tomcat/webapps

FROM maven:3.6.3-openjdk-14-slim AS build
RUN mkdir -p /workspace
WORKDIR /workspace
COPY . /workspace
#COPY src /workspace/src
RUN mvn -B package --file pom.xml -DskipTests

FROM tomcat:jre11
COPY  --from=build /workspace/target/cicd-for-webapp.war /usr/local/tomcat/webapps/
EXPOSE 8080
VOLUME /usr/local/tomcat
ENTRYPOINT ["catalina.sh", "jpda","run"]
