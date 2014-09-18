--Tushar Narayan
--tnarayan@wpi.edu
--Project 5 Part 1

require "util"

--[[

This is the constructor for dynamic
programs that depend only on one
argument.  It constructs a memo table,
and then it applies the given operator
o to cache entries in the memo table
when they are not yet present.  Repeated
calls for the same argument retrieve the
cached value directly from the memo table.

--]]

function recursively_memoize_oper(o)
   local memo_table = {}
   local function fn(arg)
      local cached = memo_table[arg]
      if cached then return cached
      else
	 local new_val = o(arg,fn)
	 memo_table[arg] = new_val
	 return new_val
      end
   end
   return fn
end

--[[


Given a sequence s, return an
operator that takes as its arguments
an integer i and an "approximation" g
to the recursive calls for the optimal value.

Look in dynamic.lua in this directory,
at the definition of weighted_interval_sched,
for an example of how to write a function
that returns an operator.

--]]

--[[

*Here* fill in a blank to define the recurrence relation
that your operator will have.  Use the instances in CLRS
as a guide for what this should be like.

--]]

--[[
Part 1: Maximum Non-adjacent Subsequence:

Question 1: Recurrence

The MNAS sum is the maximum of either:
1)the sum of all elements in the array upto that index i
and the knowledge extension operator keo for index (i - 2); or
2)the kep for index (i - 1)
max(sum[i] + kep(i - 2), kep(i - 1))
--]]

function mnas_oper(s)
   local function f(i,g)
	  --[[
		This code was based off the knowledge extension
		operator code for the function weighted_interval_sched
		in file dynamic.lua. The condition was changed to model
		the recurrence relation defined above.
	  --]]
		if (i < 1) then
			return 0
		else
			return math.max(s[i]+ g(i - 2), g(i - 1))
		end
	end
   return f
end

