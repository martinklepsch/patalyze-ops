FROM dockerfile/java

# copy the locally built fat-jar to the image
ADD https://s3-eu-west-1.amazonaws.com/patalyze/releases/patalyze-standalone.jar /
# ADD patalyze-standalone.jar /

EXPOSE 42042

# run the server when a container based on this image is being run
CMD [ "java", "-verbose", "-jar", "/patalyze-standalone.jar" ]
