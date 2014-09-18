-- Project 3: Implementing a Securities Market
-- Tushar Narayan
-- tnarayan@wpi.edu

-- Heaps relative to the ordering of the comparison function
--

-- Representation:  The binary tree
-- is stored in an array.
-- Left and right children of object at index i
-- are stored at indices 2i and 2i + 1.
-- Parent is half child, rounding down (:-)

local function parent (i)
   if i>1
   then return math.floor(i/2)
   else return nil
   end
end

local function left_child (i)
   return i*2
end

local function right_child (i)
   return (i*2)+1
end

--[[

To make an empty heap, return a table.
There are no array entries,
so we simply set heap_bound to 0.

--]]


local function make_empty_heap(comparison_function)
   return { heap_bound = 0, compare = comparison_function }
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

local function heapify_up(h,i)
   local p = parent(i)

   if p and h.compare(h[i],h[p])           -- child too small!
   then
      -- flip em!
      h[p], h[i] =
	 h[i], h[p]
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

local function heapify_down (h,p)
   local l = left_child(p)
   local r = right_child(p)

   if h.heap_bound < l		-- childless parent?
   then return end		-- do nothing and return

   local f		    -- this will be the larger of the children

   if h.heap_bound < r		-- no right child at all?
      or h.compare(h[l],h[r])		-- or both exist but left is less
   then
      f = l			-- take l
   else
      f = r			-- otherwise use r
   end

   if  h.compare(h[f], h[p])		-- if favored child belongs on top
   then                         -- then flip em!
      h[f], h[p] = h[p], h[f]
      heapify_down (h,f)        -- recur down through f
   end
end




--[[

build_heap takes any array of numbers,
and also optionally a function for comparison.

build_heap initializes a heap using that
function. Thus, the root is the min element
relative to the given function.

We set heap_bound to the length of the array.

--]]

local function build_heap (a, cf)
   local h =  make_empty_heap(cf)

   for i = 1,#a do h[i]=a[i] end
   h.heap_bound = #a

   for i = math.ceil((#h)/2), 1, -1 do
      heapify_down(h,i)
   end
   return h
end

--[[

To insert a new element v into the
heap h, we increment the bound,
plug v into the new (last) spot,
and heapify_up to fix the heap
property.

--]]

local function insert(h,v)
   h.heap_bound =
      h.heap_bound+1
   h[h.heap_bound] = v
   heapify_up(h,h.heap_bound)
end

--[[

Just return the top of
the heap h, dont change
anything.

--]]

local function find_top(h)
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

local function delete(h,i)
   if h.heap_bound >= i
   then
      h[i] = h[h.heap_bound]

      -- not necessary,
      -- but why not clean up?
      h[h.heap_bound] = nil

      h.heap_bound = h.heap_bound-1
      heapify_down(h,i)
   else
      error("attempt to delete past end of heap",2)
   end
end

--[[

extract_top returns the
value of the top element
of the heap, and also deletes it.

--]]

local function extract_top(h)
   local v = find_top(h)
   delete(h,1)
   return v
end

-- predicate to test if
-- the heap h is empty

local function heap_empty(h)
   return h.heap_bound == 0
end

-- test procedure:
-- Does h have the heap property?

local function check_heap (h)
   if parent(h.heap_bound) then
      for p = 1,parent(h.heap_bound) do
         if h.compare(h[left_child(p)], h[p]) -- troubled family!
	 -- left child belongs above parent
         then
            error(string.format("check_heap failed at %d,%d\n", p, left_child(p)))
         else
            local r = right_child(p)
            if r <= h.heap_bound and
	       -- troubled family!
	       -- right child belongs above parent
               h.compare(h[r], h[p])
            then
               error(string.format("check_heap failed at %d,%d\n", p, r))
            end
         end
      end
   end
end

-- example client function:
--   heap_sort
-- Build a min-heap with the
-- entries in array a, then
-- put them back by extracting
-- them in order from the heap.


local function heap_sort (a)
   local h = build_heap(a)

   for i = 1,#a do
      a[i] = extract_top(h)
   end
end

heaps =
   {
   parent = parent,
   left_child = left_child,
   right_child = right_child,
   make_empty_heap = make_empty_heap,
   heapify_up = heapify_up,
   heapify_down = heapify_down,
   build_heap = build_heap,
   insert = insert,
   find_top = find_top,
   delete = delete,
   extract_top = extract_top,
   heap_empty = heap_empty,
   check_heap = check_heap,
   heap_sort = heap_sort
   }

return heaps