-- caller function for Question 2 of Part 1
function mnas_max(s)
   return recursively_memoize_oper(mnas_oper(s))(#s)
end

--[[
Now write a function that will print out a
subsequence that will achieve this maximum.
That means, you have to say which slots were
chosen, not just what sum they lead to.

You can do this with the same operator mnas_oper,
by using the idea on p 396 in the CLRS textbook.
You will also find examples in the solution-printing
routines in dynamic.lua and dynamic_lcs.lua.

Here, you want to construct and return a Lua
array that contains the entries you selected for the
maximum.
--]]

function mnas_seq(s)
	--array to store the sequence of numbers
	--used to generate the MNAS total.
	--reinitialized every time the function is called.
	sub_array = {}

	local f = recursively_memoize_oper(mnas_oper(s))

	--[[
		This local function code was modeled off of the
		mnas_oper function defined above.
	--]]
	local function solve(i) --i represents a counter
							--initially is set this to length of s
		if (i < 1) then
			return 0
		else
			if((s[i] + f(i - 2)) > f(i - 1)) then --LHS of the recurrence
				sub_array[#sub_array + 1] = f(i) - f(i - 2)
				return solve(i - 2) --solve the MNAS recursively, working
									--in the manner of dynamic programming
			else --RHS of the recurrence
				sub_array[#sub_array + 1] = f(i - 1) - f(i - 3)
				return solve(i - 3)
			end
		end
	end
	return solve
end

-- caller function for Question 3 of Part 1
-- based on the mnas_max function defined above
function mnas_max_seq(s)
   return recursively_memoize_oper(mnas_seq(s))(#s)
end

-- Question 4 of Part 1: testing the code on sequences s1 through s5;
-- and other self-invented sequences

s1 = {3,5,3,7,8,2,1,5,6}
s2 = {3,5,3,8,7,12,1,5,12}
s3 = {3,5,3,8,7,2,1,5,6,3,5,7,8,6}
s4 = {3,5,3,8,7,2,1,5,6,50,3,7,100}
s5 = {246, 216, 169, 42, 127, 49, 25, 233, 201, 25,
      48, 95, 229, 183, 290, 196, 104, 236, 201, 162}
s6 = {1, 2, 3, 4, 5, 6, 7}
s7 = {1, 3, 4, 5, 6, 7}
s8 = {1, 51, 3, 1, 100, 199, 3}
s9 = {-1, -2, -4, 10, 11, 15}
s10 = {-1, 1, 2, -2, 3, -3, -5, 10}
s11 = {-5, -6, -7, -8, -9, -10}
s12 = {0, 0, 0, 0, 0}
s13 = {0, -1, 0, 1}
s14 = {-1, 0, 1}
s15 = {0}
s16 = {}

-- Function to test both mnas_max and mnas_max_seq
function test_mnas()
	local function test_array(arr)
		sum_arr = mnas_max(arr)
		mnas_max_seq(arr)
		seq_arr = sub_array
		print ("The array being tested is:")
		print_array(arr)
		print ("The maximum non-adjacent subsequence sum is:")
		print(sum_arr)
		print ("The non-adjacent subsequence with the maximum sum is:")
		if(seq_arr[1] == nil) then
			print("nil")
		else
			util.print_table(seq_arr)
		end
		print()
	end

	print("Running tests on 16 integer arrays...\n")
	print("Please note that 0 is returned as a considered value if the element at a particular index is less than 1.")
	print()
	test_array(s1)
	test_array(s2)
	test_array(s3)
	test_array(s4)
	test_array(s5)
	test_array(s6)
	test_array(s7)
	test_array(s8)
	test_array(s9)
	test_array(s10)
	test_array(s11)
	test_array(s12)
	test_array(s13)
	test_array(s14)
	test_array(s15)
	test_array(s16)
end
--[[ Sample Test Run:
Commands used to test:
1) load file using -> require "max_nonadjacent"
2) run test wrapper using -> test_mnas()

Output:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "max_nonadjacent"
> test_mnas()
Running tests on 16 integer arrays...

Please note that 0 is returned as a considered value if the element at a particu
lar index is less than 1.

The array being tested is:
{3, 5, 3, 7, 8, 2, 1, 5, 6}
The maximum non-adjacent subsequence sum is:
21
The non-adjacent subsequence with the maximum sum is:
1       ,       6
2       ,       1
3       ,       8
4       ,       3
5       ,       3

The array being tested is:
{3, 5, 3, 8, 7, 12, 1, 5, 12}
The maximum non-adjacent subsequence sum is:
37
The non-adjacent subsequence with the maximum sum is:
1       ,       12
2       ,       12
3       ,       8
4       ,       5

The array being tested is:
{3, 5, 3, 8, 7, 2, 1, 5, 6, 3, 5, 7, 8, 6}
The maximum non-adjacent subsequence sum is:
36
The non-adjacent subsequence with the maximum sum is:
1       ,       6
2       ,       7
3       ,       3
4       ,       5
5       ,       2
6       ,       8
7       ,       5

The array being tested is:
{3, 5, 3, 8, 7, 2, 1, 5, 6, 50, 3, 7, 100}
The maximum non-adjacent subsequence sum is:
170
The non-adjacent subsequence with the maximum sum is:
1       ,       100
2       ,       50
3       ,       5
4       ,       2
5       ,       8
6       ,       5

The array being tested is:
{246, 216, 169, 42, 127, 49, 25, 233, 201, 25, 48, 95, 229, 183, 290, 196, 104,
236, 201, 162}
The maximum non-adjacent subsequence sum is:
1740
The non-adjacent subsequence with the maximum sum is:
1       ,       162
2       ,       236
3       ,       290
4       ,       229
5       ,       48
6       ,       233
7       ,       127
8       ,       169
9       ,       246

The array being tested is:
{1, 2, 3, 4, 5, 6, 7}
The maximum non-adjacent subsequence sum is:
16
The non-adjacent subsequence with the maximum sum is:
1       ,       7
2       ,       5
3       ,       3
4       ,       1

The array being tested is:
{1, 3, 4, 5, 6, 7}
The maximum non-adjacent subsequence sum is:
15
The non-adjacent subsequence with the maximum sum is:
1       ,       7
2       ,       5
3       ,       3

The array being tested is:
{1, 51, 3, 1, 100, 199, 3}
The maximum non-adjacent subsequence sum is:
251
The non-adjacent subsequence with the maximum sum is:
1       ,       199
2       ,       1
3       ,       51

The array being tested is:
{-1, -2, -4, 10, 11, 15}
The maximum non-adjacent subsequence sum is:
25
The non-adjacent subsequence with the maximum sum is:
1       ,       15
2       ,       10
3       ,       0

The array being tested is:
{-1, 1, 2, -2, 3, -3, -5, 10}
The maximum non-adjacent subsequence sum is:
15
The non-adjacent subsequence with the maximum sum is:
1       ,       10
2       ,       3
3       ,       2
4       ,       0

The array being tested is:
{-5, -6, -7, -8, -9, -10}
The maximum non-adjacent subsequence sum is:
0
The non-adjacent subsequence with the maximum sum is:
1       ,       0
2       ,       0

The array being tested is:
{0, 0, 0, 0, 0}
The maximum non-adjacent subsequence sum is:
0
The non-adjacent subsequence with the maximum sum is:
1       ,       0
2       ,       0

The array being tested is:
{0, -1, 0, 1}
The maximum non-adjacent subsequence sum is:
1
The non-adjacent subsequence with the maximum sum is:
1       ,       1
2       ,       0

The array being tested is:
{-1, 0, 1}
The maximum non-adjacent subsequence sum is:
1
The non-adjacent subsequence with the maximum sum is:
1       ,       1
2       ,       0

The array being tested is:
{0}
The maximum non-adjacent subsequence sum is:
0
The non-adjacent subsequence with the maximum sum is:
1       ,       0

The array being tested is:
{}
The maximum non-adjacent subsequence sum is:
0
The non-adjacent subsequence with the maximum sum is:
nil

--]]


-- Question 5 of Part 1: Iterative Solution

-- This time, instead of using the knowledge extension operator
-- directly, program it iteratively to fill in an array from left to
-- right.

function mnas_max_make_table_iter(s)
	local result = {}
	local function get_pos(elm)
		if(elm > 0) then return elm
		else return 0
		end
	end
   -- code to fill the entries of result left to right:
	if(#s == 0) then result[1] = 0
	elseif(#s == 1) then result[1] = get_pos(s[1])
	else
		result[1] = get_pos(s[1])
		if(s[2] > s[1]) then
			result[2] = get_pos(s[2])
		else
			result[2] = get_pos(s[1])
		end
		for i = 3, #s do
			if(result[i - 1] > (get_pos(s[i]) + result[i - 2])) then
				result[i] = result[i - 1]
			else
				result[i] = get_pos(s[i]) + result[i - 2]
			end
		end
	end

   --[[return mnas_max without using arrays:
   once done, modify to store appropriate values in result array
   (modified version shown above)

   loop through entire array, maintain two sums:
   -included_sum is the maximum sum including the previous element visited
   -excluded_sum is the maximum sum excluding the previous element visited

   excluded_sum will = max(prev_included_sum, prev_excluded_sum)
   included_sum will = current element + excluded_sum
   (excluded_sum must be taken into account since the elements must
   be adjacent, as per project description)

   -- code:

   local prev_included_sum = s[1]
   local prev_excluded_sum = 0
   local included_sum = prev_included_sum
   local excluded_sum = prev_excluded_sum

   for i = 2, #s do
	included_sum = excluded_sum + s[i]
	excluded_sum = math.max(prev_included_sum, prev_excluded_sum)
	prev_included_sum = included_sum
	prev_excluded_sum = excluded_sum
	print(included_sum, ",", excluded_sum)
   end

   return math.max(included, excluded)
	--]]
   return result

end

function print_array (a)
	io.write("{")
	if(#a > 0) then
		for i = 1, #a-1 do
			io.write(a[i], ", ");
		end;
		io.write(a[#a], "}\n")
	else
		io.write("}\n")
	end
end

function test_mnas_max_iter()
	local function test_iter(arr)
		result_max = mnas_max_make_table_iter(arr)
		print ("The array being tested is:")
		print_array(arr)
		print ("The maxima for successive indexes is:")
		util.print_table(result_max)
		print("Thus, the maximum subsequence sum is:", result_max[#result_max])
		print()
	end

	print("Running tests on 16 integer arrays...\n")
	print("Please note that 0 is returned as a considered value if the element at a particular index is less than 1.")
	print()
	test_iter(s1)
	test_iter(s2)
	test_iter(s3)
	test_iter(s4)
	test_iter(s5)
	test_iter(s6)
	test_iter(s7)
	test_iter(s8)
	test_iter(s9)
	test_iter(s10)
	test_iter(s11)
	test_iter(s12)
	test_iter(s13)
	test_iter(s14)
	test_iter(s15)
	test_iter(s16)
end

--[[ Sample Test Run:
Commands used to test:
1) load file using -> require "max_nonadjacent"
2) run test wrapper using -> test_mnas_max_iter()

Output:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "max_nonadjacent"
> test_mnas_max_iter()
Running tests on 16 integer arrays...

Please note that 0 is returned as a considered value if the element at a particu
lar index is less than 1.

The array being tested is:
{3, 5, 3, 7, 8, 2, 1, 5, 6}
The maxima for successive indexes is:
1       ,       3
2       ,       5
3       ,       6
4       ,       12
5       ,       14
6       ,       14
7       ,       15
8       ,       19
9       ,       21
Thus, the maximum subsequence sum is:   21

The array being tested is:
{3, 5, 3, 8, 7, 12, 1, 5, 12}
The maxima for successive indexes is:
1       ,       3
2       ,       5
3       ,       6
4       ,       13
5       ,       13
6       ,       25
7       ,       25
8       ,       30
9       ,       37
Thus, the maximum subsequence sum is:   37

The array being tested is:
{3, 5, 3, 8, 7, 2, 1, 5, 6, 3, 5, 7, 8, 6}
The maxima for successive indexes is:
1       ,       3
2       ,       5
3       ,       6
4       ,       13
5       ,       13
6       ,       15
7       ,       15
8       ,       20
9       ,       21
10      ,       23
11      ,       26
12      ,       30
13      ,       34
14      ,       36
Thus, the maximum subsequence sum is:   36

The array being tested is:
{3, 5, 3, 8, 7, 2, 1, 5, 6, 50, 3, 7, 100}
The maxima for successive indexes is:
1       ,       3
2       ,       5
3       ,       6
4       ,       13
5       ,       13
6       ,       15
7       ,       15
8       ,       20
9       ,       21
10      ,       70
11      ,       70
12      ,       77
13      ,       170
Thus, the maximum subsequence sum is:   170

The array being tested is:
{246, 216, 169, 42, 127, 49, 25, 233, 201, 25, 48, 95, 229, 183, 290, 196, 104,
236, 201, 162}
The maxima for successive indexes is:
1       ,       246
2       ,       246
3       ,       415
4       ,       415
5       ,       542
6       ,       542
7       ,       567
8       ,       775
9       ,       775
10      ,       800
11      ,       823
12      ,       895
13      ,       1052
14      ,       1078
15      ,       1342
16      ,       1342
17      ,       1446
18      ,       1578
19      ,       1647
20      ,       1740
Thus, the maximum subsequence sum is:   1740

The array being tested is:
{1, 2, 3, 4, 5, 6, 7}
The maxima for successive indexes is:
1       ,       1
2       ,       2
3       ,       4
4       ,       6
5       ,       9
6       ,       12
7       ,       16
Thus, the maximum subsequence sum is:   16

The array being tested is:
{1, 3, 4, 5, 6, 7}
The maxima for successive indexes is:
1       ,       1
2       ,       3
3       ,       5
4       ,       8
5       ,       11
6       ,       15
Thus, the maximum subsequence sum is:   15

The array being tested is:
{1, 51, 3, 1, 100, 199, 3}
The maxima for successive indexes is:
1       ,       1
2       ,       51
3       ,       51
4       ,       52
5       ,       151
6       ,       251
7       ,       251
Thus, the maximum subsequence sum is:   251

The array being tested is:
{-1, -2, -4, 10, 11, 15}
The maxima for successive indexes is:
1       ,       0
2       ,       0
3       ,       0
4       ,       10
5       ,       11
6       ,       25
Thus, the maximum subsequence sum is:   25

The array being tested is:
{-1, 1, 2, -2, 3, -3, -5, 10}
The maxima for successive indexes is:
1       ,       0
2       ,       1
3       ,       2
4       ,       2
5       ,       5
6       ,       5
7       ,       5
8       ,       15
Thus, the maximum subsequence sum is:   15

The array being tested is:
{-5, -6, -7, -8, -9, -10}
The maxima for successive indexes is:
1       ,       0
2       ,       0
3       ,       0
4       ,       0
5       ,       0
6       ,       0
Thus, the maximum subsequence sum is:   0

The array being tested is:
{0, 0, 0, 0, 0}
The maxima for successive indexes is:
1       ,       0
2       ,       0
3       ,       0
4       ,       0
5       ,       0
Thus, the maximum subsequence sum is:   0

The array being tested is:
{0, -1, 0, 1}
The maxima for successive indexes is:
1       ,       0
2       ,       0
3       ,       0
4       ,       1
Thus, the maximum subsequence sum is:   1

The array being tested is:
{-1, 0, 1}
The maxima for successive indexes is:
1       ,       0
2       ,       0
3       ,       1
Thus, the maximum subsequence sum is:   1

The array being tested is:
{0}
The maxima for successive indexes is:
1       ,       0
Thus, the maximum subsequence sum is:   0

The array being tested is:
{}
The maxima for successive indexes is:
1       ,       0
Thus, the maximum subsequence sum is:   0

--]]

-- Question 6 of Part 1: Iterative Solution with Sequence
-- recomputing the sequence of indices used to generate sum
function mnas_max_seq_iter(s)
	local function get_pos(elm)
		if (elm > 0) then return elm
		else return 0
		end
	end

	local result_index_array = {} --array that stores the index of elements used
	local result_element_array = {} --array that stores the actual elements used
	local memo_table = {} --array that is used to memoize values during computation

	if(#s == 0) then
		result_index_array[1] = nil
		result_element_array[1] = 0
	elseif(#s == 1) then
		result_index_array[1] = 1
		result_element_array[1] = get_pos(s[1])
	else
		--handling the special cases again
		--Note: special cases are caused due to the indexing of array elements
		memo_table[1] = {get_pos(s[1]), {1}, {get_pos(s[1])}}
		if(s[2] > s[1]) then
			memo_table[2] = {get_pos(s[2]), {2}, {get_pos(s[2])}}
		else
			memo_table[2] = {get_pos(s[1]), {1}, {get_pos(s[1])}}
		--the s[2] == s[1] condition is implicitly taken care of, since either s[2]
		--or s[1] can be stored in the memo_table and the answer will be correct,
		--we store s[1]
		end
		for i = 3, #s do
			if ((get_pos(s[i]) + memo_table[i - 2][1]) > memo_table[i - 1][1]) then
				result_index_array = util.copy_table(memo_table[i - 2][2])
				result_element_array = util.copy_table(memo_table[i - 2][3])
				result_index_array[#result_index_array + 1] = i
				result_element_array[#result_element_array + 1] = get_pos(s[i])
				--memoize the better solution
				memo_table[i] = {(get_pos(s[i]) + memo_table[i - 2][1]), result_index_array, result_element_array}
			else
				memo_table[i] = memo_table[i - 1]
			end
		end
	end
	return result_index_array, result_element_array
end

function test_mnas_max_iter_seq()
	local function test_iter_seq(arr)
		local added_sum = 0
		result_index_array, result_element_array = mnas_max_seq_iter(arr)
		print ("The array being tested is:")
		print_array(arr)
		print ("\t\tIndex Chosen:\t\tElement Chosen\t")
		if(#result_index_array > 0) then
			for i = 1, #result_index_array do
				print(i, "\t", result_index_array[i], "\t", result_element_array[i])
				added_sum = added_sum + result_element_array[i]
			end
		else
			print(1, "\t", nil, "\t", 0)
		end
		print("Summing up the elements, MNAS sum is:", added_sum)
		func_sum = mnas_max_make_table_iter(arr)
		print("From the mnas_max_make_table_iter function, MNAS sum is:", func_sum[#func_sum])
		print()
	end

	print("Running tests on 16 integer arrays...\n")
	print("Please note that 0 is returned as a considered value if the element at a particular index is less than 1.")
	print()
	test_iter_seq(s1)
	test_iter_seq(s2)
	test_iter_seq(s3)
	test_iter_seq(s4)
	test_iter_seq(s5)
	test_iter_seq(s6)
	test_iter_seq(s7)
	test_iter_seq(s8)
	test_iter_seq(s9)
	test_iter_seq(s10)
	test_iter_seq(s11)
	test_iter_seq(s12)
	test_iter_seq(s13)
	test_iter_seq(s14)
	test_iter_seq(s15)
	test_iter_seq(s16)
end


--[[ Sample Test Run:
Commands used to test:
1) load file using -> require "max_nonadjacent"
2) run test wrapper using -> test_mnas_max_iter_seq()

Output:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "max_nonadjacent"
> test_mnas_max_iter_seq()
Running tests on 16 integer arrays...

Please note that 0 is returned as a considered value if the element at a particu
lar index is less than 1.

The array being tested is:
{3, 5, 3, 7, 8, 2, 1, 5, 6}
                Index Chosen:           Element Chosen
1                       1                       3
2                       3                       3
3                       5                       8
4                       7                       1
5                       9                       6
Summing up the elements, MNAS sum is:   21
From the mnas_max_make_table_iter function, MNAS sum is:        21

The array being tested is:
{3, 5, 3, 8, 7, 12, 1, 5, 12}
                Index Chosen:           Element Chosen
1                       2                       5
2                       4                       8
3                       6                       12
4                       9                       12
Summing up the elements, MNAS sum is:   37
From the mnas_max_make_table_iter function, MNAS sum is:        37

The array being tested is:
{3, 5, 3, 8, 7, 2, 1, 5, 6, 3, 5, 7, 8, 6}
                Index Chosen:           Element Chosen
1                       2                       5
2                       4                       8
3                       6                       2
4                       8                       5
5                       10                      3
6                       12                      7
7                       14                      6
Summing up the elements, MNAS sum is:   36
From the mnas_max_make_table_iter function, MNAS sum is:        36

The array being tested is:
{3, 5, 3, 8, 7, 2, 1, 5, 6, 50, 3, 7, 100}
                Index Chosen:           Element Chosen
1                       2                       5
2                       4                       8
3                       6                       2
4                       8                       5
5                       10                      50
6                       13                      100
Summing up the elements, MNAS sum is:   170
From the mnas_max_make_table_iter function, MNAS sum is:        170

The array being tested is:
{246, 216, 169, 42, 127, 49, 25, 233, 201, 25, 48, 95, 229, 183, 290, 196, 104,
236, 201, 162}
                Index Chosen:           Element Chosen
1                       1                       246
2                       3                       169
3                       5                       127
4                       8                       233
5                       11                      48
6                       13                      229
7                       15                      290
8                       18                      236
9                       20                      162
Summing up the elements, MNAS sum is:   1740
From the mnas_max_make_table_iter function, MNAS sum is:        1740

The array being tested is:
{1, 2, 3, 4, 5, 6, 7}
                Index Chosen:           Element Chosen
1                       1                       1
2                       3                       3
3                       5                       5
4                       7                       7
Summing up the elements, MNAS sum is:   16
From the mnas_max_make_table_iter function, MNAS sum is:        16

The array being tested is:
{1, 3, 4, 5, 6, 7}
                Index Chosen:           Element Chosen
1                       2                       3
2                       4                       5
3                       6                       7
Summing up the elements, MNAS sum is:   15
From the mnas_max_make_table_iter function, MNAS sum is:        15

The array being tested is:
{1, 51, 3, 1, 100, 199, 3}
                Index Chosen:           Element Chosen
1                       2                       51
2                       4                       1
3                       6                       199
Summing up the elements, MNAS sum is:   251
From the mnas_max_make_table_iter function, MNAS sum is:        251

The array being tested is:
{-1, -2, -4, 10, 11, 15}
                Index Chosen:           Element Chosen
1                       1                       0
2                       4                       10
3                       6                       15
Summing up the elements, MNAS sum is:   25
From the mnas_max_make_table_iter function, MNAS sum is:        25

The array being tested is:
{-1, 1, 2, -2, 3, -3, -5, 10}
                Index Chosen:           Element Chosen
1                       1                       0
2                       3                       2
3                       5                       3
4                       8                       10
Summing up the elements, MNAS sum is:   15
From the mnas_max_make_table_iter function, MNAS sum is:        15

The array being tested is:
{-5, -6, -7, -8, -9, -10}
                Index Chosen:           Element Chosen
1                       nil                     0
Summing up the elements, MNAS sum is:   0
From the mnas_max_make_table_iter function, MNAS sum is:        0

The array being tested is:
{0, 0, 0, 0, 0}
                Index Chosen:           Element Chosen
1                       nil                     0
Summing up the elements, MNAS sum is:   0
From the mnas_max_make_table_iter function, MNAS sum is:        0

The array being tested is:
{0, -1, 0, 1}
                Index Chosen:           Element Chosen
1                       1                       0
2                       4                       1
Summing up the elements, MNAS sum is:   1
From the mnas_max_make_table_iter function, MNAS sum is:        1

The array being tested is:
{-1, 0, 1}
                Index Chosen:           Element Chosen
1                       1                       0
2                       3                       1
Summing up the elements, MNAS sum is:   1
From the mnas_max_make_table_iter function, MNAS sum is:        1

The array being tested is:
{0}
                Index Chosen:           Element Chosen
1                       1                       0
Summing up the elements, MNAS sum is:   0
From the mnas_max_make_table_iter function, MNAS sum is:        0

The array being tested is:
{}
                Index Chosen:           Element Chosen
1                       nil                     0
Summing up the elements, MNAS sum is:   0
From the mnas_max_make_table_iter function, MNAS sum is:        0

--]]
