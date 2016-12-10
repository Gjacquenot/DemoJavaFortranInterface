export root_dir_escaped=`pwd | sed 's/\//\\\\\//g'`

all: run

jna.jar:
	@echo "# Fetching the jna.jar file from github"
	wget https://maven.java.net/content/repositories/releases/net/java/dev/jna/jna/4.2.2/jna-4.2.2.jar -O jna.jar

demoJna/FortranInterface.java: FortranInterface.java.in
	@echo "# Creating the java/fortran interface file with hard coded path to load the fortran shared library"
	mkdir -p demoJna
	sed "s/LIBRARYFULLPATH/${root_dir_escaped}/g" FortranInterface.java.in > demoJna/FortranInterface.java

demoJna/demo.java: demo.java.in
	@echo "# Copying demo java file"
	mkdir -p demoJna
	cp demo.java.in demoJna/demo.java

libmyfortran.so: myfortranlib.f90
	@echo "# Creating the Fortran shared library with hard coded data path to load"
	sed "s/FULLPATH/${root_dir_escaped}/g" myfortranlib.f90 > tmp.f90
	gfortran -fno-underscoring -fPIC -c -g -o myfortran.o tmp.f90
	gfortran -shared -o libmyfortran.so myfortran.o
	rm -f tmp.f90

data.txt:
	@echo "# Creating dummy data file to load with the Fortran library"
	echo "2.3" > data.txt

clean:
	@echo "# Cleaning up everything"
	@rm -rf data.txt demoJna *.class *.o *.so *.mod

compileJava: demoJna/FortranInterface.java demoJna/demo.java
	@echo "# Compiling Java"
	javac -cp .:jna.jar demoJna/demo.java demoJna/FortranInterface.java

run: jna.jar libmyfortran.so compileJava data.txt
	@echo "# Running the Java demo"
	@echo "# It should be displaying the value contained in the generated data file"
	java -cp .:jna.jar demoJna/demo

.PHONY: run clean

