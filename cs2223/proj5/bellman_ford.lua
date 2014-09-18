--Tushar Narayan
--tnarayan@wpi.edu
--Project 5 Part 2

require "util"
require "graphs"

-- bellman_ford(g,s):
-- Execute the bellman-ford algorithm on
-- graph g
-- start node (integer) s.

-- returns either FALSE or else two tables:
-- d, which, for each node n accessible from s gives its distance
-- pi, which gives the predecessor to n on a shortest route from s

-- False means that the graph has a negative cost cycle.

-- Assumes that g is a graph, i.e. a table with a length field giving
-- the number of nodes, and containing an array of this length.
-- The value of g[u] for any u up to the length is an array
-- of edges.  Each edge e has
-- a *destination* field e.dst	 and
-- a *cost* field	 e.cost

-- You can work directly from the pseudocode at CLRS pages 651 and
-- 649.

function bellman_ford (g,s)
	-- this array will contain distances from s to nodes at end
	local d = {}

	-- this array will contain the predecessor along a shortest path
	local pi = {}

	--relaxation function
	local function relax(j, k)
		d[g[j][k]["dst"]] = d[j] + g[j][k]["cost"] --update cost to reflect more efficient path
		d[g[j][k]["dst"]] = math.floor(d[g[j][k]["dst"]]) 	--round down to remove the decimal
															--part of the number that may be left
															--over from assigning value as math.huge
		pi[g[j][k]["dst"]] = j --current node will be new destination
	end

	--initialize single-source
	for i = 1, #g	do
		d[i] = math.huge	--start out by setting all distances to infinity
							--so that the algorithm finds shorter distances
							--between nodes
		pi[i] = nil --all parents are initially nil
	end

	d[s] = 0 --starting node has a distance of 0 from itself

	-- At this point:
	--	pi for all nodes = nil
	-- d for s = 0
	-- d for all other nodes = infinity
	-- g = graph
	-- s = source node
	-- g[i] = array of edges reachable from that node
	-- n = number of nodes = #g

	--call relaxation function as needed
	for i = 1, #g - 1 do
		for j = 1, #g do
			for k = 1, #g[j] do
				--Relax edge iff (current.dist + current.cost) < dest.dist
				if(d[g[j][k]["dst"]] == nil) or (d[j] == nil) then
					if(d[j] ~= nil) then
						relax(j, k)
					end
				elseif(d[g[j][k]["dst"]] > (d[j] + g[j][k]["cost"])) then
					relax(j, k)
				end
			end
		end
	end

	--are there any negative-weight cycles reachable from source?
	for i = 1, #g do
		for j = 1, #g[i] do
			if(d[g[i][j]["dst"]] > (d[i] + g[i][j]["cost"])) then
				return false --found negative cycle, return false
			--[[
			all cases taken care of. in case of disconnected node,
			nothing is required to be done.
			--]]
			end
		end
	end

	return d, pi
end

-- print the shortest path computed using Bellman-Ford:
-- return false (and print appropriate message) if there is no path
function a_shortest_path(g,s,t,pi)
	--g = graph
	--s = source node
	--t = destination node
	--pi = table to parents computed using Bellman Ford

	--array to save the path travelled from source to destination
	local path_travelled = {}

	--insert starting node into array
	table.insert(path_travelled, t)

	--variable for the node being currently inspected
	local at_node = t

	while at_node ~= s do --we loop till source s and destination t refer to the same node
		at_node = pi[at_node]
		if (at_node == nil) then
			print("There is no existing path in between these nodes.")
			return false
		end
		table.insert(path_travelled, at_node)
	end

	--print the path in actual order of travel
	--path_travelled contains nodes in reverse order of travel
	--as per Bellman Ford
	local first_node = #path_travelled
	for i = first_node, 1, -1 do
		io.write(path_travelled[i])
		if(i ~= 1) then io.write(" -> ") end
	end
	print()
	return path_travelled --yes, we're both printing and returning the shortest path.
end

--function to test both bellman_ford() and a_shortest_path():
function test_bf(choice, nodes, density, weight_center, range, source_node, dest_node1, dest_node2, dest_node3, dest_node4, dest_node5)

	--test a directed graph with given inputs
	local function test_dg(nodes, density, weight_center, range, source_node, dest_node1, dest_node2, dest_node3, dest_node4, dest_node5)
		rand_graph = graphs.random(nodes, density, weight_center, range)
		print("The directed graph being tested is:")
		graphs.print_graph(rand_graph)
		d, pi = bellman_ford(rand_graph, source_node)
		print("\nThe table of distances of nodes from node ", source_node, " using Bellman Ford is:")
		util.print_table(d)
		print("\nThe table of predecessors of nodes using Bellman Ford is:")
		util.print_table(pi)
		print("\nThe shortest path between source node ", source_node, " and destination node ", dest_node1, " is:")
		a_shortest_path(rand_graph, source_node, dest_node1, pi)
		print("\nThe shortest path between source node ", source_node, " and destination node ", dest_node2, " is:")
		a_shortest_path(rand_graph, source_node, dest_node2, pi)
		print("\nThe shortest path between source node ", source_node, " and destination node ", dest_node3, " is:")
		a_shortest_path(rand_graph, source_node, dest_node3, pi)
		print("\nThe shortest path between source node ", source_node, " and destination node ", dest_node4, " is:")
		a_shortest_path(rand_graph, source_node, dest_node4, pi)
		print("\nThe shortest path between source node ", source_node, " and destination node ", dest_node5, " is:")
		a_shortest_path(rand_graph, source_node, dest_node5, pi)
	end

	--test an undirected graph with given inputs
	local function test_ug(nodes, density, weight_center, range, source_node, dest_node1, dest_node2, dest_node3, dest_node4, dest_node5)
		rand_graph = graphs.random_undirected(nodes, density, weight_center, range)
		print("The undirected graph being tested is:")
		graphs.print_graph(rand_graph)
		d, pi = bellman_ford(rand_graph, source_node)
		print("\nThe table of distances of nodes from node ", source_node, " using Bellman Ford is:")
		util.print_table(d)
		print("\nThe table of predecessors of nodes using Bellman Ford is:")
		util.print_table(pi)
		print("\nThe shortest path between source node ", source_node, " and destination node ", dest_node1, " is:")
		a_shortest_path(rand_graph, source_node, dest_node1, pi)
		print("\nThe shortest path between source node ", source_node, " and destination node ", dest_node2, " is:")
		a_shortest_path(rand_graph, source_node, dest_node2, pi)
		print("\nThe shortest path between source node ", source_node, " and destination node ", dest_node3, " is:")
		a_shortest_path(rand_graph, source_node, dest_node3, pi)
		print("\nThe shortest path between source node ", source_node, " and destination node ", dest_node4, " is:")
		a_shortest_path(rand_graph, source_node, dest_node4, pi)
		print("\nThe shortest path between source node ", source_node, " and destination node ", dest_node5, " is:")
		a_shortest_path(rand_graph, source_node, dest_node5, pi)
	end

	if (choice == 1) then
		test_dg(nodes, density, weight_center, range, source_node, dest_node1, dest_node2, dest_node3, dest_node4, dest_node5)
	elseif (choice == 2) then
		test_ug(nodes, density, weight_center, range, source_node, dest_node1, dest_node2, dest_node3, dest_node4, dest_node5)
	else
		print("The first argument (choice) has to be either 1 (directed graph) or 2 (undirected graph). Please try again.")
	end
	--tests:
	--(1, 15, .2, 12, 24, 2, 10, 1, 12, 3, 7)
	--(1, 25, 1, 15, 30, 2, 10, 4, 20, 14, 25)
	--(2, 25, 1, 15, 30, 2, 10, 4, 20, 14, 25)
end

--[[Sample Test Runs:
Test Run 1:
Commands used to test:
1) load file using -> require "bellman_ford"
2) run test wrapper using -> test_bf(1, 15, .2, 12, 24, 2, 10, 1, 12, 3, 7)

Output:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "bellman_ford"
> test_bf(1, 15, .2, 12, 24, 2, 10, 1, 12, 3, 7)
The directed graph being tested is:

