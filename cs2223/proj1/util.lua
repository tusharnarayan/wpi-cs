module(..., package.seeall)

--[[

Suppose that

1.  tab is a table, and
2.  fn is a function that can be applied to
    the value in each key,value pair stored
    in the table.

Then

        iterate_through_table(fn, tab)

returns a new table
with exactly the same keys as tab,
but in place of each value v,
it has fn(v) instead.

No side effects on tab.

--]]

function iterate_through_table(fn, tab)
   local result = {}
   for k,v in pairs(tab) do
      result[k] = fn(v)
   end
   return result
end

--[[

Suppose that fn2 is a function of two arguments, and tab1 and tab2 are
two tables.  Then iterate_through_two_tables will construct a table
which has an entry for key k iff tab1[k] and tab2[k] are well
defined.

The resulting table r has r[k] equal to fn(tab1[k], tab2[k]).

--]]

function iterate_through_two_tables(fn, tab1, tab2)
   local result = {}
   for k,v in pairs(tab1) do
      if tab2[k] ~= nil         -- check if non-nil
      then
         result[k] = fn(v,tab2[k])
      end
   end
   return result
end


--[[

The identity function returns any
argument v unchanged.

--]]

function identity(v)
   return v
end

--[[

If tab is a table, then copy_table(tab)
returns a copy of it.

That is, another table with exactly the
same key,value pairs.

--]]

function copy_table(tab)
   return iterate_through_table(identity, tab)
end

--[[

If  a is an array, then fold(fn, seed, a)
"folds" the two-argument function fn through a.

That means, it returns the value:

        fn(a[#a], (fn(a[#a-1], ...
                      fn(a[2],fn(a[1],seed)))))

Writing this another way, let

v_0 = seed
v_1 = fn(a[1], v_0)
v_2 = fn(a[2], v_1)

...

v_n = fn(a[n], v[n-1])

Then fold(fn, seed, a) = v_#a

--]]

function fold (fn,seed,a)
   local result = seed
   for i = 1, #a do
      result = fn(a[i], result)
   end
   return result
end

--[[

If tab is a table, then print_table
prints each key,value pair in tab
on a separate line, separated by
a comma and two spaces.

--]]

function print_table(tab)
   for k,v in pairs(tab) do
      print(k, ",  ", v)
   end
end

-- print out the entries of the array a
-- in order.  (An *array* is a table with
-- a sequence 1 ... n as the keys.)

function print_array (a)
   io.write("{")
   for i = 1, #a-1 do
      io.write(a[i], ", ")
   end
   if a[#a] ~= nil
   then io.write(a[#a], "}\n")
   else io.write("}\n")
   end
end

-- generate an array of length len where
-- each entry is an integer between 1 and
-- max_entry, chosen randomly.

function random_int_array (len, max_entry)
   local result = {}

   math.randomseed(os.time())   -- initialize random number gen
   local ignore = math.random(max_entry) -- discard first value

   for i = 1, len do
      result[i] = math.random(max_entry) -- take random number up to max_entry
   end
   return result
end

-- construct an array of the differences between the entries in the
-- given array, assumed to be an array of numbers.

-- Since each entry in the new array requires using two in the given
-- one, the new one is one shorter.

-- This is kind of like taking a derivative.

function derive (a)
   local result = {}
   for i = 1, #a-1 do
      result[i] = a[i+1] - a[i]
   end
   return result
end

-- sum the values in a numerical array

function sum (a)
   return fold(function (x,y) return (x+y) end,
               0,a)
end

-- write a dot on standard output.
-- Useful to keep track of progress
-- as some program youre debugging is running.

function write_dot()
   io.write("."); io.flush()
end


-- construct an array where each entry a[i] is
-- the ratio a1[i]/a2[i], where a1 and a2 are
-- the two arguments to the function

function array_ratios(a1,a2)
   return iterate_through_two_tables(
      function (x,y) return math.ceil(x/y) end,
      a1,a2)
end

--[[

factory to make objects with
one field called count and
three methods:

1.  incr which increments the count
    and returns true

2.  reset which rests the count to 0
    (and returns true)

3.  reveal which returns the count value.

If the factory returns an object obj of this kind,
as in

    obj = make_collector()

you can call its methods in the form

    obj.incr(), obj.reset(), obj.reveal()

--]]

function make_collector ()
   local count = 0 		-- the object state

   local function increment ()
      count = count + 1 	-- increment the state
      return true
   end

   local function reset ()
      count = 0 		-- reset to 0
      return true
   end

   local function reveal ()
      return count 		-- fess up!
   end

   return {		       -- return an object with these methods
      inc = increment,	       -- as fields
      reset = reset,
      reveal = reveal }
end

-- Call fn on its arg,
-- returning both the result and the time

function run_with_time (fn, arg)
   local t0 = os.clock()
   local count, value = fn(arg)
   local t1 = os.clock()

   return value, t1-t0, count
end

function run_with_time_and_collector(fn, arg, collector)
   collector.reset()
   local value, elapsed_time, counter = run_with_time(fn, arg)
   local count = collector.reveal()

   return value, elapsed_time, counter
end





