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


Where to get the war file (replace with your own username):
/Users/sashamilne/Documents/GitHub/ehotel/ehotel/target/ehotel.war

Where to put the war file:
/opt/homebrew/Cellar/tomcat/11.0.5/libexec/webapps

How to move in one step:
cp /Users/sashamilne/Documents/GitHub/ehotel/ehotel/target/ehotel.war /opt/homebrew/Cellar/tomcat/11.0.5/libexec/webapps



How do configure database connection

add this to the file /opt/homebrew/opt/tomcat/libexec/conf/context.xml inside <context>

<Resource name="jdbc/ehotelDB"
          auth="Container"
          type="javax.sql.DataSource"
          driverClassName="org.postgresql.Driver"
          url="jdbc:postgresql://localhost:5432/ehotel"
          username="sashamilne"
          password="password"
          maxTotal="20"
          maxIdle="10"
          maxWaitMillis="-1"/>