{
  [1] = { {dst = 9, cost = 13}, {dst = 11, cost = 3}, {dst = 14, cost = 17}, },
  [2] = { {dst = 4, cost = 19}, },
  [3] = { {dst = 1, cost = 2}, {dst = 6, cost = 23}, },
  [4] = { {dst = 12, cost = 21}, {dst = 13, cost = 3}, },
  [5] = { {dst = 4, cost = 9}, {dst = 8, cost = 2}, {dst = 11, cost = 18}, {dst
= 13, cost = 8}, {dst = 14, cost = 6}, },
  [6] = { {dst = 4, cost = 6}, {dst = 7, cost = 16}, },
  [7] = { {dst = 2, cost = 12}, {dst = 9, cost = 10}, {dst = 15, cost = 5}, },
  [8] = { {dst = 3, cost = 10}, {dst = 5, cost = 6}, {dst = 6, cost = 6}, {dst =
 7, cost = 21}, {dst = 9, cost = 16}, {dst = 11, cost = 21}, },
  [9] = { {dst = 4, cost = 1}, {dst = 10, cost = 6}, {dst = 12, cost = 7}, {dst
= 15, cost = 9}, },
  [10] = { {dst = 2, cost = 7}, {dst = 4, cost = 21}, {dst = 5, cost = 2}, {dst
= 8, cost = 5}, {dst = 11, cost = 7}, },
  [11] = { {dst = 2, cost = 22}, {dst = 3, cost = 12}, {dst = 6, cost = 5}, {dst
 = 13, cost = 2}, },
  [12] = { {dst = 1, cost = 0}, {dst = 4, cost = 13}, },
  [13] = { {dst = 6, cost = 3}, {dst = 7, cost = 4}, },
  [14] = { {dst = 7, cost = 22}, {dst = 8, cost = 8}, {dst = 13, cost = 23}, },
  [15] = { {dst = 2, cost = 23}, {dst = 4, cost = 4}, {dst = 8, cost = 13}, {dst
 = 9, cost = 19}, {dst = 10, cost = 10}, {dst = 11, cost = 17}, },
  length = 15
}

The table of distances of nodes from node       2        using Bellman Ford is:
1       ,       40
2       ,       0
3       ,       54
4       ,       19
5       ,       43
6       ,       25
7       ,       26
8       ,       44
9       ,       36
10      ,       41
11      ,       43
12      ,       40
13      ,       22
14      ,       49
15      ,       31

The table of predecessors of nodes using Bellman Ford is:
1       ,       12
3       ,       8
4       ,       2
5       ,       10
6       ,       13
7       ,       13
8       ,       15
9       ,       7
10      ,       15
11      ,       1
12      ,       4
13      ,       4
14      ,       5
15      ,       7

The shortest path between source node   2        and destination node   10
 is:
2 -> 4 -> 13 -> 7 -> 15 -> 10

The shortest path between source node   2        and destination node   1
 is:
2 -> 4 -> 12 -> 1

The shortest path between source node   2        and destination node   12
 is:
2 -> 4 -> 12

The shortest path between source node   2        and destination node   3
 is:
2 -> 4 -> 13 -> 7 -> 15 -> 8 -> 3

The shortest path between source node   2        and destination node   7
 is:
2 -> 4 -> 13 -> 7


Test Run 2:
Commands used to test:
1) load file using -> require "bellman_ford"
2) run test wrapper using -> test_bf(1, 25, 1, 15, 30, 2, 10, 4, 20, 14, 25)

Output:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "bellman_ford"
> test_bf(1, 25, 1, 15, 30, 2, 10, 4, 20, 14, 25)
The directed graph being tested is:

