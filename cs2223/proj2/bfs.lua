gr = require "graphs"
q = require "queues"

-- suppose that g is a graph 
-- and s is a node in it. 
-- bfs(g,s) then explores the 
-- graph g breadth-first 
-- starting from s.  

-- bfs_results is a table 
-- that will have info for node i
-- in bfs_results[i], if node i gets
-- discovered starting from s.  
-- The info contains the distance d and 
-- the parent p it was discovered from:
-- { dist = d, pi = p }

function bfs(g, s) 
   local bfs_q = q.new() 
   local bfs_results = {} 

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
	    q.enqueue(bfs_q,v)	-- Enqueue v to do later 
	 end 
      end 
   end 

   -- now that the utility fns are defined, 
   -- heres the main code:

   visit(nil,s) 		-- run the visit fn on s, no parent
   q.enqueue(bfs_q,s)		-- queue s up to get things going 
   while 
      not(q.empty(bfs_q))	-- while queue has elements 
   do
      do_node(q.dequeue(bfs_q)) -- do next
   end			
   return bfs_results
end 




