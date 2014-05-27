FROM dockerfile/java

# copy the locally built fat-jar to the image
ADD patalyze-standalone.jar /
# ADD patalyze-standalone.jar /

EXPOSE 42042

# run the server when a container based on this image is being run
CMD [ "java", "-verbose", "-jar", "/patalyze-standalone.jar" ]
