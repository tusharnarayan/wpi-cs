-- Heaps relative to an ordering 
-- by default < (min-heaps) 
-- or whatever comparison predicate 
-- passed in to make_empty heap 

-- Representation:  binary tree 
-- is stored in an array.  
-- Left and right children of object at index i 
-- are stored at indices 2i and 2i + 1. 
-- Parent is half child, rounding down (:-) 

function parent (i) 
   if i>1
   then return math.floor(i/2) 
   else return nil
   end
end
   
function left_child (i)
   return i*2
end 

function right_child (i)
   return (i*2)+1 
end 

--[[

To make an empty heap, return a table. 
There are no array entries, 
so we simply set heap_bound to 0. 
The preference function is either 
the argument passed in, pred, 
or if none is passed (so pred is nil) 
use the default function that 
returns the result of <.  

We also equip it with an update fn 
taking the value v to possibly heapify up 
a parameter.    This can be used when the 
priority of the element has changed, assuming
we *only* change priorities to move v toward 
the top of the heap.  

The update fn finds v -- if v is at any location 
in h --  and heapifies up as necessary.  
This works only if v is at *just one* location in h.  

To do this, the heap also contains a 
location table, where the keys are *values* 
v stored in the heap, and the value
is the index at which v appears in 
the hash table.  

--]]


function make_empty_heap(pred)
   return { heap_bound = 0,  
            pref = pred
               or function (a,b) return a<b end, 
            locations = {} 
         } 
end

--[[

heapify_up(h,i) takes an almost-heap 
h, that is, an array in which for any 
*other* index j where j not= i, 
h[j] belongs below its parent. 

If h[i] belongs *above* its parent, 
then heapify_up does this interchange, 
and then continues to
heapify_up(h,parent(i)).  

--]]

function heapify_up(h,i)
   local p = parent(i) 
   if p and h.pref(h[i],h[p])           -- child too small!  
   then 
      -- flip em!
      h[p], h[i] = h[i], h[p]

      -- also update the location table 
      h.locations[h[p]] = p 
      h.locations[h[i]] = i

      heapify_up(h,p)
   end 
end


--[[

heapify_down takes a broken heap and 
takes one step to repair it.  In particular, 
its arguments are an array a and an index 
i, such that: 

1.  the left and right subtrees dominated by i 
    are already heaps; 

2.  a[i] belongs below its parent (or it is the root).  

If a[i] is less than either of its children, 
heapify_down flips it with the larger of the 
two children.  It recursively repairs any 
damage this may have caused to the heap property 
of the child.  

--]]

function heapify_down (h,p) 
   local l = left_child(p)
   local r = right_child(p)
   local f = nil 

   -- a child thats defined and
   -- not greater than the other 

   if h.heap_bound == l
   then 
      f = l                     -- just l defined, so take it 
   else if h.heap_bound>=r      -- both defined 
      then 
         if h.pref(h[l],h[r])   -- if l is less
         then 
            f = l               -- take l 
         else 
            f = r               -- otherwise l
         end 
      end 
   end 

   if f and h.pref(h[f],h[p])   -- if favored child belongs on top 
   then                         -- then flip em! 
      h[f], h[p] = h[p], h[f]

      -- also update the location table  
      h.locations[h[p]] = p 
      h.locations[h[f]] = f

      -- recur down through f 
      heapify_down (h,f)   
   end
end  

--[[

build_heap takes any array of numbers,  
and also optionally a function for comparison.  

build_heap initializes a heap using that 
function, or the default function <.  
Thus, the root is the min element
relative to < or the given function.  

We set heap_bound to the length of the array.  

--]]

function build_heap (a, pred) 
   local h =  make_empty_heap(pred) 

   for i = 1,#a do 
      h[i]=a[i] 
      h.locations[a[i]] = i
   end 
   h.heap_bound = #a

   for i = math.ceil((#h)/2), 1, -1 do
      heapify_down(h,i) 
   end
   --   check_heap(h)
   return h
end

--[[ 

To insert a new element v into the 
heap h, we increment the bound,
plug v into the new (last) spot, 
and heapify_up to fix the heap 
property.  

--]]

function insert(h,v) 
   h.heap_bound = 
      h.heap_bound+1
   h[h.heap_bound] = v 

   -- also update the location table 
   h.locations[v] = h.heap_bound
 
   heapify_up(h,h.heap_bound)
   --    check_heap(h)
end 

--[[

heap_member returns true if v has a 
location in h, and false otherwise 

--]]

function heap_member(h,v) 
   if h.locations[v] 
   then 
      return true 
   else 
      return false 
   end 
end 

--[[ 

To update the heap when a value priority 
changes (making it possibly more urgent) 
we consult the location table to find its 
place in the heap, and  heapify up. 

--]]

function update_priority (h,v) 
   local i = h.locations[v]
   if i 
   then 
      heapify_up(h,i) 
   end 
end 

--[[

update_or_insert will insert a 
new value into the heap, if it is 
not already there.  However, if it 
is already there, it does an update_priority
to heapify this value up if its priority 
has improved.  

--]]


function update_or_insert (h,v) 
   if h.locations[v] 
   then 
      update_priority(h,v) 
   else 
      insert(h,v)
   end 
end 
      


--[[

Just return the top of 
the heap h, dont change 
anything.   

--]]

function find_top(h) 
   return h[1]
end 

--[[

Delete the value at location i
from the heap h.  

In real life, almost always used
with i = 1 to delete from the top 
of the heap.  

If the heap is too small, fail.  
Otherwise, put the *last* 
value in the heap into slot i, 
decrement the heap bound, 
and then heapify down to get it 
where it belongs.  

--]]

function delete(h,i) 
   if h.heap_bound >= i 
   then 
      -- first update the location table 
      h.locations[h[i]] = nil 

      h[i] = h[h.heap_bound]
      h.locations[h[i]] = i

      h[h.heap_bound] = nil

      h.heap_bound = h.heap_bound-1
      heapify_down(h,i) 
      --      check_heap(h)
   else 
      error("attempt to delete past end of heap",2) 
   end 
end 

--[[

Delete_value uses the location table to
find v and then calls delete.  

--]]

function delete_value(h,v) 
   local i = h.locations[v] 
   if i then delete(h,i) end 
end 

--[[ 

extract_top returns the 
value of the top element 
of the heap, and also deletes it.

--]]

function extract_top(h) 
   local v = find_top(h) 
   delete(h,1) 
   return v 
end 

-- predicate to test if 
-- the heap h is empty 

function heap_empty(h) 
   return h.heap_bound < 1
end 

-- test procedure:  
-- Does h have the heap property? 

function check_heap (h) 
   if parent(h.heap_bound) then 
      for p = 1,parent(h.heap_bound) do 
         if h.pref(h[left_child(p)],h[p])        -- troubled family! 
         then 
            error(string.format("check_heap failed at %d,%d\nwith values %d,%d",
                                p, left_child(p), h[p], h[left_child(p)]))
         else 
            local r = right_child(p) 
            if r <= h.heap_bound and 
               h.pref(h[r],h[p])
            then 
               error(string.format("check_heap failed at %d,%d\n", p, r))
            end 
         end 
      end 
      for i = 1,h.heap_bound do 
         if h.locations[h[i]] ~= i 
         then 
            error(string.format("check_heap failed for loc table at %d\nwith value %d, expected at %d",
                                i, h[i], h.locations[h[i]]))
         end 
      end 
   end 
end 


function heap_sort (a, pred) 
   local h = build_heap(a, pred) 

   for i = 1,#a do 
      a[i] = extract_top(h) 
   end 
end 



 