{
  [1] = { {dst = 2, cost = 16}, {dst = 3, cost = 11}, {dst = 4, cost = 2}, {dst
= 5, cost = 23}, {dst = 6, cost = 17}, {dst = 7, cost = 5}, {dst = 8, cost = 14}
, {dst = 9, cost = 3}, {dst = 10, cost = 23}, {dst = 11, cost = 7}, {dst = 12, c
ost = 28}, {dst = 13, cost = 23}, {dst = 14, cost = 22}, {dst = 15, cost = 7}, {
dst = 16, cost = 15}, {dst = 17, cost = 18}, {dst = 18, cost = 19}, {dst = 19, c
ost = 17}, {dst = 20, cost = 19}, {dst = 21, cost = 4}, {dst = 22, cost = 8}, {d
st = 23, cost = 2}, {dst = 24, cost = 20}, {dst = 25, cost = 6}, },
  [2] = { {dst = 1, cost = 11}, {dst = 3, cost = 1}, {dst = 4, cost = 8}, {dst =
 5, cost = 15}, {dst = 6, cost = 20}, {dst = 7, cost = 11}, {dst = 8, cost = 18}
, {dst = 9, cost = 23}, {dst = 10, cost = 6}, {dst = 11, cost = 22}, {dst = 12,
cost = 8}, {dst = 13, cost = 28}, {dst = 14, cost = 20}, {dst = 15, cost = 2}, {
dst = 16, cost = 7}, {dst = 17, cost = 12}, {dst = 18, cost = 12}, {dst = 19, co
st = 2}, {dst = 20, cost = 25}, {dst = 21, cost = 15}, {dst = 22, cost = 22}, {d
st = 23, cost = 11}, {dst = 24, cost = 19}, {dst = 25, cost = 4}, },
  [3] = { {dst = 1, cost = 17}, {dst = 2, cost = 6}, {dst = 4, cost = 10}, {dst
= 5, cost = 6}, {dst = 6, cost = 8}, {dst = 7, cost = 5}, {dst = 8, cost = 3}, {
dst = 9, cost = 6}, {dst = 10, cost = 29}, {dst = 11, cost = 15}, {dst = 12, cos
t = 12}, {dst = 13, cost = 19}, {dst = 14, cost = 16}, {dst = 15, cost = 14}, {d
st = 16, cost = 9}, {dst = 17, cost = 20}, {dst = 18, cost = 7}, {dst = 19, cost
 = 25}, {dst = 20, cost = 24}, {dst = 21, cost = 19}, {dst = 22, cost = 18}, {ds
t = 23, cost = 15}, {dst = 24, cost = 6}, {dst = 25, cost = 23}, },
  [4] = { {dst = 1, cost = 11}, {dst = 2, cost = 4}, {dst = 3, cost = 21}, {dst
= 5, cost = 15}, {dst = 6, cost = 11}, {dst = 7, cost = 25}, {dst = 8, cost = 14
}, {dst = 9, cost = 16}, {dst = 10, cost = 3}, {dst = 11, cost = 14}, {dst = 12,
 cost = 4}, {dst = 13, cost = 24}, {dst = 14, cost = 6}, {dst = 15, cost = 13},
{dst = 16, cost = 17}, {dst = 17, cost = 4}, {dst = 18, cost = 9}, {dst = 19, co
st = 29}, {dst = 20, cost = 9}, {dst = 21, cost = 23}, {dst = 22, cost = 4}, {ds
t = 23, cost = 19}, {dst = 24, cost = 16}, {dst = 25, cost = 11}, },
  [5] = { {dst = 1, cost = 25}, {dst = 2, cost = 4}, {dst = 3, cost = 11}, {dst
= 4, cost = 5}, {dst = 6, cost = 28}, {dst = 7, cost = 16}, {dst = 8, cost = 7},
 {dst = 9, cost = 20}, {dst = 10, cost = 22}, {dst = 11, cost = 12}, {dst = 12,
cost = 15}, {dst = 13, cost = 8}, {dst = 14, cost = 2}, {dst = 15, cost = 19}, {
dst = 16, cost = 20}, {dst = 17, cost = 28}, {dst = 18, cost = 12}, {dst = 19, c
ost = 15}, {dst = 20, cost = 25}, {dst = 21, cost = 11}, {dst = 22, cost = 22},
{dst = 23, cost = 9}, {dst = 24, cost = 8}, {dst = 25, cost = 12}, },
  [6] = { {dst = 1, cost = 25}, {dst = 2, cost = 25}, {dst = 3, cost = 9}, {dst
= 4, cost = 3}, {dst = 5, cost = 22}, {dst = 7, cost = 27}, {dst = 8, cost = 1},
 {dst = 9, cost = 29}, {dst = 10, cost = 0}, {dst = 11, cost = 25}, {dst = 12, c
ost = 25}, {dst = 13, cost = 19}, {dst = 14, cost = 8}, {dst = 15, cost = 10}, {
dst = 16, cost = 6}, {dst = 17, cost = 2}, {dst = 18, cost = 12}, {dst = 19, cos
t = 5}, {dst = 20, cost = 26}, {dst = 21, cost = 9}, {dst = 22, cost = 11}, {dst
 = 23, cost = 5}, {dst = 24, cost = 8}, {dst = 25, cost = 4}, },
  [7] = { {dst = 1, cost = 17}, {dst = 2, cost = 16}, {dst = 3, cost = 24}, {dst
 = 4, cost = 11}, {dst = 5, cost = 3}, {dst = 6, cost = 22}, {dst = 8, cost = 29
}, {dst = 9, cost = 14}, {dst = 10, cost = 12}, {dst = 11, cost = 23}, {dst = 12
, cost = 13}, {dst = 13, cost = 26}, {dst = 14, cost = 11}, {dst = 15, cost = 22
}, {dst = 16, cost = 6}, {dst = 17, cost = 7}, {dst = 18, cost = 11}, {dst = 19,
 cost = 19}, {dst = 20, cost = 9}, {dst = 21, cost = 3}, {dst = 22, cost = 10},
{dst = 23, cost = 20}, {dst = 24, cost = 24}, {dst = 25, cost = 8}, },
  [8] = { {dst = 1, cost = 7}, {dst = 2, cost = 25}, {dst = 3, cost = 7}, {dst =
 4, cost = 2}, {dst = 5, cost = 9}, {dst = 6, cost = 16}, {dst = 7, cost = 15},
{dst = 9, cost = 4}, {dst = 10, cost = 28}, {dst = 11, cost = 18}, {dst = 12, co
st = 15}, {dst = 13, cost = 12}, {dst = 14, cost = 27}, {dst = 15, cost = 9}, {d
st = 16, cost = 12}, {dst = 17, cost = 3}, {dst = 18, cost = 5}, {dst = 19, cost
 = 26}, {dst = 20, cost = 18}, {dst = 21, cost = 9}, {dst = 22, cost = 7}, {dst
= 23, cost = 24}, {dst = 24, cost = 22}, {dst = 25, cost = 29}, },
  [9] = { {dst = 1, cost = 17}, {dst = 2, cost = 28}, {dst = 3, cost = 17}, {dst
 = 4, cost = 19}, {dst = 5, cost = 5}, {dst = 6, cost = 13}, {dst = 7, cost = 6}
, {dst = 8, cost = 20}, {dst = 10, cost = 2}, {dst = 11, cost = 29}, {dst = 12,
cost = 13}, {dst = 13, cost = 26}, {dst = 14, cost = 29}, {dst = 15, cost = 3},
{dst = 16, cost = 5}, {dst = 17, cost = 3}, {dst = 18, cost = 6}, {dst = 19, cos
t = 23}, {dst = 20, cost = 22}, {dst = 21, cost = 4}, {dst = 22, cost = 3}, {dst
 = 23, cost = 7}, {dst = 24, cost = 9}, {dst = 25, cost = 14}, },
  [10] = { {dst = 1, cost = 9}, {dst = 2, cost = 23}, {dst = 3, cost = 13}, {dst
 = 4, cost = 4}, {dst = 5, cost = 17}, {dst = 6, cost = 24}, {dst = 7, cost = 3}
, {dst = 8, cost = 6}, {dst = 9, cost = 13}, {dst = 11, cost = 20}, {dst = 12, c
ost = 8}, {dst = 13, cost = 25}, {dst = 14, cost = 13}, {dst = 15, cost = 2}, {d
st = 16, cost = 9}, {dst = 17, cost = 11}, {dst = 18, cost = 29}, {dst = 19, cos
t = 11}, {dst = 20, cost = 12}, {dst = 21, cost = 25}, {dst = 22, cost = 6}, {ds
t = 23, cost = 14}, {dst = 24, cost = 15}, {dst = 25, cost = 25}, },
  [11] = { {dst = 1, cost = 2}, {dst = 2, cost = 19}, {dst = 3, cost = 6}, {dst
= 4, cost = 16}, {dst = 5, cost = 0}, {dst = 6, cost = 16}, {dst = 7, cost = 29}
, {dst = 8, cost = 19}, {dst = 9, cost = 12}, {dst = 10, cost = 11}, {dst = 12,
cost = 11}, {dst = 13, cost = 0}, {dst = 14, cost = 7}, {dst = 15, cost = 14}, {
dst = 16, cost = 5}, {dst = 17, cost = 3}, {dst = 18, cost = 24}, {dst = 19, cos
t = 11}, {dst = 20, cost = 12}, {dst = 21, cost = 13}, {dst = 22, cost = 0}, {ds
t = 23, cost = 8}, {dst = 24, cost = 10}, {dst = 25, cost = 15}, },
  [12] = { {dst = 1, cost = 16}, {dst = 2, cost = 16}, {dst = 3, cost = 22}, {ds
t = 4, cost = 25}, {dst = 5, cost = 25}, {dst = 6, cost = 17}, {dst = 7, cost =
11}, {dst = 8, cost = 28}, {dst = 9, cost = 17}, {dst = 10, cost = 21}, {dst = 1
1, cost = 6}, {dst = 13, cost = 18}, {dst = 14, cost = 11}, {dst = 15, cost = 3}
, {dst = 16, cost = 9}, {dst = 17, cost = 16}, {dst = 18, cost = 0}, {dst = 19,
cost = 6}, {dst = 20, cost = 19}, {dst = 21, cost = 26}, {dst = 22, cost = 17},
{dst = 23, cost = 29}, {dst = 24, cost = 18}, {dst = 25, cost = 22}, },
  [13] = { {dst = 1, cost = 19}, {dst = 2, cost = 19}, {dst = 3, cost = 27}, {ds
t = 4, cost = 25}, {dst = 5, cost = 14}, {dst = 6, cost = 22}, {dst = 7, cost =
12}, {dst = 8, cost = 21}, {dst = 9, cost = 22}, {dst = 10, cost = 16}, {dst = 1
1, cost = 19}, {dst = 12, cost = 10}, {dst = 14, cost = 3}, {dst = 15, cost = 1}
, {dst = 16, cost = 17}, {dst = 17, cost = 10}, {dst = 18, cost = 19}, {dst = 19
, cost = 23}, {dst = 20, cost = 12}, {dst = 21, cost = 8}, {dst = 22, cost = 0},
 {dst = 23, cost = 5}, {dst = 24, cost = 8}, {dst = 25, cost = 19}, },
  [14] = { {dst = 1, cost = 7}, {dst = 2, cost = 12}, {dst = 3, cost = 19}, {dst
 = 4, cost = 5}, {dst = 5, cost = 22}, {dst = 6, cost = 18}, {dst = 7, cost = 13
}, {dst = 8, cost = 21}, {dst = 9, cost = 3}, {dst = 10, cost = 7}, {dst = 11, c
ost = 15}, {dst = 12, cost = 18}, {dst = 13, cost = 19}, {dst = 15, cost = 16},
{dst = 16, cost = 21}, {dst = 17, cost = 23}, {dst = 18, cost = 11}, {dst = 19,
cost = 0}, {dst = 20, cost = 21}, {dst = 21, cost = 12}, {dst = 22, cost = 26},
{dst = 23, cost = 18}, {dst = 24, cost = 29}, {dst = 25, cost = 22}, },
  [15] = { {dst = 1, cost = 0}, {dst = 2, cost = 0}, {dst = 3, cost = 4}, {dst =
 4, cost = 11}, {dst = 5, cost = 0}, {dst = 6, cost = 21}, {dst = 7, cost = 9},
{dst = 8, cost = 27}, {dst = 9, cost = 14}, {dst = 10, cost = 7}, {dst = 11, cos
t = 7}, {dst = 12, cost = 20}, {dst = 13, cost = 13}, {dst = 14, cost = 10}, {ds
t = 16, cost = 14}, {dst = 17, cost = 29}, {dst = 18, cost = 8}, {dst = 19, cost
 = 27}, {dst = 20, cost = 20}, {dst = 21, cost = 15}, {dst = 22, cost = 22}, {ds
t = 23, cost = 8}, {dst = 24, cost = 21}, {dst = 25, cost = 9}, },
  [16] = { {dst = 1, cost = 24}, {dst = 2, cost = 20}, {dst = 3, cost = 6}, {dst
 = 4, cost = 16}, {dst = 5, cost = 28}, {dst = 6, cost = 11}, {dst = 7, cost = 6
}, {dst = 8, cost = 17}, {dst = 9, cost = 17}, {dst = 10, cost = 23}, {dst = 11,
 cost = 5}, {dst = 12, cost = 17}, {dst = 13, cost = 15}, {dst = 14, cost = 2},
{dst = 15, cost = 12}, {dst = 17, cost = 19}, {dst = 18, cost = 6}, {dst = 19, c
ost = 25}, {dst = 20, cost = 16}, {dst = 21, cost = 27}, {dst = 22, cost = 11},
{dst = 23, cost = 19}, {dst = 24, cost = 14}, {dst = 25, cost = 11}, },
  [17] = { {dst = 1, cost = 24}, {dst = 2, cost = 21}, {dst = 3, cost = 13}, {ds
t = 4, cost = 19}, {dst = 5, cost = 29}, {dst = 6, cost = 29}, {dst = 7, cost =
24}, {dst = 8, cost = 17}, {dst = 9, cost = 1}, {dst = 10, cost = 7}, {dst = 11,
 cost = 12}, {dst = 12, cost = 4}, {dst = 13, cost = 11}, {dst = 14, cost = 8},
{dst = 15, cost = 14}, {dst = 16, cost = 13}, {dst = 18, cost = 6}, {dst = 19, c
ost = 15}, {dst = 20, cost = 5}, {dst = 21, cost = 1}, {dst = 22, cost = 12}, {d
st = 23, cost = 28}, {dst = 24, cost = 22}, {dst = 25, cost = 0}, },
  [18] = { {dst = 1, cost = 16}, {dst = 2, cost = 5}, {dst = 3, cost = 16}, {dst
 = 4, cost = 2}, {dst = 5, cost = 6}, {dst = 6, cost = 8}, {dst = 7, cost = 16},
 {dst = 8, cost = 22}, {dst = 9, cost = 6}, {dst = 10, cost = 13}, {dst = 11, co
st = 28}, {dst = 12, cost = 15}, {dst = 13, cost = 10}, {dst = 14, cost = 20}, {
dst = 15, cost = 11}, {dst = 16, cost = 10}, {dst = 17, cost = 7}, {dst = 19, co
st = 16}, {dst = 20, cost = 20}, {dst = 21, cost = 10}, {dst = 22, cost = 13}, {
dst = 23, cost = 18}, {dst = 24, cost = 18}, {dst = 25, cost = 13}, },
  [19] = { {dst = 1, cost = 10}, {dst = 2, cost = 5}, {dst = 3, cost = 16}, {dst
 = 4, cost = 9}, {dst = 5, cost = 24}, {dst = 6, cost = 19}, {dst = 7, cost = 10
}, {dst = 8, cost = 4}, {dst = 9, cost = 1}, {dst = 10, cost = 27}, {dst = 11, c
ost = 20}, {dst = 12, cost = 21}, {dst = 13, cost = 24}, {dst = 14, cost = 1}, {
dst = 15, cost = 24}, {dst = 16, cost = 12}, {dst = 17, cost = 20}, {dst = 18, c
ost = 10}, {dst = 20, cost = 10}, {dst = 21, cost = 8}, {dst = 22, cost = 4}, {d
st = 23, cost = 14}, {dst = 24, cost = 1}, {dst = 25, cost = 9}, },
  [20] = { {dst = 1, cost = 4}, {dst = 2, cost = 28}, {dst = 3, cost = 14}, {dst
 = 4, cost = 28}, {dst = 5, cost = 4}, {dst = 6, cost = 28}, {dst = 7, cost = 6}
, {dst = 8, cost = 12}, {dst = 9, cost = 23}, {dst = 10, cost = 6}, {dst = 11, c
ost = 14}, {dst = 12, cost = 26}, {dst = 13, cost = 8}, {dst = 14, cost = 6}, {d
st = 15, cost = 22}, {dst = 16, cost = 26}, {dst = 17, cost = 14}, {dst = 18, co
st = 20}, {dst = 19, cost = 21}, {dst = 21, cost = 25}, {dst = 22, cost = 29}, {
dst = 23, cost = 5}, {dst = 24, cost = 17}, {dst = 25, cost = 3}, },
  [21] = { {dst = 1, cost = 15}, {dst = 2, cost = 2}, {dst = 3, cost = 20}, {dst
 = 4, cost = 21}, {dst = 5, cost = 5}, {dst = 6, cost = 29}, {dst = 7, cost = 11
}, {dst = 8, cost = 7}, {dst = 9, cost = 11}, {dst = 10, cost = 26}, {dst = 11,
cost = 6}, {dst = 12, cost = 25}, {dst = 13, cost = 27}, {dst = 14, cost = 17},
{dst = 15, cost = 26}, {dst = 16, cost = 29}, {dst = 17, cost = 25}, {dst = 18,
cost = 5}, {dst = 19, cost = 7}, {dst = 20, cost = 1}, {dst = 22, cost = 22}, {d
st = 23, cost = 8}, {dst = 24, cost = 24}, {dst = 25, cost = 10}, },
  [22] = { {dst = 1, cost = 0}, {dst = 2, cost = 9}, {dst = 3, cost = 1}, {dst =
 4, cost = 1}, {dst = 5, cost = 26}, {dst = 6, cost = 9}, {dst = 7, cost = 11},
{dst = 8, cost = 4}, {dst = 9, cost = 23}, {dst = 10, cost = 7}, {dst = 11, cost
 = 0}, {dst = 12, cost = 1}, {dst = 13, cost = 0}, {dst = 14, cost = 23}, {dst =
 15, cost = 24}, {dst = 16, cost = 13}, {dst = 17, cost = 27}, {dst = 18, cost =
 27}, {dst = 19, cost = 22}, {dst = 20, cost = 19}, {dst = 21, cost = 7}, {dst =
 23, cost = 19}, {dst = 24, cost = 28}, {dst = 25, cost = 8}, },
  [23] = { {dst = 1, cost = 16}, {dst = 2, cost = 27}, {dst = 3, cost = 26}, {ds
t = 4, cost = 13}, {dst = 5, cost = 0}, {dst = 6, cost = 2}, {dst = 7, cost = 8}
, {dst = 8, cost = 1}, {dst = 9, cost = 16}, {dst = 10, cost = 24}, {dst = 11, c
ost = 9}, {dst = 12, cost = 15}, {dst = 13, cost = 28}, {dst = 14, cost = 5}, {d
st = 15, cost = 0}, {dst = 16, cost = 2}, {dst = 17, cost = 11}, {dst = 18, cost
 = 10}, {dst = 19, cost = 20}, {dst = 20, cost = 15}, {dst = 21, cost = 28}, {ds
t = 22, cost = 11}, {dst = 24, cost = 2}, {dst = 25, cost = 0}, },
  [24] = { {dst = 1, cost = 25}, {dst = 2, cost = 2}, {dst = 3, cost = 28}, {dst
 = 4, cost = 15}, {dst = 5, cost = 11}, {dst = 6, cost = 0}, {dst = 7, cost = 25
}, {dst = 8, cost = 19}, {dst = 9, cost = 14}, {dst = 10, cost = 23}, {dst = 11,
 cost = 4}, {dst = 12, cost = 23}, {dst = 13, cost = 2}, {dst = 14, cost = 1}, {
dst = 15, cost = 9}, {dst = 16, cost = 22}, {dst = 17, cost = 0}, {dst = 18, cos
t = 11}, {dst = 19, cost = 26}, {dst = 20, cost = 28}, {dst = 21, cost = 4}, {ds
t = 22, cost = 1}, {dst = 23, cost = 19}, {dst = 25, cost = 14}, },
  [25] = { {dst = 1, cost = 2}, {dst = 2, cost = 12}, {dst = 3, cost = 1}, {dst
= 4, cost = 24}, {dst = 5, cost = 0}, {dst = 6, cost = 4}, {dst = 7, cost = 24},
 {dst = 8, cost = 25}, {dst = 9, cost = 29}, {dst = 10, cost = 28}, {dst = 11, c
ost = 19}, {dst = 12, cost = 17}, {dst = 13, cost = 22}, {dst = 14, cost = 2}, {
dst = 15, cost = 28}, {dst = 16, cost = 27}, {dst = 17, cost = 29}, {dst = 18, c
ost = 7}, {dst = 19, cost = 19}, {dst = 20, cost = 11}, {dst = 21, cost = 2}, {d
st = 22, cost = 1}, {dst = 23, cost = 4}, {dst = 24, cost = 15}, },
  length = 25
}

