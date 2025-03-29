DEPENDENCIES

This project requires openjdk, maven, postgresql, and apache tomcat to run
These can be installed using (using homebrew if you haven't yet installed it)
	- brew install openjdk
	- brew install maven
	- brew install postgresql
	- brew install tomcat

To start tomcat:
	- brew services start tomcat



IMPORTANT COMMANDS

- generating project

mvn archetype:generate -DgroupId=com.example -DartifactId=ehotel \
    -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false \
    -DoutputDirectory=/Users/[username]/Documents/GitHub/ehotel


Where to get the war file

Where to put the war file
/opt/homebrew/Cellar/tomcat/11.0.5/libexec/webapps
