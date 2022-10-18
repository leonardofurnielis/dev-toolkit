#FROM registry.redhat.io/openj9/openj9-11-rhel8:latest
FROM openjdk:11-jdk

WORKDIR /opt/app-root

#RUN addgroup --system spring && adduser --system spring -ingroup spring

#USER spring:spring

COPY target/*.jar /opt/app-root/app.jar

ENTRYPOINT ["java","-jar","app.jar"]
