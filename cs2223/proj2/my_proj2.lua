--Project 2

--Tushar Narayan
--tnarayan@wpi.edu

--Part 1: Connected Components

--[[Logic:
-Start BFS from any node s. This gives one component of the graph.
-Take any currently unexpored node t to start another BFS.
This will give us another connected component.
-Continue Step 2 until all nodes have been explored.

Function will return a 2d array of connected edges
--]]

require "graphs"
require "queues"
require "stacks"
require "util"
require "undirected_graphs"

function connected_comp(g)
local bfs_q = queues.new()
local bfs_results = {}
local connections = {} --to store the results of connected components

	local function seen(v)
      return
	 -- was set non-nil
	 -- when we first saw v
	 bfs_results[v]
   end

   local function get_dist(parent)
      return
	 (parent and		-- 1 plus parent distance
	 bfs_results[parent].dist+1)
	 or 0			-- 0 if no parent, at start
   end

   local function visit(parent,v)
      -- v is a new node,
      -- so record its results

      bfs_results[v] = {
	 dist = get_dist(parent),
         pi = parent }		-- parent, maybe nil (at start)
   end

   local function do_node (u)
      -- visit all the new neighbors
      for v in graphs.neighbors(g[u]) do
	 -- been there, done that?
	 if not(seen(v))
	 then
	    visit(u,v)		-- Now visiting v from parent u
	    queues.enqueue(bfs_q,v)	-- Enqueue v to do later
	 end
      end
   end

   -- now that the utility fns are defined,
   -- heres the main code:
   local j = 1 --iterator for the connections array
	for k, v in pairs(g) do --want to iterate over all the nodes
		if k ~= "length" then
			s = k
			if not(seen(s)) then --explore only unseen nodes
				queues.enqueue(bfs_q,s)
				visit(nil,s)

				local comps = {} --the current array of connected nodes
				local i = 1 --iterator for the comps array
				while not(queues.empty(bfs_q))	-- while queue has elements
				do
					temp = queues.dequeue(bfs_q)
					do_node(temp) -- do next
					comps[i] = temp --build up array of connections
					i = i + 1
				end
				connections[j] = comps --store a connected component
				j = j + 1

			end
		end
	end
	print("Members of each component (in no particular order) are:")
	for i = 1, #connections do
		util.print_array(connections[i])
	end
	return connections
end

--function that prints a 2 dimensional array
--calls print_array for each element of 2d array
function print_2d_array (a)
   io.write("{")
   for i = 1, #a do
		io.write("\t")
      util.print_array(a[i])
   end;
   io.write("}\n")
end