The table of distances of nodes from node       2        using Bellman Ford is:
1       ,       2
2       ,       0
3       ,       1
4       ,       4
5       ,       2
6       ,       3
7       ,       6
8       ,       4
9       ,       3
10      ,       3
11      ,       4
12      ,       5
13      ,       4
14      ,       3
15      ,       2
16      ,       6
17      ,       3
18      ,       5
19      ,       2
20      ,       5
21      ,       4
22      ,       4
23      ,       4
24      ,       3
25      ,       3

The table of predecessors of nodes using Bellman Ford is:
1       ,       15
3       ,       2
4       ,       1
5       ,       15
6       ,       24
7       ,       3
8       ,       3
9       ,       19
10      ,       6
11      ,       22
12      ,       22
13      ,       22
14      ,       19
15      ,       2
16      ,       23
17      ,       24
18      ,       12
19      ,       2
20      ,       21
21      ,       17
22      ,       24
23      ,       1
24      ,       19
25      ,       17

The shortest path between source node   2        and destination node   10
 is:
2 -> 19 -> 24 -> 6 -> 10

The shortest path between source node   2        and destination node   4
 is:
2 -> 15 -> 1 -> 4

The shortest path between source node   2        and destination node   20
 is:
2 -> 19 -> 24 -> 17 -> 21 -> 20

The shortest path between source node   2        and destination node   14
 is:
2 -> 19 -> 14

The shortest path between source node   2        and destination node   25
 is:
2 -> 19 -> 24 -> 17 -> 25

Test Run 3:
Commands used to test:
1) load file using -> require "bellman_ford"
2) run test wrapper using -> test_bf(2, 25, 1, 15, 30, 2, 10, 4, 20, 14, 25)

