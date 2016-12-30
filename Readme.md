# DemoJavaFortranInterface

[![Travis][buildstatus_image_travis]][travisci]

It is a minimal example to show how to interface a Fortran library with a Java code.

It uses the [JNA](https://github.com/java-native-access/jna) to load the shared Fortran library.


# Running

The demo is run by calling `make`, that will perform all the required operations.

    $ make
    # Fetching the jna.jar file from github
    wget https://maven.java.net/content/repositories/releases/net/java/dev/jna/jna/4.2.2/jna-4.2.2.jar -O jna.jar
    # Creating the Fortran shared library with hard coded data path to load
    sed "s/FULLPATH/`pwd | sed 's/\//\\\\\//g'`/g" myfortranlib.f90 > tmp.f90
    gfortran -fno-underscoring -fPIC -c -g -o myfortran.o tmp.f90
    gfortran -shared -o libmyfortran.so myfortran.o
    rm -f tmp.f90
    # Creating the java/fortran interface file with hard coded path to load the fortran shared library
    mkdir -p demoJna
    sed "s/LIBRARYFULLPATH/`pwd | sed 's/\//\\\\\//g'`/g" FortranInterface.java.in > demoJna/FortranInterface.java
    # Copying demo java file
    mkdir -p demoJna
    cp demo.java.in demoJna/demo.java
    # Compiling Java
    javac -cp .:jna.jar demoJna/demo.java demoJna/FortranInterface.java
    # Creating dummy data file to load with the Fortran library
    echo "2.3" > data.txt
    # Running the Java demo
    # It should be displaying the value contained in the generated data file
    java -cp .:jna.jar demoJna/demo
    START READING
    2.2999999999999998
    END READING

[buildstatus_image_travis]: https://travis-ci.org/Gjacquenot/DemoJavaFortranInterface.svg?branch=master
[travisci]: https://travis-ci.org/Gjacquenot/DemoJavaFortranInterface