--[[
Test Run:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "my_proj2"
> ug1 = {   [1] = { {dst = 7}, {dst = 14}, },   [2] = { {dst = 11}, },   [3] = {
 {dst = 9}, {dst = 7}, },   [4] = { },   [5] = { {dst = 11}, },   [6] = { {dst =
 11}, },   [7] = { {dst = 1}, {dst = 3}, {dst = 15}, {dst = 8}, {dst = 15}, },
 [8] = { {dst = 7}, },   [9] = { {dst = 3}, {dst = 10}, {dst = 15}, {dst = 13},
},   [10] = { {dst = 9}, {dst = 12}, {dst = 12}, },   [11] = { {dst = 2}, {dst =
 5}, {dst = 6}, },   [12] = { {dst = 10}, {dst = 10}, },   [13] = { {dst = 9}, }
,   [14] = { {dst = 1}, },   [15] = { {dst = 7}, {dst = 9}, {dst = 7}, },   leng
th = 15}
>> >
> connections_results = connected_comp(ug1)
Members of each component (in no particular order) are:
{13, 9, 3, 10, 15, 7, 12, 1, 8, 14}
{2, 11, 5, 6}
{4}
> print_2d_array(connections_results)
{       {13, 9, 3, 10, 15, 7, 12, 1, 8, 14}
        {2, 11, 5, 6}
        {4}
}
> ug2 =    {   [1] = { {dst = 10}, },   [2] = { {dst = 3}, {dst = 14}, },   [3]
= { {dst = 2}, {dst = 9}, {dst = 12}, {dst = 13}, },   [4] = { },   [5] = { {dst
 = 7}, {dst = 11}, {dst = 12}, },   [6] = { {dst = 10}, {dst = 13}, },   [7] = {
 {dst = 5}, },   [8] = { {dst = 13}, },   [9] = { {dst = 3}, {dst = 13}, },   [1
0] = { {dst = 1}, {dst = 6}, {dst = 14}, {dst = 14}, },   [11] = { {dst = 5}, {d
st = 12}, },   [12] = { {dst = 3}, {dst = 5}, {dst = 11}, },   [13] = { {dst = 8
}, {dst = 3}, {dst = 6}, {dst = 9}, {dst = 15}, },   [14] = { {dst = 10}, {dst =
 2}, {dst = 10}, },   [15] = { {dst = 13}, },   length = 15}
>> >
> connections_results = connected_comp(ug2)
Members of each component (in no particular order) are:
{13, 8, 3, 6, 9, 15, 2, 12, 10, 14, 5, 11, 1, 7}
{4}
> ug3 =    {   [1] = { },   [2] = { {dst = 9}, },   [3] = { {dst = 6}, },   [4]
= { {dst = 13}, {dst = 11}, {dst = 14}, },   [5] = { },   [6] = { {dst = 3}, {ds
t = 12}, },   [7] = { },   [8] = { },   [9] = { {dst = 2}, },   [10] = { {dst =
14}, },   [11] = { {dst = 4}, },   [12] = { {dst = 6}, },   [13] = { {dst = 4},
},   [14] = { {dst = 10}, {dst = 4}, },   [15] = { },   length = 15 }
> connections_results = connected_comp(ug3)
Members of each component (in no particular order) are:
{13, 4, 11, 14, 10}
{7}
{1}
{2, 9}
{8}
{15}
{5}
{3, 6, 12}
> print_2d_array(connections_results)
{       {13, 4, 11, 14, 10}
        {7}
        {1}
        {2, 9}
        {8}
        {15}
        {5}
        {3, 6, 12}
}
--]]


--Part 3: Finding a Cycle

function has_cycle(g)
   local dfs_results = {}
   local step_number = 1
   local num_cycles = 0 --to store the number of cycles(if any) found

   local function step()
      local now = step_number
      step_number = step_number+1
      return now
   end

   local function start_visit(parent, v)
      -- v is new, so
      -- install its dfs result info
      dfs_results[v] = {
	  active = false, --add the active attribute
	 found = step(),
	 pi = parent }
   end

   local function end_visit(u)
      dfs_results[u].finish = step()
   end


   local function do_node(u)
	for t in graphs.neighbors(g[u]) do
		--test for cycle
		if dfs_results[t] and dfs_results[t].active == true then
			path_parent = dfs_results[u].pi --parent of current node
			if path_parent ~= nil then --actual cycle exists
				local path_stack = stacks.new() --store parents in a stack
				if(num_cycles == 0) then --extra nice messaging to user
					print("This graph has cycles!")
				end
				num_cycles = num_cycles + 1
				print("Cycle Number ", num_cycles, ":")
				stacks.push(path_stack, u)
				--iterate to find parent path
				while(path_parent ~= t and path_parent ~= nil) do
					stacks.push(path_stack, path_parent)
					path_parent = dfs_results[path_parent].pi
				end
				if path_parent ~= nil then
					stacks.push(path_stack, path_parent)
				end
				stacks.push(path_stack, u) --since cycle, last parent will be self
				io.write(stacks.pop(path_stack)) --at least one element assured, can safely pop
				while(stacks.top(path_stack) ~= nil) do
					io.write(" -> ")
					io.write(stacks.pop(path_stack))
				end
				io.write("\n")
			end
		end
	end
	for v in graphs.neighbors(g[u]) do
		-- been there, done that?
		if not(dfs_results[v])
			then
			start_visit(u,v)
			-- immediately explore from v
			dfs_results[v].active = true --set active attribute
			do_node(v) 	--this is the recursive call!
			end_visit (v)
			dfs_results[v].active = false --reset active attribute
		end
    end
   end

   for u in graphs.nodes(g) do
      if not(dfs_results[u])
      then
	 -- u is new, start again from u
         -- however, u has no parent.
         start_visit(nil,u)

	 -- immediately explore from u
		dfs_results[u].active = true
         do_node(u)
	 end_visit(u)
      end
   end
   --if no cycles found:
   if(num_cycles == 0) then print("This graph has no cycles.") end
