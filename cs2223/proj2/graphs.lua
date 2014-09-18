module(..., package.seeall)

-- a *graph* in our representation is a table of the format:
--    {
--      { {dst = 2}, {dst = 3}, {dst = 5}, },
--      { {dst = 1}, {dst = 4} },
--      { {dst = 1}, {dst = 4}},
--      { {dst = 2}, {dst = 3} },
--      { {dst = 1}, {dst = 6}, {dst = 8}, },
--      { {dst = 5}, {dst = 7} },
--      { {dst = 6}, {dst = 8} },
--      { {dst = 5}, {dst = 7}},
--      length = 8
--    }

-- That is, it has an array of arrays, and field giving the length of
-- the (main) array.  Each entry in this main array represents one
-- node.  The information for that node is an array that contains
-- tables.  Each of these tables represents one edge.  It has a
-- destination, an integer which says which node the edge leads to.  
-- Graphs can have other information on the edges, too, which we will
-- use later.  

function make_graph(l) 
   local g = {} 
   g.length = l 
   for i = 1,l do g[i] = {} end 
   return g 
end 



function adj(g,n)  
   if 1<=n and n<=g.length 
   then 
      return g[n] 
   else 
      error(string.format("Node %d out of bounds for graph of length %d", 
                          n, g.length), 1)
   end
end

-- this function allows us to use the Lua syntax 
-- for n in graphs.nodes(g) do ... end 
-- to execute ... once on each one of the nodes of g.

function nodes(g) 
   local i = 0
   return function () 
             i = i+1; 
             if i<= g.length then return i end 
          end 
end 
   
-- this function allows us to use the Lua syntax 
-- for n in graphs.neighbors(g[u]) do ... end 
-- to execute ... once on each one of the neighbors
-- of u in g.

function neighbors(adj)
   local i = 0
   return 
   function () i = i+1; return adj[i] and adj[i].dst end 
end 

-- utility fn to print out a graph in a form that Lua will read back
-- to rebuild the same graph.  Call as print_graph(g) to print to the
-- standard output (such as the interactive loop).  
             
   
function print_graph(g,file)
   file = file or io.stdout 
   file:write("\n{\n")
   for i = 1,g.length do 
      if g[i] 
      then    
         file:write(string.format("  [%d] = {", i))
         for _,e in ipairs(g[i]) do 
            file:write(string.format(" {dst = %d},", e.dst))
         end 
         file:write(" },\n")
      else 
         file:write("  {},\n")
      end 
   end 
   file:write(string.format("  length = %d\n}\n", g.length))
end 

-- routines to generate random graphs... 

-- first, just choose a boolean, true with the given probability 

function random_boolean(prob) 
   local x = math.random() 
   return (x<= prob)
end

-- choose a random subset of the interval [1 .. ub] 
-- where each integer has probability prob of being in. 

function random_subset(ub, prob) 
   local result = {} 

   for i = 1,ub do 
      if random_boolean(prob)
      then 
         table.insert(result,i)
      end
   end
   return result 
end

-- Make a random directed graph with NODES many nodes, 
-- DENSITY proportion of the possible edges,
-- and a cost attribute, clustered around WEIGHT_CENTER
-- with range RANGE.  Leave WEIGHT_CENTER nil for no costs. 

function random (nodes, density,weight_center,range) 
   local g = make_graph(nodes) 

   local function make_weight () 
      -- write_dot() 
      return weight_center and range and 
         math.max(0, weight_center+((math.random()-.5)*range))
   end 

   local function choose_some_neighbors (i) 
      for _,j in ipairs(random_subset(nodes,density)) do 
         if j ~= i then 	-- dont make self edges. 
	    -- write_dot()
            g[i][#g[i]+1] = {dst = j, cost = make_weight()}
         end        
      end 
   end
   for i = 1,g.length do 
      choose_some_neighbors (i)
   end
   return g 
end 

-- Make a random UNdirected graph with NODES many nodes, 
-- DENSITY proportion of the possible edges,
-- and a cost attribute, clustered around WEIGHT_CENTER
-- with range RANGE.  Leave WEIGHT_CENTER nil for no costs. 


function random_undirected (nodes,density,weight_center,range) 
   local g = make_graph(nodes) 

   local function make_weight () 
      return weight_center and range and 
	 math.max(0, 
		  weight_center+((math.random()-.5)*range))
   end 

   local function choose_some_neighbors (i) 
      --      g[i] = {}          
      for _,j in ipairs(random_subset(nodes,density)) do 
         if j < i then 
            local w = make_weight()
            table.insert(g[i], {dst = j, cost = w })
            table.insert(g[j], {dst = i, cost = w })
         end        
      end 
   end
   for i = 1,g.length do 
      choose_some_neighbors (i)
   end
   return g 
end 

      