Output:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "bellman_ford"
> test_bf(2, 25, 1, 15, 30, 2, 10, 4, 20, 14, 25)
The undirected graph being tested is:

{
  [1] = { {dst = 2, cost = 21}, {dst = 3, cost = 25}, {dst = 4, cost = 15}, {dst
 = 5, cost = 24}, {dst = 6, cost = 9}, {dst = 7, cost = 10}, {dst = 8, cost = 10
}, {dst = 9, cost = 29}, {dst = 10, cost = 8}, {dst = 11, cost = 4}, {dst = 12,
cost = 17}, {dst = 13, cost = 3}, {dst = 14, cost = 5}, {dst = 15, cost = 25}, {
dst = 16, cost = 24}, {dst = 17, cost = 16}, {dst = 18, cost = 29}, {dst = 19, c
ost = 16}, {dst = 20, cost = 29}, {dst = 21, cost = 25}, {dst = 22, cost = 18},
{dst = 23, cost = 9}, {dst = 24, cost = 26}, {dst = 25, cost = 19}, },
  [2] = { {dst = 1, cost = 21}, {dst = 3, cost = 25}, {dst = 4, cost = 1}, {dst
= 5, cost = 10}, {dst = 6, cost = 9}, {dst = 7, cost = 27}, {dst = 8, cost = 8},
 {dst = 9, cost = 17}, {dst = 10, cost = 2}, {dst = 11, cost = 22}, {dst = 12, c
ost = 13}, {dst = 13, cost = 28}, {dst = 14, cost = 4}, {dst = 15, cost = 20}, {
dst = 16, cost = 2}, {dst = 17, cost = 1}, {dst = 18, cost = 24}, {dst = 19, cos
t = 21}, {dst = 20, cost = 14}, {dst = 21, cost = 6}, {dst = 22, cost = 1}, {dst
 = 23, cost = 9}, {dst = 24, cost = 28}, {dst = 25, cost = 22}, },
  [3] = { {dst = 1, cost = 25}, {dst = 2, cost = 25}, {dst = 4, cost = 27}, {dst
 = 5, cost = 22}, {dst = 6, cost = 5}, {dst = 7, cost = 14}, {dst = 8, cost = 13
}, {dst = 9, cost = 22}, {dst = 10, cost = 2}, {dst = 11, cost = 29}, {dst = 12,
 cost = 1}, {dst = 13, cost = 25}, {dst = 14, cost = 7}, {dst = 15, cost = 20},
{dst = 16, cost = 21}, {dst = 17, cost = 3}, {dst = 18, cost = 22}, {dst = 19, c
ost = 26}, {dst = 20, cost = 12}, {dst = 21, cost = 20}, {dst = 22, cost = 26},
{dst = 23, cost = 27}, {dst = 24, cost = 29}, {dst = 25, cost = 5}, },
  [4] = { {dst = 1, cost = 15}, {dst = 2, cost = 1}, {dst = 3, cost = 27}, {dst
= 5, cost = 8}, {dst = 6, cost = 11}, {dst = 7, cost = 27}, {dst = 8, cost = 23}
, {dst = 9, cost = 2}, {dst = 10, cost = 12}, {dst = 11, cost = 0}, {dst = 12, c
ost = 17}, {dst = 13, cost = 20}, {dst = 14, cost = 9}, {dst = 15, cost = 10}, {
dst = 16, cost = 9}, {dst = 17, cost = 5}, {dst = 18, cost = 7}, {dst = 19, cost
 = 8}, {dst = 20, cost = 16}, {dst = 21, cost = 12}, {dst = 22, cost = 21}, {dst
 = 23, cost = 22}, {dst = 24, cost = 13}, {dst = 25, cost = 0}, },
  [5] = { {dst = 1, cost = 24}, {dst = 2, cost = 10}, {dst = 3, cost = 22}, {dst
 = 4, cost = 8}, {dst = 6, cost = 26}, {dst = 7, cost = 19}, {dst = 8, cost = 18
}, {dst = 9, cost = 0}, {dst = 10, cost = 6}, {dst = 11, cost = 1}, {dst = 12, c
ost = 29}, {dst = 13, cost = 29}, {dst = 14, cost = 10}, {dst = 15, cost = 21},
{dst = 16, cost = 19}, {dst = 17, cost = 8}, {dst = 18, cost = 0}, {dst = 19, co
st = 29}, {dst = 20, cost = 19}, {dst = 21, cost = 13}, {dst = 22, cost = 21}, {
dst = 23, cost = 22}, {dst = 24, cost = 0}, {dst = 25, cost = 2}, },
  [6] = { {dst = 1, cost = 9}, {dst = 2, cost = 9}, {dst = 3, cost = 5}, {dst =
4, cost = 11}, {dst = 5, cost = 26}, {dst = 7, cost = 6}, {dst = 8, cost = 12},
{dst = 9, cost = 24}, {dst = 10, cost = 14}, {dst = 11, cost = 7}, {dst = 12, co
st = 0}, {dst = 13, cost = 5}, {dst = 14, cost = 27}, {dst = 15, cost = 0}, {dst
 = 16, cost = 10}, {dst = 17, cost = 10}, {dst = 18, cost = 26}, {dst = 19, cost
 = 18}, {dst = 20, cost = 11}, {dst = 21, cost = 16}, {dst = 22, cost = 18}, {ds
t = 23, cost = 11}, {dst = 24, cost = 2}, {dst = 25, cost = 0}, },
  [7] = { {dst = 1, cost = 10}, {dst = 2, cost = 27}, {dst = 3, cost = 14}, {dst
 = 4, cost = 27}, {dst = 5, cost = 19}, {dst = 6, cost = 6}, {dst = 8, cost = 21
}, {dst = 9, cost = 2}, {dst = 10, cost = 26}, {dst = 11, cost = 28}, {dst = 12,
 cost = 28}, {dst = 13, cost = 23}, {dst = 14, cost = 19}, {dst = 15, cost = 25}
, {dst = 16, cost = 10}, {dst = 17, cost = 8}, {dst = 18, cost = 26}, {dst = 19,
 cost = 29}, {dst = 20, cost = 25}, {dst = 21, cost = 25}, {dst = 22, cost = 27}
, {dst = 23, cost = 9}, {dst = 24, cost = 5}, {dst = 25, cost = 27}, },
  [8] = { {dst = 1, cost = 10}, {dst = 2, cost = 8}, {dst = 3, cost = 13}, {dst
= 4, cost = 23}, {dst = 5, cost = 18}, {dst = 6, cost = 12}, {dst = 7, cost = 21
}, {dst = 9, cost = 18}, {dst = 10, cost = 13}, {dst = 11, cost = 10}, {dst = 12
, cost = 7}, {dst = 13, cost = 27}, {dst = 14, cost = 25}, {dst = 15, cost = 14}
, {dst = 16, cost = 12}, {dst = 17, cost = 0}, {dst = 18, cost = 6}, {dst = 19,
cost = 1}, {dst = 20, cost = 16}, {dst = 21, cost = 9}, {dst = 22, cost = 16}, {
dst = 23, cost = 3}, {dst = 24, cost = 7}, {dst = 25, cost = 21}, },
  [9] = { {dst = 1, cost = 29}, {dst = 2, cost = 17}, {dst = 3, cost = 22}, {dst
 = 4, cost = 2}, {dst = 5, cost = 0}, {dst = 6, cost = 24}, {dst = 7, cost = 2},
 {dst = 8, cost = 18}, {dst = 10, cost = 12}, {dst = 11, cost = 0}, {dst = 12, c
ost = 22}, {dst = 13, cost = 14}, {dst = 14, cost = 15}, {dst = 15, cost = 20},
{dst = 16, cost = 23}, {dst = 17, cost = 4}, {dst = 18, cost = 18}, {dst = 19, c
ost = 28}, {dst = 20, cost = 7}, {dst = 21, cost = 15}, {dst = 22, cost = 16}, {
dst = 23, cost = 29}, {dst = 24, cost = 20}, {dst = 25, cost = 19}, },
  [10] = { {dst = 1, cost = 8}, {dst = 2, cost = 2}, {dst = 3, cost = 2}, {dst =
 4, cost = 12}, {dst = 5, cost = 6}, {dst = 6, cost = 14}, {dst = 7, cost = 26},
 {dst = 8, cost = 13}, {dst = 9, cost = 12}, {dst = 11, cost = 25}, {dst = 12, c
ost = 21}, {dst = 13, cost = 9}, {dst = 14, cost = 14}, {dst = 15, cost = 7}, {d
st = 16, cost = 25}, {dst = 17, cost = 14}, {dst = 18, cost = 10}, {dst = 19, co
st = 15}, {dst = 20, cost = 6}, {dst = 21, cost = 7}, {dst = 22, cost = 6}, {dst
 = 23, cost = 7}, {dst = 24, cost = 15}, {dst = 25, cost = 8}, },
  [11] = { {dst = 1, cost = 4}, {dst = 2, cost = 22}, {dst = 3, cost = 29}, {dst
 = 4, cost = 0}, {dst = 5, cost = 1}, {dst = 6, cost = 7}, {dst = 7, cost = 28},
 {dst = 8, cost = 10}, {dst = 9, cost = 0}, {dst = 10, cost = 25}, {dst = 12, co
st = 27}, {dst = 13, cost = 12}, {dst = 14, cost = 13}, {dst = 15, cost = 27}, {
dst = 16, cost = 29}, {dst = 17, cost = 2}, {dst = 18, cost = 19}, {dst = 19, co
st = 22}, {dst = 20, cost = 21}, {dst = 21, cost = 17}, {dst = 22, cost = 15}, {
dst = 23, cost = 15}, {dst = 24, cost = 15}, {dst = 25, cost = 19}, },
  [12] = { {dst = 1, cost = 17}, {dst = 2, cost = 13}, {dst = 3, cost = 1}, {dst
 = 4, cost = 17}, {dst = 5, cost = 29}, {dst = 6, cost = 0}, {dst = 7, cost = 28
}, {dst = 8, cost = 7}, {dst = 9, cost = 22}, {dst = 10, cost = 21}, {dst = 11,
cost = 27}, {dst = 13, cost = 6}, {dst = 14, cost = 20}, {dst = 15, cost = 13},
{dst = 16, cost = 14}, {dst = 17, cost = 28}, {dst = 18, cost = 3}, {dst = 19, c
ost = 7}, {dst = 20, cost = 26}, {dst = 21, cost = 26}, {dst = 22, cost = 4}, {d
st = 23, cost = 0}, {dst = 24, cost = 12}, {dst = 25, cost = 4}, },
  [13] = { {dst = 1, cost = 3}, {dst = 2, cost = 28}, {dst = 3, cost = 25}, {dst
 = 4, cost = 20}, {dst = 5, cost = 29}, {dst = 6, cost = 5}, {dst = 7, cost = 23
}, {dst = 8, cost = 27}, {dst = 9, cost = 14}, {dst = 10, cost = 9}, {dst = 11,
cost = 12}, {dst = 12, cost = 6}, {dst = 14, cost = 23}, {dst = 15, cost = 29},
{dst = 16, cost = 7}, {dst = 17, cost = 24}, {dst = 18, cost = 19}, {dst = 19, c
ost = 8}, {dst = 20, cost = 24}, {dst = 21, cost = 6}, {dst = 22, cost = 4}, {ds
t = 23, cost = 4}, {dst = 24, cost = 22}, {dst = 25, cost = 6}, },
  [14] = { {dst = 1, cost = 5}, {dst = 2, cost = 4}, {dst = 3, cost = 7}, {dst =
 4, cost = 9}, {dst = 5, cost = 10}, {dst = 6, cost = 27}, {dst = 7, cost = 19},
 {dst = 8, cost = 25}, {dst = 9, cost = 15}, {dst = 10, cost = 14}, {dst = 11, c
ost = 13}, {dst = 12, cost = 20}, {dst = 13, cost = 23}, {dst = 15, cost = 9}, {
dst = 16, cost = 0}, {dst = 17, cost = 22}, {dst = 18, cost = 19}, {dst = 19, co
st = 3}, {dst = 20, cost = 25}, {dst = 21, cost = 28}, {dst = 22, cost = 25}, {d
st = 23, cost = 24}, {dst = 24, cost = 10}, {dst = 25, cost = 8}, },
  [15] = { {dst = 1, cost = 25}, {dst = 2, cost = 20}, {dst = 3, cost = 20}, {ds
t = 4, cost = 10}, {dst = 5, cost = 21}, {dst = 6, cost = 0}, {dst = 7, cost = 2
5}, {dst = 8, cost = 14}, {dst = 9, cost = 20}, {dst = 10, cost = 7}, {dst = 11,
 cost = 27}, {dst = 12, cost = 13}, {dst = 13, cost = 29}, {dst = 14, cost = 9},
 {dst = 16, cost = 27}, {dst = 17, cost = 12}, {dst = 18, cost = 14}, {dst = 19,
 cost = 13}, {dst = 20, cost = 17}, {dst = 21, cost = 11}, {dst = 22, cost = 3},
 {dst = 23, cost = 18}, {dst = 24, cost = 7}, {dst = 25, cost = 6}, },
  [16] = { {dst = 1, cost = 24}, {dst = 2, cost = 2}, {dst = 3, cost = 21}, {dst
 = 4, cost = 9}, {dst = 5, cost = 19}, {dst = 6, cost = 10}, {dst = 7, cost = 10
}, {dst = 8, cost = 12}, {dst = 9, cost = 23}, {dst = 10, cost = 25}, {dst = 11,
 cost = 29}, {dst = 12, cost = 14}, {dst = 13, cost = 7}, {dst = 14, cost = 0},
{dst = 15, cost = 27}, {dst = 17, cost = 1}, {dst = 18, cost = 19}, {dst = 19, c
ost = 19}, {dst = 20, cost = 8}, {dst = 21, cost = 3}, {dst = 22, cost = 5}, {ds
t = 23, cost = 0}, {dst = 24, cost = 18}, {dst = 25, cost = 14}, },
  [17] = { {dst = 1, cost = 16}, {dst = 2, cost = 1}, {dst = 3, cost = 3}, {dst
= 4, cost = 5}, {dst = 5, cost = 8}, {dst = 6, cost = 10}, {dst = 7, cost = 8},
{dst = 8, cost = 0}, {dst = 9, cost = 4}, {dst = 10, cost = 14}, {dst = 11, cost
 = 2}, {dst = 12, cost = 28}, {dst = 13, cost = 24}, {dst = 14, cost = 22}, {dst
 = 15, cost = 12}, {dst = 16, cost = 1}, {dst = 18, cost = 8}, {dst = 19, cost =
 29}, {dst = 20, cost = 4}, {dst = 21, cost = 21}, {dst = 22, cost = 28}, {dst =
 23, cost = 12}, {dst = 24, cost = 2}, {dst = 25, cost = 6}, },
  [18] = { {dst = 1, cost = 29}, {dst = 2, cost = 24}, {dst = 3, cost = 22}, {ds
t = 4, cost = 7}, {dst = 5, cost = 0}, {dst = 6, cost = 26}, {dst = 7, cost = 26
}, {dst = 8, cost = 6}, {dst = 9, cost = 18}, {dst = 10, cost = 10}, {dst = 11,
cost = 19}, {dst = 12, cost = 3}, {dst = 13, cost = 19}, {dst = 14, cost = 19},
{dst = 15, cost = 14}, {dst = 16, cost = 19}, {dst = 17, cost = 8}, {dst = 19, c
ost = 23}, {dst = 20, cost = 16}, {dst = 21, cost = 22}, {dst = 22, cost = 26},
{dst = 23, cost = 11}, {dst = 24, cost = 23}, {dst = 25, cost = 25}, },
  [19] = { {dst = 1, cost = 16}, {dst = 2, cost = 21}, {dst = 3, cost = 26}, {ds
t = 4, cost = 8}, {dst = 5, cost = 29}, {dst = 6, cost = 18}, {dst = 7, cost = 2
9}, {dst = 8, cost = 1}, {dst = 9, cost = 28}, {dst = 10, cost = 15}, {dst = 11,
 cost = 22}, {dst = 12, cost = 7}, {dst = 13, cost = 8}, {dst = 14, cost = 3}, {
dst = 15, cost = 13}, {dst = 16, cost = 19}, {dst = 17, cost = 29}, {dst = 18, c
ost = 23}, {dst = 20, cost = 11}, {dst = 21, cost = 6}, {dst = 22, cost = 15}, {
dst = 23, cost = 11}, {dst = 24, cost = 18}, {dst = 25, cost = 16}, },
  [20] = { {dst = 1, cost = 29}, {dst = 2, cost = 14}, {dst = 3, cost = 12}, {ds
t = 4, cost = 16}, {dst = 5, cost = 19}, {dst = 6, cost = 11}, {dst = 7, cost =
25}, {dst = 8, cost = 16}, {dst = 9, cost = 7}, {dst = 10, cost = 6}, {dst = 11,
 cost = 21}, {dst = 12, cost = 26}, {dst = 13, cost = 24}, {dst = 14, cost = 25}
, {dst = 15, cost = 17}, {dst = 16, cost = 8}, {dst = 17, cost = 4}, {dst = 18,
cost = 16}, {dst = 19, cost = 11}, {dst = 21, cost = 12}, {dst = 22, cost = 24},
 {dst = 23, cost = 4}, {dst = 24, cost = 22}, {dst = 25, cost = 24}, },
  [21] = { {dst = 1, cost = 25}, {dst = 2, cost = 6}, {dst = 3, cost = 20}, {dst
 = 4, cost = 12}, {dst = 5, cost = 13}, {dst = 6, cost = 16}, {dst = 7, cost = 2
5}, {dst = 8, cost = 9}, {dst = 9, cost = 15}, {dst = 10, cost = 7}, {dst = 11,
cost = 17}, {dst = 12, cost = 26}, {dst = 13, cost = 6}, {dst = 14, cost = 28},
{dst = 15, cost = 11}, {dst = 16, cost = 3}, {dst = 17, cost = 21}, {dst = 18, c
ost = 22}, {dst = 19, cost = 6}, {dst = 20, cost = 12}, {dst = 22, cost = 4}, {d
st = 23, cost = 25}, {dst = 24, cost = 3}, {dst = 25, cost = 2}, },
  [22] = { {dst = 1, cost = 18}, {dst = 2, cost = 1}, {dst = 3, cost = 26}, {dst
 = 4, cost = 21}, {dst = 5, cost = 21}, {dst = 6, cost = 18}, {dst = 7, cost = 2
7}, {dst = 8, cost = 16}, {dst = 9, cost = 16}, {dst = 10, cost = 6}, {dst = 11,
 cost = 15}, {dst = 12, cost = 4}, {dst = 13, cost = 4}, {dst = 14, cost = 25},
{dst = 15, cost = 3}, {dst = 16, cost = 5}, {dst = 17, cost = 28}, {dst = 18, co
st = 26}, {dst = 19, cost = 15}, {dst = 20, cost = 24}, {dst = 21, cost = 4}, {d
st = 23, cost = 23}, {dst = 24, cost = 28}, {dst = 25, cost = 14}, },
  [23] = { {dst = 1, cost = 9}, {dst = 2, cost = 9}, {dst = 3, cost = 27}, {dst
= 4, cost = 22}, {dst = 5, cost = 22}, {dst = 6, cost = 11}, {dst = 7, cost = 9}
, {dst = 8, cost = 3}, {dst = 9, cost = 29}, {dst = 10, cost = 7}, {dst = 11, co
st = 15}, {dst = 12, cost = 0}, {dst = 13, cost = 4}, {dst = 14, cost = 24}, {ds
t = 15, cost = 18}, {dst = 16, cost = 0}, {dst = 17, cost = 12}, {dst = 18, cost
 = 11}, {dst = 19, cost = 11}, {dst = 20, cost = 4}, {dst = 21, cost = 25}, {dst
 = 22, cost = 23}, {dst = 24, cost = 11}, {dst = 25, cost = 26}, },
  [24] = { {dst = 1, cost = 26}, {dst = 2, cost = 28}, {dst = 3, cost = 29}, {ds
t = 4, cost = 13}, {dst = 5, cost = 0}, {dst = 6, cost = 2}, {dst = 7, cost = 5}
, {dst = 8, cost = 7}, {dst = 9, cost = 20}, {dst = 10, cost = 15}, {dst = 11, c
ost = 15}, {dst = 12, cost = 12}, {dst = 13, cost = 22}, {dst = 14, cost = 10},
{dst = 15, cost = 7}, {dst = 16, cost = 18}, {dst = 17, cost = 2}, {dst = 18, co
st = 23}, {dst = 19, cost = 18}, {dst = 20, cost = 22}, {dst = 21, cost = 3}, {d
st = 22, cost = 28}, {dst = 23, cost = 11}, {dst = 25, cost = 27}, },
  [25] = { {dst = 1, cost = 19}, {dst = 2, cost = 22}, {dst = 3, cost = 5}, {dst
 = 4, cost = 0}, {dst = 5, cost = 2}, {dst = 6, cost = 0}, {dst = 7, cost = 27},
 {dst = 8, cost = 21}, {dst = 9, cost = 19}, {dst = 10, cost = 8}, {dst = 11, co
st = 19}, {dst = 12, cost = 4}, {dst = 13, cost = 6}, {dst = 14, cost = 8}, {dst
 = 15, cost = 6}, {dst = 16, cost = 14}, {dst = 17, cost = 6}, {dst = 18, cost =
 25}, {dst = 19, cost = 16}, {dst = 20, cost = 24}, {dst = 21, cost = 2}, {dst =
 22, cost = 14}, {dst = 23, cost = 26}, {dst = 24, cost = 27}, },
  length = 25
}

