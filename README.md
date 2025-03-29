DEPENDENCIES

This project requires openjdk, maven, postgresql, and apache tomcat to run
These can be installed using (using homebrew if you haven't yet installed it)
	- brew install openjdk
	- brew install maven
	- brew install postgresql



IMPORTANT COMMANDS

- generating project

mvn archetype:generate -DgroupId=com.example -DartifactId=ehotel \
    -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false \
    -DoutputDirectory=/Users/[username]/Documents/GitHub/ehotel