app = require '../index.coffee'
should = require 'should'

exampleData = ["AB5", "BC4", "CD8", "DC8", "DE6", "AD5", "CE2", "EB3", "AE7"]
graph = {}
app.generateGraph graph, exampleData

describe 'Route graph', ->
  it 'A - B - C should have a distance of 9', ->
    app.routeDistance(graph, ["A", "B", "C"]).should.equal 9
  it 'A - D should have a distance of 5', ->
    app.routeDistance(graph, ["A", "D"]).should.equal 5
  it 'A - D - C should have a distance of 13', ->
    app.routeDistance(graph, ["A", "D", "C"]).should.equal 13
  it 'A - E - B - C - D should have a distance of 22', ->
    app.routeDistance(graph, ["A", "E", "B", "C", "D"]).should.equal 22
  it 'there is no route between A - E - D', ->
    app.routeDistance.bind(null, graph, ["A", "E", "D"]).should.throw("There is no route from E to D")
  it 'the number of trips starting at C and ending at C with a maximum of 3 stops is 2', ->
    app.findRouteWithMaxStops(graph, "C", "C", 3).length.should.equal 2
  it 'the number of trips starting at A and ending at C with exactly 4 stops is 3', ->
    app.findRouteWithExactStops(graph, "A", "C", 4).length.should.equal 3
  it 'the shortest route between A and C in term of distance is 9', ->
    app.findShortestRoute(graph, "A", "C").distance.should.equal 9
  it 'the shortest route between B and B in term of distance is 9', ->
    app.findShortestRoute(graph, "B", "B").distance.should.equal 9
  it 'the number of routes between C and C with a distance under 30 is 7', ->
    app.findRoutesWithinDistance(graph, "C", "C", 30).length.should.equal 7