The table of distances of nodes from node       2        using Bellman Ford is:
1       ,       5
2       ,       0
3       ,       2
4       ,       1
5       ,       1
6       ,       1
7       ,       3
8       ,       1
9       ,       1
10      ,       2
11      ,       1
12      ,       1
13      ,       5
14      ,       1
15      ,       1
16      ,       1
17      ,       1
18      ,       1
19      ,       2
20      ,       5
21      ,       3
22      ,       1
23      ,       1
24      ,       1
25      ,       1

The table of predecessors of nodes using Bellman Ford is:
1       ,       11
3       ,       12
4       ,       2
5       ,       9
6       ,       25
7       ,       9
8       ,       17
9       ,       11
10      ,       2
11      ,       4
12      ,       6
13      ,       22
14      ,       16
15      ,       6
16      ,       23
17      ,       2
18      ,       5
19      ,       8
20      ,       17
21      ,       25
22      ,       2
23      ,       12
24      ,       5
25      ,       4

The shortest path between source node   2        and destination node   10
 is:
2 -> 10

The shortest path between source node   2        and destination node   4
 is:
2 -> 4

The shortest path between source node   2        and destination node   20
 is:
2 -> 17 -> 20

The shortest path between source node   2        and destination node   14
 is:
2 -> 4 -> 25 -> 6 -> 12 -> 23 -> 16 -> 14

