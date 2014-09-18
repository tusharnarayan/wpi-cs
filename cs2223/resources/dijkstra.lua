gr=require "graphs" 
dofile "pq3.lua"

-- An auxiliary to make an array that 
-- you can use to initialize a heap 
-- with all the nodes in a graph g 

function node_array(g) 
   result = {} 
   for n in gr.nodes(g) do 
      result[#result+1] = n 
   end 
   return result 
end 


 

function dijkstra (g,r) 
   -- table of shortest known dists
   local known = {} 		
   -- pi[node] will be its parent on shortest route
   local pi = {} 		

   -- dist 0 to starting point 
   known[r] = 0			

   local q =    
      build_heap(
      node_array(g), 		-- all nodes go into q
      function(d1,d2) 
	 if known[d1] and known[d2] 
	 then 
	    return known[d1] < known[d2] -- shorter path? 
	 else 
	    return known[d1]	-- any path? 
	 end 
      end)

      -- known but unstabilized routes use stabilized nodes, 
      -- followed by *one* edge outside stabilized region

   while not(heap_empty(q)) do 
      local u = extract_top(q) 
      -- EITHER 
      --  u has shortest known route
      -- OR
      --  no route known to *any* node in q

      if known[u] 		-- some route r ->*  u 
      then 
         local u_dist = known[u] 
         for e in gr.edges(g[u]) do 
            local v = e.dst
            local c = e.cost 
            if (heap_member(q, v) 
             and (not(known[v]) or 
               -- instead test whether 
               -- dist(r,u) + c < current estimate for v  
               u_dist+c < known[v]))
            then 
               pi[v] = u
               known[v] = u_dist+c -- always remember total dist est 
               update_priority(q,v)
            end 
         end 
      end 
   end 
   return known,pi 
end 


      