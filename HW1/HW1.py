# weighted adjacency list
map = {
    "arad": [("zerind", 75), ("sibiu", 140), ("timisoara", 118)],
    "zerind": [("arad", 75), ("oradea", 71)],
    "oradea": [("zerind", 71), ("sibiu", 151)],
    "sibiu": [("arad", 140), ("oradea", 151), ("fagaras", 99), ("rimnicu_vilcea", 80)],
    "timisoara": [("arad", 118), ("lugoj", 111)],
    "lugoj": [("timisoara", 111), ("mehadia", 70)],
    "mehadia": [("lugoj", 70), ("drobeta", 75)],
    "drobeta": [("mehadia", 75), ("craiova", 120)],
    "craiova": [("drobeta", 120), ("rimnicu_vilcea", 146), ("pitesti", 138)],
    "rimnicu_vilcea": [("sibiu", 80), ("craiova", 146), ("pitesti", 97)],
    "fagaras": [("sibiu", 99), ("bucharest", 211)],
    "pitesti": [("rimnicu_vilcea", 97), ("craiova", 138), ("bucharest", 101)],
    "bucharest": [("fagaras", 211), ("pitesti", 101), ("giurgiu", 90), ("urziceni", 85)],
    "giurgiu": [("bucharest", 90)],
    "urziceni": [("bucharest", 85), ("hirsova", 98), ("vaslui", 142)],
    "hirsova": [("urziceni", 98), ("eforie", 86)],
    "eforie": [("hirsova", 86)],
    "vaslui": [("urziceni", 142), ("iasi", 92)],
    "iasi": [("vaslui", 92), ("neamt", 87)],
    "neamt": [("iasi", 87)]
}


# straight line distance heuristic to bucharest
distanceToBucharest = {
    "arad": 366, "bucharest": 0, "craiova": 160, "drobeta": 242,
    "eforie": 161, "fagaras": 176, "giurgiu": 77, "hirsova": 151,
    "iasi": 226, "lugoj": 244, "mehadia": 241, "neamt": 234,
    "oradea": 380, "pitesti": 100, "rimnicu_vilcea": 193,
    "sibiu": 253, "timisoara": 329, "urziceni": 80,
    "vaslui": 199, "zerind": 374
}


# build path function
def buildPath(parentMap, startCity, goalCity):
    path = []
    currentCity = goalCity

    # traverse backward from goal to start
    while currentCity is not None:
        path.append(currentCity)
        currentCity = parentMap[currentCity]

    # reverse so path goes from start to goal
    path.reverse()

    # Make sure the path is valid
    if path and path[0] == startCity:
        return path

    return []


# breadth first search algorithm
from collections import deque

def BreadthFirstSearch(startCity, goalCity):
    fringe = deque([startCity])

    # parent pointers for path reconstruction
    parent = {startCity: None}

    visited = {startCity}

    nodesExpanded = 0

    while fringe:
        current = fringe.popleft()
        nodesExpanded += 1

        # goal test when node is removed from front
        if current == goalCity:
            path = buildPath(parent, startCity, goalCity)
            return path, (len(path) - 1), nodesExpanded

        # add all children to the BACK of the queue
        for neighbor, _dist in map[current]:
            if neighbor not in visited:
                visited.add(neighbor)
                parent[neighbor] = current
                fringe.append(neighbor)

    return [], float("inf"), nodesExpanded


# depth first search algorithm
def DepthFirstSearch(startCity, goalCity):
    stack = [startCity]
    # map final path
    parent = {startCity: None}
    
    # prevent looping to previous cities
    visited = {startCity}
    
    # performance counter
    nodesExpanded = 0

    # continue until no cities left
    while stack:
        # expand newest added city
        current = stack.pop()
        nodesExpanded += 1

        # check if goal found
        if current == goalCity:
            path = buildPath(parent, startCity, goalCity)
            return path, (len(path) - 1), nodesExpanded
        
        # check neigboring cities
        for neighbor, _ in map[current]:
            if neighbor not in visited:
                visited.add(neighbor)
                parent[neighbor] = current
                stack.append(neighbor)

    # handle infinite loop case
    return [], float("inf"), nodesExpanded


# greedy best first search algorithm
def GreedyBestFirstSearch(startCity, goalCity):
    # view all available cities with heuristic
    openList = [(startCity, distanceToBucharest[startCity])]

    # keep track of final path
    parent = {startCity: None}

    # prevent looping to previous cities
    visited = {startCity}

    # track performance
    nodesExpanded = 0

    while openList:
        # sort by lowest heuristic value
        openList.sort(key=lambda x: x[1])
        current, _ = openList.pop(0)
        nodesExpanded += 1

        # check if goal city is found
        if current == goalCity:
            path = buildPath(parent, startCity, goalCity)
            return path, (len(path) - 1), nodesExpanded

        # check for next city to expand
        for neighbor, _ in map[current]:
            if neighbor not in visited:
                visited.add(neighbor)
                parent[neighbor] = current
                openList.append((neighbor, distanceToBucharest[neighbor]))
    
    # handle infinite loop case
    return [], float("inf"), nodesExpanded



def AStarToBucharest(startCity):
    goalCity = "bucharest"

    # each entry is city, distance traveled so far, estimated distance to bucharest
    openList = [(startCity, 0, distanceToBucharest[startCity])]

    # track parents and best known costs
    parent = {startCity: None}
    costFromStart = {startCity: 0}

    # performance counter
    nodesExpanded = 0

    while openList:

        # select city with smallest f = g + h
        openList.sort(key=lambda entry: entry[1] + entry[2])
        current, currentCost, _ = openList.pop(0)
        nodesExpanded += 1

        # goal test
        if current == goalCity:
            path = buildPath(parent, startCity, goalCity)
            return path, costFromStart[goalCity], nodesExpanded

        # explore neighbors
        for neighbor, distance in map[current]:
            newCost = currentCost + distance

            # update if a shorter path is found
            if neighbor not in costFromStart or newCost < costFromStart[neighbor]:
                costFromStart[neighbor] = newCost
                parent[neighbor] = current
                openList.append(
                    (neighbor, newCost, distanceToBucharest[neighbor])
                )

    # return if bucharest cant be reached
    return [], float("inf"), nodesExpanded


# main function
def main():
    distances = {}
    paths = {}
    expansions = {}

    for city in map:
        if city == "bucharest":
            distances[city] = 0
            paths[city] = ["bucharest"]
            expansions[city] = 0
        else:
            path, cost, expanded = AStarToBucharest(city)
            distances[city] = cost
            paths[city] = path
            expansions[city] = expanded

    return distances, paths, expansions


# test breadth first search
print("BFS Arad -> Bucharest TEST:")
path, hops, expanded = BreadthFirstSearch("arad", "bucharest")
print("path:", path)
print("hops:", hops)
print("nodesExpanded:", expanded)
print()


# test depth first search algorithm
print("DFS Arad -> Bucharest TEST:")
path, hops, expanded = DepthFirstSearch("arad", "bucharest")
print("path:", path)
print("hops:", hops)
print("nodesExpanded:", expanded)
print()


# test greedy best first search algorithm
print("Greedy Arad -> Bucharest TEST:")
path, hops, expanded = GreedyBestFirstSearch("arad", "bucharest")
print("path:", path)
print("hops:", hops)
print("nodesExpanded:", expanded)
print()


# test main function
print("A* shortest distance from each city to 'bucharest' TEST:")
distances, paths, expansions = main()
print("distances:", distances)
print("\n")