The shortest path between source node   2        and destination node   25
 is:
2 -> 4 -> 25

Test Run 4:
Commands used to test:
1) load file using -> require "bellman_ford"
2) run test wrapper using -> test_bf(3, 25, 1, 15, 30, 2, 10, 4, 20, 14, 25)

Output:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "bellman_ford"
> test_bf(3, 25, 1, 15, 30, 2, 10, 4, 20, 14, 25)
The first argument (choice) has to be either 1 (directed graph) or 2 (undirected
 graph). Please try again.

Test Run 5:
Commands used to test:
1) load file using -> require "bellman_ford"
2) run test wrapper using -> test_bf(1, 10, .7, 15, 30, 5, 10, 3, 1, 5, 9)

Output:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "bellman_ford"
> test_bf(1, 10, .7, 15, 30, 5, 10, 3, 1, 5, 9)
The directed graph being tested is:

{
  [1] = { {dst = 2, cost = 7}, {dst = 4, cost = 4}, {dst = 6, cost = 21}, {dst =
 7, cost = 4}, {dst = 8, cost = 9}, {dst = 10, cost = 11}, },
  [2] = { {dst = 1, cost = 16}, {dst = 3, cost = 21}, {dst = 4, cost = 4}, {dst
= 5, cost = 4}, {dst = 7, cost = 18}, {dst = 8, cost = 12}, {dst = 10, cost = 18
}, },
  [3] = { {dst = 1, cost = 15}, {dst = 4, cost = 22}, {dst = 5, cost = 18}, {dst
 = 8, cost = 29}, {dst = 9, cost = 17}, },
  [4] = { {dst = 7, cost = 15}, {dst = 8, cost = 25}, {dst = 9, cost = 27}, {dst
 = 10, cost = 2}, },
  [5] = { {dst = 1, cost = 20}, {dst = 2, cost = 9}, {dst = 4, cost = 13}, {dst
= 8, cost = 25}, {dst = 9, cost = 24}, {dst = 10, cost = 3}, },
  [6] = { {dst = 1, cost = 4}, {dst = 2, cost = 14}, {dst = 4, cost = 23}, {dst
= 7, cost = 28}, {dst = 8, cost = 9}, {dst = 9, cost = 21}, {dst = 10, cost = 22
}, },
  [7] = { {dst = 1, cost = 23}, {dst = 2, cost = 28}, {dst = 3, cost = 22}, {dst
 = 4, cost = 7}, {dst = 5, cost = 2}, {dst = 10, cost = 14}, },
  [8] = { {dst = 1, cost = 23}, {dst = 2, cost = 9}, {dst = 3, cost = 10}, {dst
= 4, cost = 18}, {dst = 6, cost = 5}, {dst = 7, cost = 20}, {dst = 9, cost = 0},
 {dst = 10, cost = 9}, },
  [9] = { {dst = 1, cost = 5}, {dst = 2, cost = 14}, {dst = 4, cost = 12}, {dst
= 6, cost = 25}, {dst = 8, cost = 16}, {dst = 10, cost = 11}, },
  [10] = { {dst = 4, cost = 18}, {dst = 5, cost = 10}, {dst = 6, cost = 6}, {dst
 = 7, cost = 9}, {dst = 8, cost = 17}, },
  length = 10
}

