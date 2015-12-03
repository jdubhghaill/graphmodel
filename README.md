A directed graph model application
==================================

This is a small nodejs coffeescript application for modelling a graph and running a few different calculations on it. The libraries [MochaJS](https://mochajs.org/)
and [ShouldJS](https://github.com/shouldjs/should.js) are used in the testing.

Installation
------------

This application was created using NodeJs 5.1.0 and NPM 3.3.12. You will need to install nodejs 5.1.0 from either the [nodejs website](https://nodejs.org/en/)
or from your operating systems repositories and add it to your path. Once you have node and npm installed (try running npm -v to check) you can run this
application by using the npm command in the root on the project using a terminal. All the projects npm dependencies are packaged with it so you should be
ready to go.

Running
-------

**npm start file={path} {command} {arguments..}**

The application can be run from the root of the project directory with the commmand npm start. A file containing the graph data should be passed
with the file={path} argument. The graph data should comma separated as in the following example:
AB5, BC4, CD8, DC8, DE6, AD5, CE2, EB3, AE7

There are 5 possible commands that can passed each of which require their own arguments. They are:

**distance {a list of comma seperated nodes}**
Returns the distance for a given route. In all commands nodes should be referred to by the letters in the data file and are case sensitive.

**routemaxstops {starting node} {ending node} {maximum stops}**
Returns the routes between nodes 2 nodes with fewer stops than the given maximum.

**routeexactstops {starting node} {ending node} {number of stops}**
Returns the routes between nodes 2 nodes with the exact number of stops passed.

**shortestroute {starting node} {ending node}**
Returns the shorted route between 2 nodes.

**routesindistance {starting node} {ending node} {maximum distance}**
Returns the routes between 2 nodes that have a distance less than maximum given.

Testing
-------

The tests are found in test/test.coffee and can be run from the project root with the command 'npm test'

Example: **npm test**

No file provided. A file of comma separated graph data should be provided with the argument file={path to file}

  Route graph
    ✓ A - B - C should have a distance of 9
    ✓ A - D should have a distance of 5
    ✓ A - D - C should have a distance of 13
    ✓ A - E - B - C - D should have a distance of 22
    ✓ there is no route between A - E - D
    ✓ the number of trips starting at C and ending at C with a maximum of 3 stops is 2
    ✓ the number of trips starting at A and ending at C with exactly 4 stops is 3
    ✓ the shortest route between A and C in term of distance is 9
    ✓ the shortest route between B and B in term of distance is 9
    ✓ the number of routes between C and C with a distance under 30 is 7


  10 passing (7ms)


Examples
--------

**npm start file=example.data distance A,B,C**

Loading file example.data
Generating graph from AB5,BC4,CD8,DC8,DE6,AD5,CE2,EB3,AE7
Calculating distance for route A,B,C
Distance is 9


**npm start file=example.data routemaxstops C C 3**

Loading file example.data
Generating graph from AB5,BC4,CD8,DC8,DE6,AD5,CE2,EB3,AE7
Calculating the number of routes starting at C and ending at C with a maximum of 3 stops
Found 2 routes:
[ 'C', 'D', 'C' ]
[ 'C', 'E', 'B', 'C' ]


**npm start file=example.data routeexactstops A C 4**

Loading file example.data
Generating graph from AB5,BC4,CD8,DC8,DE6,AD5,CE2,EB3,AE7
Calculating the number of routes starting at A and ending at C with exactly 4 stops
Found 3 routes:
[ 'A', 'B', 'C', 'D', 'C' ]
[ 'A', 'D', 'C', 'D', 'C' ]
[ 'A', 'D', 'E', 'B', 'C' ]


**npm start file=example.data shortestroute B B**

Loading file example.data
Generating graph from AB5,BC4,CD8,DC8,DE6,AD5,CE2,EB3,AE7
Calculating the shortest route between B and B
The shortest route has a distance of 9 and is
B
C
E
B


**npm start file=example.data routesindistance C C 30**

Loading file example.data
Generating graph from AB5,BC4,CD8,DC8,DE6,AD5,CE2,EB3,AE7
Finding all routes between C and C with a distance less than 30
Found 7 routes:
[ 'C', 'D', 'C' ]
[ 'C', 'E', 'B', 'C' ]
[ 'C', 'D', 'E', 'B', 'C' ]
[ 'C', 'D', 'C', 'E', 'B', 'C' ]
[ 'C', 'E', 'B', 'C', 'D', 'C' ]
[ 'C', 'E', 'B', 'C', 'E', 'B', 'C' ]
[ 'C', 'E', 'B', 'C', 'E', 'B', 'C', 'E', 'B', 'C' ]
