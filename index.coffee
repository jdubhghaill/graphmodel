fs = require('fs');

#models a node in the graph and contains it connections to other nodes
class GraphNode
	constructor: (@name) ->
		@destinations = {}

  #adds a new node to this nodes connections
	addDestination: (destination, distance) ->
		throw new Error("A route to destination #{destination.name} already exists") if @destinations.hasOwnProperty(destination.name)
		@destinations[destination.name] = {node: destination, distance: distance}

	#follow a route based on a string array of directions and return the distance travelled
	travelRoute: (directions) ->
		if directions.length == 1
			return 0
		directions = directions[1..]
		throw new Error("There is no route from #{@name} to #{directions[0]}") if not @destinations.hasOwnProperty(directions[0])
		distance = @destinations[directions[0]].distance
		distance += @destinations[directions[0]].node.travelRoute(directions)

  #find a route to a given key without going over the maximum stops. Returns all routes matching as an array of arrays
	findRouteWithMaxStops: (to, currentStops, maxStops, route) ->
		return null if currentStops > maxStops
		routeCopy = route[..]
		routeCopy.push @name
		routes = []
		routes.push(routeCopy) if @name == to and currentStops != 0
		currentStops += 1

		for key, value of @destinations
			possibleRoutes = value.node.findRouteWithMaxStops to, currentStops, maxStops, routeCopy
			if possibleRoutes?
				Array::push.apply routes, possibleRoutes

		routes

	#find the number of routes between 2 points with an exact number of sports
	findRouteWithExactStops: (to, currentStops, exactStops, route) ->
		return null if currentStops > exactStops
		routeCopy = route[..]
		routeCopy.push @name
		routes = []
		routes.push(routeCopy) if @name == to and currentStops != 0 and currentStops == exactStops
		currentStops += 1

		for key, value of @destinations
			possibleRoutes = value.node.findRouteWithExactStops to, currentStops, exactStops, routeCopy
			if possibleRoutes?
				Array::push.apply routes, possibleRoutes

		routes

  #Find the shortest route to a node using a priority queue
	findShortestRoute: (to) ->
		solution =
			route: [],
			distance: 0
		queue = [
			{route: [this],
			distance: 0}
		]

		#keep track of what nodes we have been to so we don't end up going in circles
		explored = []

		while queue.length > 0
			item = queue.shift()
			if solution.distance > 0 and item.distance > solution.distance
				break

			if item.route[item.route.length - 1].name == to and item.distance > 0 and (solution.distance == 0 or item.distance < solution.distance)
				solution.route = item.route
				solution.distance = item.distance

			#don't mark the first node as explored as we might be travelling to the same node
			if item.distance > 0
				explored.push item.route[item.route.length - 1].name

			for key, value of item.route[item.route.length - 1].destinations
				if value.node.name not in explored
					routeCopy = item.route[..]
					routeCopy.push value.node
					newItem =
						route: routeCopy,
						distance: item.distance + value.distance

					#add new item to queue, shortest distance first
					place = 0
					for queueItem, i in queue
						if newItem.distance <= queueItem.distance
							break
						if newItem.distance > queueItem.distance
							place += 1
					queue.splice(place, 0, newItem)

		solution

	#find all routes to a destination with a distance under maxDistance
	findRoutesWithinDistance: (to, maxDistance) ->
		solutions = []
		queue = [
			{route: [this],
			distance: 0}
		]

		while queue.length > 0
			item = queue.shift()
			if item.distance > maxDistance
				continue

			if item.route[item.route.length - 1].name == to and item.distance > 0 and item.distance < maxDistance
				solution =
					route: item.route,
					distance: item.distance
				solutions.push solution

			for key, value of item.route[item.route.length - 1].destinations
				routeCopy = item.route[..]
				routeCopy.push value.node
				newItem =
					route: routeCopy,
					distance: item.distance + value.distance

				queue.push(newItem)

		solutions


generateGraph = (graph, data) ->
	addToGraph graph, route for route in data

getGraphNode = (graph, key) ->
	if not graph.hasOwnProperty(key)
		graph[key] = new GraphNode key
	graph[key]

addToGraph = (graph, route) ->
	throw new Error("A route must contain at least three characters") if route.length < 3
	start = route.charAt(0)
	end = route.charAt(1)
	throw new Error("A route cannot start and end at the same node") if start == end
	distance = parseInt(route.slice(2, route.length))
	startNode = getGraphNode graph, start
	endNode = getGraphNode graph, end
	startNode.addDestination endNode, distance

routeDistance = (graph, directions) ->
	throw new Error("The node #{directions[0]} does not exist in this graph") if not graph.hasOwnProperty(directions[0])
	graph[directions[0]].travelRoute(directions)

findRouteWithMaxStops = (graph, from, to, maxStops) ->
	if not graph.hasOwnProperty(from)
		throw new Error("Cannot find node #{from} in graph")

	graph[from].findRouteWithMaxStops(to, 0, maxStops, [])