end

--[[
Test Runs:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "my_proj2"
> g7 = {   [1] = { {dst = 2}, },  [2] = { {dst = 3}, },    [3] = {{dst = 1}},len
gth = 3 }
> has_cycle(g7)
This graph has cycles!
Cycle Number    1       :
3 -> 1 -> 2 -> 3
>
> cities_graph_no_names =    {   [1] = { {dst = 2}, {dst = 3}, {dst = 4}, {dst =
 5}, },   [2] = { {dst = 1}, {dst = 14}, {dst = 16}, },   [3] = { {dst = 1}, {ds
t = 27}, },   [4] = { {dst = 1}, {dst = 14}, {dst = 17}, },   [5] = { {dst = 1},
 {dst = 12}, {dst = 13}, },   [6] = { {dst = 7}, },   [7] = { {dst = 6}, {dst =
11}, {dst = 12}, },   [8] = { {dst = 9}, {dst = 10}, },   [9] = { {dst = 8}, {ds
t = 11}, {dst = 13}, },   [10] = { {dst = 8}, {dst = 17}, {dst = 28}, },   [11]
= { {dst = 9}, {dst = 7}, {dst = 12}, {dst = 13}, },   [12] = { {dst = 11}, {dst
 = 7}, {dst = 5}, },   [13] = { {dst = 11}, {dst = 9}, {dst = 5}, },   [14] = {
{dst = 15}, {dst = 16}, {dst = 17}, {dst = 2}, {dst = 4}, },   [15] = { {dst = 1
4}, {dst = 21}, },   [16] = { {dst = 14}, {dst = 2}, },   [17] = { {dst = 14}, {
dst = 18}, {dst = 10}, {dst = 4}, },   [18] = { {dst = 17}, {dst = 19}, {dst = 2
0}, },   [19] = { {dst = 18}, {dst = 24}, {dst = 26}, },   [20] = { {dst = 18},
{dst = 22}, },   [21] = { {dst = 15}, {dst = 22}, {dst = 25}, },   [22] = { {dst
 = 23}, {dst = 21}, {dst = 20}, },   [23] = { {dst = 22}, {dst = 24}, {dst = 25}
, {dst = 26}, },   [24] = { {dst = 23}, {dst = 19}, },   [25] = { {dst = 23}, {d
st = 21}, },   [26] = { {dst = 23}, {dst = 19}, {dst = 28}, },   [27] = { {dst =
 3}, },   [28] = { {dst = 10}, {dst = 26}, },   [29] = { {dst = 30}, },   [30] =
 { {dst = 29}, },   [31] = { {dst = 32}, },   [32] = { {dst = 31}, },   length =
 32}
>> >> >
> has_cycle(cities_graph_no_names)
This graph has cycles!
Cycle Number    1       :
2 -> 1 -> 2
Cycle Number    2       :
14 -> 2 -> 14
Cycle Number    3       :
15 -> 14 -> 15
Cycle Number    4       :
21 -> 15 -> 21
Cycle Number    5       :
22 -> 21 -> 22
Cycle Number    6       :
23 -> 22 -> 23
Cycle Number    7       :
24 -> 23 -> 24
Cycle Number    8       :
19 -> 24 -> 19
Cycle Number    9       :
18 -> 19 -> 18
Cycle Number    10      :
17 -> 14 -> 15 -> 21 -> 22 -> 23 -> 24 -> 19 -> 18 -> 17
Cycle Number    11      :
17 -> 18 -> 17
Cycle Number    12      :
10 -> 17 -> 10
Cycle Number    13      :
8 -> 10 -> 8
Cycle Number    14      :
9 -> 8 -> 9
Cycle Number    15      :
11 -> 9 -> 11
Cycle Number    16      :
7 -> 11 -> 7
Cycle Number    17      :
6 -> 7 -> 6
Cycle Number    18      :
12 -> 11 -> 7 -> 12
Cycle Number    19      :
12 -> 7 -> 12
Cycle Number    20      :
5 -> 1 -> 2 -> 14 -> 15 -> 21 -> 22 -> 23 -> 24 -> 19 -> 18 -> 17 -> 10 -> 8 ->
9 -> 11 -> 7 -> 12 -> 5
Cycle Number    21      :
5 -> 12 -> 5
Cycle Number    22      :
13 -> 11 -> 7 -> 12 -> 5 -> 13
Cycle Number    23      :
13 -> 9 -> 11 -> 7 -> 12 -> 5 -> 13
Cycle Number    24      :
13 -> 5 -> 13
Cycle Number    25      :
28 -> 10 -> 28
Cycle Number    26      :
26 -> 23 -> 24 -> 19 -> 18 -> 17 -> 10 -> 28 -> 26
Cycle Number    27      :
26 -> 19 -> 18 -> 17 -> 10 -> 28 -> 26
Cycle Number    28      :
26 -> 28 -> 26
Cycle Number    29      :
4 -> 1 -> 2 -> 14 -> 15 -> 21 -> 22 -> 23 -> 24 -> 19 -> 18 -> 17 -> 4
Cycle Number    30      :
4 -> 14 -> 15 -> 21 -> 22 -> 23 -> 24 -> 19 -> 18 -> 17 -> 4
Cycle Number    31      :
4 -> 17 -> 4
Cycle Number    32      :
20 -> 18 -> 20
Cycle Number    33      :
20 -> 22 -> 23 -> 24 -> 19 -> 18 -> 20
Cycle Number    34      :
25 -> 23 -> 25
Cycle Number    35      :
25 -> 21 -> 22 -> 23 -> 25
Cycle Number    36      :
16 -> 14 -> 16
Cycle Number    37      :
16 -> 2 -> 14 -> 16
Cycle Number    38      :
3 -> 1 -> 3
Cycle Number    39      :
27 -> 3 -> 27
Cycle Number    40      :
30 -> 29 -> 30
Cycle Number    41      :
32 -> 31 -> 32
> g1 =    {   [1] = { {dst = 9}, {dst = 14}, },   [2] = { {dst = 8}, },   [3] =
{ {dst = 1}, },   [4] = { {dst = 3}, },   [5] = { {dst = 1}, {dst = 6}, },   [6]
 = { {dst = 10}, },   [7] = { {dst = 13}, {dst = 14}, },   [8] = { {dst = 3}, },
   [9] = { {dst = 4}, {dst = 10}, },   [10] = { {dst = 2}, {dst = 13}, },   [11]
 = { {dst = 2}, {dst = 13}, },   [12] = { {dst = 6}, {dst = 7}, {dst = 9}, },
[13] = { {dst = 7}, {dst = 15}, },   [14] = { },   [15] = { },   length = 15}
> has_cycle(g1)
This graph has cycles!
Cycle Number    1       :
3 -> 1 -> 9 -> 4 -> 3
Cycle Number    2       :
7 -> 13 -> 7
> g2 =    {   [1] = { },   [2] = { },   [3] = { {dst = 6}, {dst = 12}, },   [4]
= { {dst = 5}, {dst = 14}, },   [5] = { },   [6] = { {dst = 4}, {dst = 8}, {dst
= 15}, },   [7] = { },   [8] = { {dst = 1}, {dst = 13}, },   [9] = { {dst = 5},
{dst = 8}, },   [10] = { {dst = 8}, {dst = 12}, },   [11] = { {dst = 7}, {dst =
10}, },   [12] = { {dst = 4}, {dst = 7}, {dst = 9}, },   [13] = { },   [14] = {
{dst = 2}, {dst = 7}, {dst = 13}, },   [15] = { },   length = 15}
> has_cycle(g2)
This graph has cycles!
Cycle Number    1       :
14 -> 3 -> 6 -> 4 -> 14
Cycle Number    2       :
8 -> 3 -> 6 -> 8
> g3 = {   [1] = { {dst = 10}, {dst = 11}, },   [2] = { {dst = 8}, },   [3] = {
{dst = 8}, {dst = 13}, {dst = 14}, {dst = 15}, },   [4] = { },   [5] = { {dst =
1}, {dst = 14}, },   [6] = { },   [7] = { {dst = 3}, },   [8] = { {dst = 2}, {ds
t = 4}, {dst = 6}, },   [9] = { {dst = 5}, {dst = 10}, },   [10] = { {dst = 1},
{dst = 4}, {dst = 11}, {dst = 15}, },   [11] = { {dst = 2}, {dst = 5}, {dst = 12
}, },   [12] = { {dst = 1}, {dst = 2}, },   [13] = { {dst = 6}, {dst = 12}, },
 [14] = { {dst = 9}, },   [15] = { {dst = 3}, },   length = 15}
>> >
> has_cycle(g3)
This graph has cycles!
Cycle Number    1       :
10 -> 1 -> 10
Cycle Number    2       :
8 -> 2 -> 8
Cycle Number    3       :
5 -> 1 -> 10 -> 11 -> 5
Cycle Number    4       :
9 -> 5 -> 14 -> 9
Cycle Number    5       :
9 -> 10 -> 11 -> 5 -> 14 -> 9
Cycle Number    6       :
12 -> 1 -> 10 -> 11 -> 12
Cycle Number    7       :
3 -> 15 -> 3
> g4 =   {  [1] = { {dst = 3}, {dst = 9}, },  [2] = { {dst = 12}, },  [3] = { {d
st = 12}, {dst = 13}, },  [4] = { },  [5] = { {dst = 8}, },  [6] = { },  [7] = {
 {dst = 13}, },  [8] = { {dst = 4}, {dst = 10}, },  [9] = { {dst = 7}, },  [10]
= { },  [11] = { {dst = 4}, {dst = 14}, },  [12] = { },  [13] = { {dst = 12}, {d
st = 14}, },  [14] = { {dst = 6}, {dst = 8}, },  [15] = { },  length = 15}
> has_cycle(g4)
This graph has no cycles.
> g5 = {   [1] = { {dst = 4}, },   [2] = { },   [3] = { {dst = 12}, },   [4] = {
 {dst = 2}, },   [5] = { },   [6] = { },   [7] = { {dst = 2}, },   [8] = { },
[9] = { {dst = 15}, },   [10] = { {dst = 2}, {dst = 4}, },   [11] = { {dst = 9},
 {dst = 15}, },   [12] = { {dst = 7}, },   [13] = { {dst = 4}, {dst = 6}, },   [
14] = { {dst = 3}, {dst = 12}, },   [15] = { },   length = 15}
> has_cycle(g5)
This graph has no cycles.
> g6 = {   [1] = { {dst = 2}, },   [2] = { {dst = 3}, {dst = 4} },   [3] = { {ds
t = 5}, },    [4] = { {dst = 3}, },    [5] = {},    length = 5 }
> has_cycle(g6)
This graph has no cycles.
> g7 = {   [1] = { {dst = 2}, },   [2] = { {dst = 3}, {dst = 4} },   [3] = { {ds
t = 5}, },    [4] = { {dst = 3}, },    [5] = {{dst = 4}},    length = 5 }
> has_cycle(g7)
This graph has cycles!
Cycle Number    1       :
4 -> 3 -> 5 -> 4
--]]
