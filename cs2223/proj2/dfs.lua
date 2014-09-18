require "util"
gr = require "graphs"

-- suppose that g is a graph. 
-- dfs(g) explores the whole
-- graph g depth-first.  

-- dfs_results is a table 
-- that will have info for every node u
-- in dfs_results[u].    
-- The info contains the number of the 
-- step at which u was found,  
-- the parent p it was found from, 
-- and the number of the step when 
-- execution was finished with u and 
-- everything found from u:
-- { found = t0, pi = p, finished = t1 }


function dfs(g) 
   local dfs_results = {} 
   local step_number = 1 
   local function step() 
      local now = step_number
      step_number = step_number+1
      return now 
   end 

   local function start_visit(parent, v) 
      -- v is new, so 
      -- install its dfs result info
      dfs_results[v] = {	
	 found = step(), 
	 pi = parent }
   end 

   local function end_visit(u)
      dfs_results[u].finish = step()
   end 


   local function do_node(u) 
      for v in graphs.neighbors(g[u]) do 
	 -- been there, done that? 
         if not(dfs_results[v]) 
	 then
	    start_visit(u,v)
	    -- immediately explore from v
	    do_node(v) 	
	    end_visit (v)	
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
         do_node(u)
	 end_visit(u)
      end 
   end 
   return dfs_results 
end 


function check_parens(g,r)
   for u in graphs.nodes(g) do 
      for v in graphs.nodes(g) do 
	 if r[u].found < r[v].found and 
	    r[v].found < r[u].finish and 
	    r[u].finish <  r[v].finish 
	 then return false, u, v
	 end 
      end
   end
   return true
end 

