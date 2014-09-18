module(..., package.seeall) 

-- we represent a queue as an array together
-- with two indexes, fst and lst.  q[q.fst]
-- is the first entry in the queue q, and
-- q[q.lst] is the last.  We just keep
-- growing the array in this version.  We
-- don't bother to "wrap around" as CLRS
-- describes.  

-- A new array has nothing in the array, and
-- lst is smaller than fst.

function new() 
   return { fst = 1, lst = 0} 
end

-- Whenever q is empty, its lst is below its
-- fst.  

function empty (q) 
   return q.lst < q.fst
end 

-- To enqueue, we increment lst and put the
-- new entry at that position.  

function enqueue(q,v) 
   q.lst = q.lst+1 
   q[q.lst] = v
end 

-- To dequeue, we return the entry at the
-- index fst, incrementing fst.  Returns nil
-- when q is empty.  

function dequeue(q) 
   if q.fst <= q.lst 
   then 
      local v = q[q.fst] 
      q.fst=q.fst+1 
      return v 
   end 
end

