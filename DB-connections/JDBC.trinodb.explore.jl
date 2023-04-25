#=  ================================================================================================
    JDBC attempt connection to TrinoDB at work

    trino provides a driver: https://trino.io/docs/current/client/jdbc.html
    needs JavaCall
    $> JULIA_COPY_STACKS=1 julia
=   ===============================================================================================#

driverpath = "/Users/merlinr/.trino/trino-jdbc-406.jar"


using JDBC, JavaCall

JDBC.usedriver(driverpath)

JavaCall.addClassPath(pwd())

JavaCall.addOpts("-Xmx1024M")
OrderedCollections.OrderedSet{String} with 1 element:
  "-Xmx1024M"

JavaCall.addOpts("-Xrs")
OrderedCollections.OrderedSet{String} with 2 elements:
  "-Xmx1024M"
  "-Xrs"

JDBC.init()
The operation couldn’t be completed. Unable to locate a Java Runtime.
Please visit http://www.java.com for information on installing Java.

## TODO: i guess it needs a java installation somewhere. try a container?