The table of distances of nodes from node       5        using Bellman Ford is:
1       ,       13
2       ,       9
3       ,       28
4       ,       13
5       ,       0
6       ,       9
7       ,       12
8       ,       18
9       ,       18
10      ,       3

The table of predecessors of nodes using Bellman Ford is:
1       ,       6
2       ,       5
3       ,       8
4       ,       5
6       ,       10
7       ,       10
8       ,       6
9       ,       8
10      ,       5

The shortest path between source node   5        and destination node   10
 is:
5 -> 10

The shortest path between source node   5        and destination node   3
 is:
5 -> 10 -> 6 -> 8 -> 3

The shortest path between source node   5        and destination node   1
 is:
5 -> 10 -> 6 -> 1

The shortest path between source node   5        and destination node   5
 is:
5

The shortest path between source node   5        and destination node   9
 is:
5 -> 10 -> 6 -> 8 -> 9


Test Run 6:
Commands used to test:
1) load file using -> require "bellman_ford"
2) run test wrapper using -> test_bf(1, 10, .7, 15, 30, 0, 10, 3, 1, 5, 9)

Output:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "bellman_ford"
> test_bf(1, 10, .7, 15, 30, 0, 10, 3, 1, 5, 9)
The directed graph being tested is:

{
  [1] = { {dst = 2, cost = 24}, {dst = 3, cost = 8}, {dst = 4, cost = 19}, {dst
= 9, cost = 19}, {dst = 10, cost = 12}, },
  [2] = { {dst = 1, cost = 28}, {dst = 3, cost = 26}, {dst = 4, cost = 0}, {dst
= 5, cost = 7}, {dst = 7, cost = 18}, {dst = 8, cost = 28}, {dst = 9, cost = 6},
 {dst = 10, cost = 29}, },
  [3] = { {dst = 1, cost = 7}, {dst = 2, cost = 11}, {dst = 5, cost = 1}, {dst =
 6, cost = 3}, {dst = 7, cost = 22}, {dst = 8, cost = 5}, {dst = 9, cost = 0}, {
dst = 10, cost = 22}, },
  [4] = { {dst = 1, cost = 16}, {dst = 2, cost = 16}, {dst = 5, cost = 18}, {dst
 = 7, cost = 9}, {dst = 9, cost = 21}, {dst = 10, cost = 23}, },
  [5] = { {dst = 2, cost = 21}, {dst = 3, cost = 22}, {dst = 6, cost = 4}, {dst
= 7, cost = 27}, },
  [6] = { {dst = 3, cost = 10}, {dst = 4, cost = 2}, {dst = 5, cost = 28}, {dst
= 7, cost = 2}, {dst = 8, cost = 2}, {dst = 9, cost = 16}, {dst = 10, cost = 1},
 },
  [7] = { {dst = 1, cost = 11}, {dst = 3, cost = 26}, {dst = 4, cost = 27}, {dst
 = 6, cost = 3}, {dst = 8, cost = 22}, {dst = 10, cost = 9}, },
  [8] = { {dst = 1, cost = 5}, {dst = 2, cost = 5}, {dst = 4, cost = 22}, {dst =
 5, cost = 14}, {dst = 6, cost = 12}, {dst = 7, cost = 6}, },
  [9] = { {dst = 1, cost = 17}, {dst = 3, cost = 0}, {dst = 4, cost = 9}, {dst =
 6, cost = 20}, {dst = 7, cost = 21}, {dst = 8, cost = 9}, },
  [10] = { {dst = 1, cost = 17}, {dst = 4, cost = 26}, {dst = 6, cost = 24}, {ds
t = 7, cost = 1}, },
  length = 10
}

The table of distances of nodes from node       0        using Bellman Ford is:
1       ,       1.#INF
2       ,       1.#INF
3       ,       1.#INF
4       ,       1.#INF
5       ,       1.#INF
6       ,       1.#INF
7       ,       1.#INF
8       ,       1.#INF
9       ,       1.#INF
10      ,       1.#INF
0       ,       0

The table of predecessors of nodes using Bellman Ford is:

The shortest path between source node   0        and destination node   10
 is:
There is no existing path in between these nodes.

The shortest path between source node   0        and destination node   3
 is:
There is no existing path in between these nodes.

The shortest path between source node   0        and destination node   1
 is:
There is no existing path in between these nodes.

The shortest path between source node   0        and destination node   5
 is:
There is no existing path in between these nodes.

The shortest path between source node   0        and destination node   9
 is:
There is no existing path in between these nodes.

Test Run 7:
Commands used to test:
1) load file using -> require "bellman_ford"
2) run test wrapper using -> test_bf(2, 10, .7, 15, 30, -1, 10, 3, 1, 5, 9)

Output:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "bellman_ford"
> test_bf(2, 10, .7, 15, 30, -1, 10, 3, 1, 5, 9)
The undirected graph being tested is:

{
  [1] = { {dst = 2, cost = 14}, {dst = 3, cost = 3}, {dst = 4, cost = 19}, {dst
= 5, cost = 5}, {dst = 6, cost = 17}, {dst = 8, cost = 24}, {dst = 9, cost = 12}
, {dst = 10, cost = 5}, },
  [2] = { {dst = 1, cost = 14}, {dst = 3, cost = 19}, {dst = 4, cost = 21}, {dst
 = 5, cost = 8}, {dst = 6, cost = 25}, {dst = 7, cost = 29}, {dst = 8, cost = 18
}, },
  [3] = { {dst = 1, cost = 3}, {dst = 2, cost = 19}, {dst = 4, cost = 8}, {dst =
 5, cost = 5}, {dst = 6, cost = 0}, {dst = 7, cost = 10}, {dst = 8, cost = 17},
{dst = 10, cost = 27}, },
  [4] = { {dst = 1, cost = 19}, {dst = 2, cost = 21}, {dst = 3, cost = 8}, {dst
= 5, cost = 16}, {dst = 7, cost = 6}, {dst = 8, cost = 15}, {dst = 9, cost = 24}
, {dst = 10, cost = 3}, },
  [5] = { {dst = 1, cost = 5}, {dst = 2, cost = 8}, {dst = 3, cost = 5}, {dst =
4, cost = 16}, {dst = 6, cost = 21}, {dst = 8, cost = 14}, {dst = 9, cost = 10},
 {dst = 10, cost = 1}, },
  [6] = { {dst = 1, cost = 17}, {dst = 2, cost = 25}, {dst = 3, cost = 0}, {dst
= 5, cost = 21}, {dst = 7, cost = 13}, {dst = 8, cost = 0}, {dst = 9, cost = 18}
, {dst = 10, cost = 27}, },
  [7] = { {dst = 2, cost = 29}, {dst = 3, cost = 10}, {dst = 4, cost = 6}, {dst
= 6, cost = 13}, {dst = 8, cost = 16}, {dst = 9, cost = 26}, {dst = 10, cost = 2
0}, },
  [8] = { {dst = 1, cost = 24}, {dst = 2, cost = 18}, {dst = 3, cost = 17}, {dst
 = 4, cost = 15}, {dst = 5, cost = 14}, {dst = 6, cost = 0}, {dst = 7, cost = 16
}, {dst = 9, cost = 22}, },
  [9] = { {dst = 1, cost = 12}, {dst = 4, cost = 24}, {dst = 5, cost = 10}, {dst
 = 6, cost = 18}, {dst = 7, cost = 26}, {dst = 8, cost = 22}, {dst = 10, cost =
22}, },
  [10] = { {dst = 1, cost = 5}, {dst = 3, cost = 27}, {dst = 4, cost = 3}, {dst
= 5, cost = 1}, {dst = 6, cost = 27}, {dst = 7, cost = 20}, {dst = 9, cost = 22}
, },
  length = 10
}

The table of distances of nodes from node       -1       using Bellman Ford is:
1       ,       1.#INF
2       ,       1.#INF
3       ,       1.#INF
4       ,       1.#INF
5       ,       1.#INF
6       ,       1.#INF
7       ,       1.#INF
8       ,       1.#INF
9       ,       1.#INF
10      ,       1.#INF
-1      ,       0

The table of predecessors of nodes using Bellman Ford is:

The shortest path between source node   -1       and destination node   10
 is:
There is no existing path in between these nodes.

The shortest path between source node   -1       and destination node   3
 is:
There is no existing path in between these nodes.

The shortest path between source node   -1       and destination node   1
 is:
There is no existing path in between these nodes.

The shortest path between source node   -1       and destination node   5
 is:
There is no existing path in between these nodes.

The shortest path between source node   -1       and destination node   9
 is:
There is no existing path in between these nodes.

--]]