findRouteWithExactStops = (graph, from, to, exactStops) ->
	if not graph.hasOwnProperty(from)
		throw new Error("Cannot find node #{from} in graph")

	graph[from].findRouteWithExactStops(to, 0, exactStops, [])

findShortestRoute = (graph, from, to) ->
	if not graph.hasOwnProperty(from)
		throw new Error("Cannot find node #{from} in graph")
	graph[from].findShortestRoute(to)

findRoutesWithinDistance = (graph, from, to, maxDistance) ->
	if not graph.hasOwnProperty(from)
		throw new Error("Cannot find node #{from} in graph")
	graph[from].findRoutesWithinDistance(to, maxDistance)

# Module exports so the tests can access these functions
module.exports.generateGraph = generateGraph
module.exports.routeDistance = routeDistance
module.exports.findRouteWithMaxStops = findRouteWithMaxStops
module.exports.findRouteWithExactStops = findRouteWithExactStops
module.exports.findShortestRoute = findShortestRoute
module.exports.findRoutesWithinDistance = findRoutesWithinDistance


filepath = ""
command = ""
commandArgs = []
for val, index in process.argv
	parts = val.split("=")
	if parts.length == 2 and parts[0] == "file"
		filepath = parts[1]
	else
		switch val
			when "distance"
				command = "distance"
				commandArgs.push process.argv[index + 1].split(",")
			when "routemaxstops"
				command = "routemaxstops"
				commandArgs.push process.argv[index + 1]
				commandArgs.push process.argv[index + 2]
				commandArgs.push process.argv[index + 3]
			when "routeexactstops"
				command = "routeexactstops"
				commandArgs.push process.argv[index + 1]
				commandArgs.push process.argv[index + 2]
				commandArgs.push process.argv[index + 3]
			when "shortestroute"
				command = "shortestroute"
				commandArgs.push process.argv[index + 1]
				commandArgs.push process.argv[index + 2]
			when "routesindistance"
				command = "routesindistance"
				commandArgs.push process.argv[index + 1]
				commandArgs.push process.argv[index + 2]
				commandArgs.push process.argv[index + 3]

if filepath == ""
	console.log "No file provided. A file of comma separated graph data should be provided with the argument file={path to file}"
	return

console.log "Loading file #{filepath}"
fs.readFile(filepath, 'utf8',
	(err, data) ->
		if err?
	    return console.log err
		data = data.replace("\n", "").replace(/\s+/g, "").split(",")
		console.log "Generating graph from #{data}"
		graph = {}
		generateGraph graph, data

		switch command
			when "distance"
				console.log "Calculating distance for route #{commandArgs[0]}"
				try
					distance = routeDistance(graph, commandArgs[0])
					console.log "Distance is #{distance}"
				catch error
					console.log "Failed to calcuate distance with error #{error}"
			when "routemaxstops"
				console.log "Calculating the number of routes starting at #{commandArgs[0]} and ending at #{commandArgs[1]} with a maximum of #{commandArgs[2]} stops"
				try
					routes = findRouteWithMaxStops(graph, commandArgs[0], commandArgs[1], parseInt(commandArgs[2]))
					console.log "Found #{routes.length} routes: "
					console.log route for route in routes
				catch error
					console.log "Failed to calcuate routes with error: #{error}"
			when "routeexactstops"
				console.log "Calculating the number of routes starting at #{commandArgs[0]} and ending at #{commandArgs[1]} with exactly #{commandArgs[2]} stops"
				try
					routes = findRouteWithExactStops(graph, commandArgs[0], commandArgs[1], parseInt(commandArgs[2]))
					console.log "Found #{routes.length} routes: "
					console.log route for route in routes
				catch error
					console.log "Failed to calcuate routes with error: #{error}"
			when "shortestroute"
				console.log "Calculating the shortest route between #{commandArgs[0]} and #{commandArgs[1]}"
				try
					solution = findShortestRoute(graph, commandArgs[0], commandArgs[1])
					console.log "The shortest route has a distance of #{solution.distance} and is"
					console.log node.name for node in solution.route
				catch
					console.log "Failed to calcuate route with error: #{error}"
			when "routesindistance"
				console.log "Finding all routes between #{commandArgs[0]} and #{commandArgs[1]} with a distance less than #{commandArgs[2]}"
				try
					solutions = findRoutesWithinDistance(graph, commandArgs[0], commandArgs[1], parseInt(commandArgs[2]))
					console.log "Found #{solutions.length} routes: "
					for solution in solutions
						route = []
						for node in solution.route
							route.push node.name
						console.log route
				catch
					console.log "Failed to calcuate routes with error: #{error}"
			else
				console.log "No command given. Possible commands are: \n
				distance {a list of comma seperated nodes} \n
				routemaxstops {starting node} {ending node} {maximum stops} \n
				routeexactstops {starting node} {ending node} {number of stops} \n
				shortestroute {starting node} {ending node} \n
				routesindistance {starting node} {ending node} {distance} \n"
)
