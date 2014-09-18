require "util"

-- set this demo_print flag to true to cause
-- procedures to
-- print results *every* time through.
-- They will also wait for some input; press <return>.
-- This causes a *lot* of output on big runs.

demo_print = false

--[[

*** BUBBLE SORT command ***

When applied to a given array { 4, 3, 5, ...}, it repeatedly bubbles
out-of-order elements toward their correct positions, ending when
there are no more out-of-order pairs.

Note:  This procedure will permanently change the order of entries in
the array.  Copy the array before giving it if you want to keep the
original!

--]]


function bubble_sort (a)
   local bubble_comparisons_counter = util.make_collector()
   local a_length = #a		-- Lua notation for array length is #
   local still_active = true 	-- flag to decide when to stop

   while still_active do
      still_active = false 	-- will any work be done this time?

      for i = 1, a_length-1 do
	  bubble_comparisons_counter.inc()
	 if a[i+1]<a[i] 	-- Is this pair out of order?
	 then
	    -- Yes, you can swap values like this in Lua:
	    a[i], a[i+1] =
	       a[i+1], a[i]

	    still_active = true	-- Did work, so dont stop yet!
	 end
      end
      if demo_print then util.print_array(a); io.read() end
   end
   local num_comparisons = bubble_comparisons_counter.reveal()
   return num_comparisons, a
end


--[[

*** insertion sort command ***
   insertion_sort

for each slot in the array given, we place the value there in the
right position relative to all the values in earlier slots.

Note:  This procedure will permanently change the order of entries in
the array.  Copy the array before giving it if you want to keep the
original!

--]]

function insertion_sort(a)
   local insertion_comparisons_counter = util.make_collector()

   for i = 2, #a do 		-- the target for each step will be a[i]
      local entry = a[i]

	 -- the sorted part at any time
	 -- is a[1] .. a[i-1].

      for j = i-1, 0, -1 do 	-- count down from position i-1

	 -- we will insert the target in the right spot,
	 -- and slide the part above that up.

	insertion_comparisons_counter.inc()
	 if j == 0 or entry >= a[j]
	 then 			-- put the entry above a[j]
	    a[j+1] = entry
	    break 		-- bail out of rest of loop "for j"
	 else
	    -- slide this a[j] up to the next position
	    a[j+1] = a[j]
	 end
      end
      if demo_print then util.print_array(a); io.read() end
   end
   local num_comparisons = insertion_comparisons_counter.reveal()
   return num_comparisons, a
end

--[[
***   merge sort  ***

heres an implementation of merge sort,
organized as three functions.

the first is a utility function to do copying.

the second merges two already sorted arrays.

the third does the wishful thinking, namely
it applies itself recursively to the two halves
of its argument, and merges the results for the
two halves to build the full array.

--]]


-- copy from src to target
-- from lower to upper *inclusive*.

-- return the max entry found, and the index
-- for a slot to place an upper bound
-- to serve as a sentinel.

merge_comparisons_counter = util.make_collector()

function copy_range_with_slot(src, lower, upper, target)
   local max = src[lower]

   for i = 0, upper-lower do	-- loop will run upper-lower+1 times
      local entry = src[i+lower] -- next entry
      target[i+1] = entry	 -- copy it
      max = math.max(max, entry) -- update max
   end
   return max, upper-lower+2	-- the latter is the first unused slot
end

--[[

merge:

assume that a is an array,
and the entries from lower to mid are
already in order,
and the entries from mid+1 to upper are
already in order.

modify the entries in a so that
they are all ordered between lower and upper.

that is, make sure the entries in
the lower part go in the right spots
versus the entries in the upper part.

--]]



function merge_into_a(a, lower, mid, upper, spare1, spare2)
   local max = a[lower]

   -- first copy contents to spare arrays

   local max1, slot1 =
      copy_range_with_slot(a, lower, mid, spare1)
   local max2, slot2 =
      copy_range_with_slot(a, mid+1, upper, spare2)

   -- fill in both sentinels, greater than any real entry

   spare1[slot1] = math.max(max1,max2)+1
   spare2[slot2] = math.max(max1,max2)+1

   local j, k= 1, 1

   for i = lower, upper do
	merge_comparisons_counter.inc()
      if spare1[j]<spare2[k] 	-- use smaller value
      then
	 a[i] = spare1[j]
	 j = j+1 		-- increment index in array used
      else
	 a[i] = spare2[k]
	 k = k+1
      end
   end
   if demo_print then util.print_array(a); print(lower, upper); io.read() end
end

-- merge_sort(a)
-- splits the array a unless it is of length 0,1
-- and recursively merge_sorts each half
-- then it uses merge to combine the sorted halves.


function merge_sort(a, lower, upper, spare1, spare2)
   if upper<=lower then return end

   local mid = math.floor((lower+upper) / 2)

   merge_sort(a, lower, mid,	-- sort lower half recursively
      spare1, spare2)
   merge_sort(a, mid+1, upper, 	-- sort upper half recursively
      spare1, spare2)
	  --spot?
   merge_into_a(a, lower, mid, upper, -- merge the two sorted halves
		spare1, spare2)
end

--[[

Top level entry to merge sort.

Note:  This procedure will permanently change the order of entries in
the array.  Copy the array before giving it if you want to keep the
original!

--]]


function ms_top(a)
   merge_sort(a,1,#a,		-- sort the whole array
	      {},{})		-- with new empty tables as spare space
   local num_comparisons = merge_comparisons_counter.reveal()
   return num_comparisons
end

-- Project 1 Activities Code
-- Tushar Narayan
-- tnarayan@wpi.edu

-- Part 1

--[[

Utility Function 1

is_sorted_array(a)

Takes an array a and checks to see if it is sorted.
If array is entirely sorted, returns true.
If any two elements are in the wrong order, returns false.
Note: This procedure does not modify the array, just iterates over it.

--]]


function is_sorted_array(a)
	local a_length = #a
	--flag used to indicate whether the array is sorted
	--assume array is sorted when starting out
	--if any two elements are in the wrong order, set flag to false
	local sort_flag = true

	for i = 1, a_length-1 do
		if a[i+1]<a[i] --pair is out of order!
		then
			sort_flag = false
			return sort_flag
		end
	end
	return sort_flag --reaching this point means array was properly sorted
end

--[[
1)Using a random unsorted array, then using a defined sorted array
and testing the is_sorted_array function on both

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj1"
>
>
> a = util.random_int_array(10, 100)
> util.print_array(a)
{61, 40, 43, 36, 32, 48, 61, 61, 33, 90}
> is_a_sorted = is_sorted_array(a)
> print(is_a_sorted)
false
>
>
> b = {1, 2, 3, 4, 5}
> util.print_array(b)
{1, 2, 3, 4, 5}
> is_b_sorted = is_sorted_array(b)
> print(is_b_sorted)
true
>

2)Using a random unsorted array, then using sort functions on copies of it
and testing the is_sorted_array function

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj1"
> a = util.random_int_array(20, 100)
> util.print_array(a)
{29, 41, 8, 94, 47, 92, 91, 82, 16, 50, 26, 53, 2, 28, 89, 47, 14, 49, 12, 49}
> is_sorted = is_sorted_array(a)
> print(is_sorted)
false
> b = util.copy_table(a)
> c = util.copy_table(a)
> d = util.copy_table(a)
> bubble_sort(b)
> insertion_sort(c)
> ms_top(d)
> util.print_array(c)
{2, 8, 12, 14, 16, 26, 28, 29, 41, 47, 47, 49, 49, 50, 53, 82, 89, 91, 92, 94}
> util.print_array(b)
{2, 8, 12, 14, 16, 26, 28, 29, 41, 47, 47, 49, 49, 50, 53, 82, 89, 91, 92, 94}
> util.print_array(d)
{2, 8, 12, 14, 16, 26, 28, 29, 41, 47, 47, 49, 49, 50, 53, 82, 89, 91, 92, 94}
> print(is_sorted_array(b))
true
> print(is_sorted_array(c))
true
> print(is_sorted_array(d))
true
> print(is_sorted_array(a))
false
>

--]]


--[[

Utility Function 2

equal_arrays_checker(a, b)

Takes two arrays a and b and checks to see if the two arrays have the
same entries.
Returns true only if the two arrays have exactly the same number of
elements in exactly the same order.
Otherwise, returns false.
Note: Does not modify the arrays, just iterates over them.


--]]


function equal_arrays_checker(a, b)
	local a_length = #a
	local b_length = #b

	--if the lengths are unequal the arrays cannot possibly be equal
	if a_length~=b_length then return false end

	-- at this point, a_length === b_length
	for i = 1, a_length-1 do
		--check elements in order
		if a[i] ~= b[i]
		then return false
		end
	end

	--special check for the last element in array
	--because the last element can be an actual element
	--or it can be the 'nil' element
   if a[a_length] == nil
   then
	if b[a_length] == nil then return true
	else return false
	end
   else
	if b[a_length] == nil
	then return false
	else
		if a[a_length] == b[a_length]
		then return true
		else return false
		end
	end
   end

end

--[[
Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj1"
> a = util.random_int_array(10, 100)
> util.print_array(a)
{3, 50, 12, 68, 54, 52, 2, 49, 69, 14}
> b = util.random_int_array(10, 100)
> util.print_array(b)
{52, 95, 62, 76, 37, 55, 16, 61, 68, 99}
> print(equal_arrays_checker(a, b))
false
> c = util.copy_table(a)
> print(equal_arrays_checker(a, c))
true
> print(equal_arrays_checker(c, a))
true
> insertion_sort(c)
> bubble_sort(a)
> print(equal_arrays_checker(c, a))
true
> print(equal_arrays_checker(a, c))
true
>

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj1"
> a = util.random_int_array(20, 100)
> c = util.copy_table(a)
> print(equal_arrays_checker(a, c))
true
> ms_top(c)
> print(equal_arrays_checker(a, c))
false
> bubble_sort(a)
> print(equal_arrays_checker(a, c))
true
>
--]]


-- Part 2
function test_sorts()
	--arrays to store the values of time taken and number of comparisons made
	--for the different sorting functions
	bubble_times = {}
	bubble_count = {}
	insertion_times = {}
	insertion_count = {}
	merge_times = {}
	merge_count = {}

	collector = util.make_collector()
	for i = 1, 100 do
		local a = util.random_int_array(50*i, 1000000)

		local v, t_bubble, c_bubble = util.run_with_time_and_collector(bubble_sort, util.copy_table(a), collector)
		--throw away the v variable
		bubble_times[i] = t_bubble
		bubble_count[i] = c_bubble

		local v, t_ins, c_ins = util.run_with_time_and_collector(insertion_sort, util.copy_table(a), collector)
		--throw away the v variable
		insertion_times[i] = t_ins
		insertion_count[i] = c_ins

		local v, t_merge, c_merge = util.run_with_time_and_collector(ms_top, util.copy_table(a), collector)
		--throw away the v variable
		merge_times[i] = t_merge
		merge_count[i] = c_merge
	end
	print("Ratio of comparisons to time for bubble sort:")
	util.print_array(util.array_ratios(bubble_count, bubble_times))
	print("Ratio of comparisons to time for insertion sort:")
	util.print_array(util.array_ratios(insertion_count, insertion_times))
	print("Ratio of comparisons to time for merge sort:")
	util.print_array(util.array_ratios(merge_count, merge_times))
end

--special version of test_sorts adapted for two input arrays

function test_sorts_with_2_inputs(a, b)
	local collector = util.make_collector()

	local v, t_bubble_a, c_bubble_a = util.run_with_time_and_collector(bubble_sort, util.copy_table(a), collector)
	local v, t_ins_a, c_ins_a = util.run_with_time_and_collector(insertion_sort, util.copy_table(a), collector)
	local v, t_merge_a, c_merge_a = util.run_with_time_and_collector(ms_top, util.copy_table(a), collector)

	local v, t_bubble_b, c_bubble_b = util.run_with_time_and_collector(bubble_sort, util.copy_table(b), collector)
	local v, t_ins_b, c_ins_b = util.run_with_time_and_collector(insertion_sort, util.copy_table(b), collector)
	local v, t_merge_b, c_merge_b = util.run_with_time_and_collector(ms_top, util.copy_table(b), collector)

	print("For array a:")
	print("Ratio of comparisons to time for bubble sort:")
	print(math.ceil(c_bubble_a, t_bubble_a))
	print("Ratio of comparisons to time for insertion sort:")
	print(math.ceil(c_ins_a, t_ins_a))
	print("Ratio of comparisons to time for merge sort:")
	print(math.ceil(c_merge_a, t_merge_a))
	print("For array b:")
	print("Ratio of comparisons to time for bubble sort:")
	print(math.ceil(c_bubble_b, t_bubble_b))
	print("Ratio of comparisons to time for insertion sort:")
	print(math.ceil(c_ins_b, t_ins_b))
	print("Ratio of comparisons to time for merge sort:")
	print(math.ceil(c_merge_b, t_merge_b))
end

--[[
Calling test_sorts(), output shown below:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj1"
> test_sorts()
Ratio of comparisons to time for bubble sort:
{2303000, 3135001, 3476667, 3401091, 3084834, 3358001, 3284706, 3258500, 3268132
, 3298945, 3275285, 3396330, 3408661, 3463467, 3443455, 3438394, 3454842, 329118
9, 3316129, 3453686, 3360874, 3353682, 3409533, 3420677, 3316881, 3425633, 33881
26, 3338812, 3356087, 3432594, 3380633, 3347703, 3377860, 3422564, 3364068, 3418
879, 3361989, 3357679, 3412100, 3426858, 3468199, 3439663, 3388181, 3372324, 333
3204, 3354083, 3324963, 3391539, 3444795, 3405919, 3444485, 3389652, 3375003, 33
76930, 3427909, 3246607, 3424692, 3383954, 3487898, 3453359, 3439112, 3441325, 3
444012, 3444147, 3427445, 3425232, 3437270, 3410289, 3405278, 3404460, 3386267,
3370308, 3251567, 3231663, 3310516, 3305883, 3358183, 3338644, 3324842, 3315622,
 3276709, 3297711, 3203880, 3322549, 3345908, 3325137, 3310926, 3315222, 3349881
, 3352034, 3325913, 3321668, 3358343, 3340900, 3353343, 3304587, 3322255, 332729
3, 3264447, 3335130}
Ratio of comparisons to time for insertion sort:
{1.#INF, 2394000, 5592000, 3397000, 3978501, 3287286, 3913375, 3426167, 3544000,
 3715334, 3450435, 3778392, 3618751, 3804001, 3762917, 3857475, 3674563, 3480759
, 3524874, 3602203, 3610312, 3736281, 3721023, 3757516, 3770943, 3670535, 366638
8, 3615979, 3612049, 3636301, 3662269, 3567184, 3595100, 3631016, 3732796, 36709
78, 3698550, 3730119, 3759254, 3624022, 3679365, 3726065, 3642524, 3643740, 3630
651, 3668853, 3646724, 3706745, 3675659, 3760967, 3745334, 3649432, 3606936, 377
7211, 3650577, 3309958, 3716522, 3713774, 3735039, 3739350, 3741583, 3748690, 36
97229, 3743946, 3710197, 3735510, 3700145, 3701522, 3747353, 3719602, 3637175, 3
634806, 3344584, 3420737, 3431835, 3463047, 3406294, 3454973, 3443261, 3298773,
3384561, 3390696, 3434887, 3453184, 3415419, 3419533, 3381710, 3409182, 3471102,
 3463194, 3408378, 3452133, 3456373, 3467911, 3472627, 3431529, 3445457, 3455549
, 3355121, 3430159}
Ratio of comparisons to time for merge sort:
{1.#INF, 958000, 1.#INF, 3596000, 2795000, 4039001, 3688667, 4851334, 6180667, 5
757501, 7014000, 8408000, 7951600, 9286800, 8943334, 10239334, 11627000, 1123400
1, 12580572, 14005715, 13574000, 14968001, 14610667, 14384801, 17422223, 1703520
1, 16773091, 18114182, 16508308, 17735385, 20592667, 20328001, 20144001, 2145485
8, 22808572, 22591467, 23934934, 23736001, 23595765, 26442500, 27852125, 2757870
6, 20528834, 28733112, 28544737, 28407700, 31295158, 31085601, 32473301, 3227952
4, 33663048, 33483091, 34862819, 36272091, 34568334, 34477761, 35795921, 3868758
4, 38510240, 39906400, 41328561, 42776720, 40973038, 43991385, 40756207, 4209427
6, 42006267, 44837656, 44701534, 46081667, 47483467, 44460849, 47205063, 4858018
8, 48461213, 48368353, 48299372, 51090648, 52480471, 48216843, 53736972, 5216221
7, 52102895, 56403278, 53380154, 54713693, 54663551, 57434616, 58822000, 5872165
0, 61650616, 61514551, 61402196, 62807269, 64229415, 62614280, 64002838, 6392113
7, 65309955, 66714682}
>

#INF appears because in those cases, the time was so small as to be approaching
zero, and division by a near zero number results in infinity.

---------------------------------------------------------------------
ANSWERS:
---------------------------------------------------------------------

(a)For bubble_sort and insertion_sort, the relation between time and
the number of comparisons is fairly stable since the ration of
comparisons per unit time is fairly constant.
For merge_sort, the ratio increases as n increases.
(b) bubble_sort seems to be doing roughly about 4 times as much work
as insertion_sort. merge_sort (the ms_top()) is vastly better than
insertion_sort when arrays become bigger.

> util.print_array(bubble_count)
{2303, 9405, 20860, 37412, 55527, 87308, 111680, 156408, 199356, 237524, 288225,
 339633, 391996, 460641, 530292, 612034, 697878, 766847, 878774, 967032, 1038510
, 1170435, 1254708, 1395636, 1502547, 1623750, 1755049, 1839685, 2017008, 221402
3, 2390107, 2467257, 2580685, 2840728, 2987292, 3159044, 3311559, 3518847, 36953
04, 3934032, 4141029, 4389009, 4465622, 4721253, 4929808, 5145162, 5369814, 5582
473, 5938825, 5987604, 6451519, 6596262, 6871506, 7165845, 7342579, 7775622, 794
8710, 8233160, 8608131, 8844051, 8896982, 9439554, 9815433, 10022467, 10234350,
10652471, 10954579, 11294877, 11550701, 12096043, 11963679, 12517322, 13165592,
13249818, 13897543, 13854953, 14668539, 14960463, 15314222, 15580104, 16200049,
16650138, 16737066, 17509830, 17820306, 18171873, 18739841, 18946493, 19295313,
20025049, 19829091, 20235600, 21338910, 21662390, 21987870, 22550501, 22896978,
23314341, 24235253, 24820035}

> util.print_array(insertion_count)
{646, 2394, 5592, 10191, 15914, 23011, 31307, 41114, 53160, 66876, 79360, 86903,
 101325, 117924, 135465, 154299, 176379, 201884, 222067, 248552, 277994, 306375,
 334892, 356964, 392178, 425782, 472964, 509853, 520135, 556354, 600612, 642093,
 683069, 708048, 765223, 807615, 861762, 910149, 962369, 1003854, 1019184, 10917
37, 1140110, 1202434, 1288881, 1320787, 1385755, 1438217, 1507020, 1579606, 1640
456, 1693336, 1742150, 1828170, 1894649, 1949565, 2066386, 2101996, 2114032, 225
8567, 2293590, 2414156, 2480840, 2587066, 2660211, 2719451, 2756608, 2931605, 29
52914, 3053793, 3120696, 3253151, 3354617, 3430999, 3565676, 3656977, 3685610, 3
838474, 3942533, 4021204, 4169778, 4140039, 4345131, 4316480, 4508353, 4647144,
4707339, 4837629, 4904667, 4997388, 5139833, 5299023, 5426505, 5527850, 5663854,
 5795851, 5840048, 6088677, 6072768, 6242889}

> util.print_array(merge_count)
{286, 958, 2052, 3596, 5590, 8078, 11066, 14554, 18542, 23030, 28056, 33632, 397
58, 46434, 53660, 61436, 69762, 78638, 88064, 98040, 108592, 119744, 131496, 143
848, 156800, 170352, 184504, 199256, 214608, 230560, 247112, 264264, 282016, 300
368, 319320, 338872, 359024, 379776, 401128, 423080, 445634, 468838, 492692, 517
196, 542350, 568154, 594608, 621712, 649466, 677870, 706924, 736628, 766982, 797
986, 829640, 861944, 894898, 928502, 962756, 997660, 1033214, 1069418, 1106272,
1143776, 1181930, 1220734, 1260188, 1300292, 1341046, 1382450, 1424504, 1467208,
 1510562, 1554566, 1599220, 1644524, 1690478, 1737082, 1784336, 1832240, 1880794
, 1930002, 1979910, 2030518, 2081826, 2133834, 2186542, 2239950, 2294058, 234886
6, 2404374, 2460582, 2517490, 2575098, 2633406, 2692414, 2752122, 2812530, 28736
38, 2935446}

> util.print_array(bubble_times)
{0.0010000000000003, 0.0029999999999992, 0.0059999999999993, 0.011, 0.018, 0.026
, 0.034000000000001, 0.048, 0.061, 0.072, 0.088, 0.1, 0.115, 0.133, 0.154, 0.178
, 0.202, 0.233, 0.265, 0.28, 0.309, 0.349, 0.368, 0.408, 0.453, 0.474, 0.518, 0.
551, 0.601, 0.645, 0.707, 0.737, 0.764, 0.83, 0.888, 0.924, 0.985, 1.048, 1.083,
 1.148, 1.194, 1.276, 1.318, 1.4, 1.479, 1.534, 1.615, 1.646, 1.724, 1.758, 1.87
3, 1.946, 2.036, 2.122, 2.142, 2.395, 2.321, 2.433, 2.468, 2.561, 2.587, 2.743,
2.85, 2.91, 2.986, 3.11, 3.187, 3.312, 3.392, 3.553, 3.533, 3.714, 4.049, 4.1, 4
.198, 4.191, 4.368, 4.481, 4.606, 4.699, 4.944, 5.049, 5.224, 5.27, 5.326, 5.465
, 5.66, 5.715, 5.76, 5.974, 5.962, 6.092, 6.354, 6.484, 6.557, 6.824, 6.892, 7.0
07, 7.424, 7.442}

> util.print_array(insertion_times)
{0, 0.0010000000000003, 0.0010000000000003, 0.0030000000000001, 0.00399999999999
96, 0.0069999999999997, 0.008, 0.012, 0.015000000000001, 0.018000000000001, 0.02
3, 0.023, 0.028, 0.030999999999999, 0.036, 0.040000000000001, 0.048, 0.058, 0.06
2999999999999, 0.069000000000001, 0.077, 0.081999999999999, 0.090000000000002, 0
.095000000000001, 0.104, 0.116, 0.129, 0.141, 0.144, 0.153, 0.164, 0.18, 0.19, 0
.195, 0.205, 0.22, 0.233, 0.244, 0.256, 0.277, 0.277, 0.293, 0.313, 0.33, 0.355,
 0.36, 0.38, 0.38800000000001, 0.41, 0.41999999999999, 0.438, 0.464, 0.483, 0.48
4, 0.51900000000001, 0.589, 0.556, 0.566, 0.566, 0.604, 0.613, 0.64400000000001,
 0.67099999999999, 0.691, 0.717, 0.72799999999999, 0.745, 0.792, 0.788, 0.821, 0
.858, 0.895, 1.003, 1.003, 1.039, 1.056, 1.082, 1.111, 1.145, 1.219, 1.232, 1.22
1, 1.265, 1.25, 1.32, 1.359, 1.392, 1.419, 1.413, 1.443, 1.508, 1.535, 1.57, 1.5
94, 1.631, 1.689, 1.695, 1.762, 1.81, 1.82}

> util.print_array(merge_times)
{0, 0.0010000000000003, 0, 0.0010000000000003, 0.0020000000000007, 0.00199999999
99998, 0.0030000000000001, 0.0029999999999992, 0.0030000000000001, 0.00399999999
99996, 0.0040000000000004, 0.0040000000000004, 0.0050000000000008, 0.00500000000
00008, 0.0060000000000002, 0.0060000000000002, 0.0060000000000002, 0.00699999999
99997, 0.0069999999999997, 0.0069999999999997, 0.0080000000000009, 0.00799999999
99991, 0.0089999999999986, 0.0099999999999998, 0.0090000000000003, 0.00999999999
99998, 0.010999999999999, 0.010999999999999, 0.013, 0.013, 0.012, 0.012999999999
998, 0.013999999999999, 0.013999999999999, 0.013999999999999, 0.014999999999997,
 0.015000000000001, 0.015999999999998, 0.016999999999999, 0.016000000000002, 0.0
16000000000002, 0.016999999999999, 0.024000000000001, 0.018000000000001, 0.01900
0000000005, 0.020000000000003, 0.018999999999998, 0.019999999999996, 0.019999999
999996, 0.021000000000001, 0.021000000000001, 0.021999999999998, 0.0219999999999
98, 0.021999999999998, 0.024000000000001, 0.024999999999999, 0.024999999999991,
0.024000000000001, 0.025000000000006, 0.025000000000006, 0.024999999999991, 0.02
5000000000006, 0.027000000000001, 0.02600000000001, 0.029000000000011, 0.0289999
99999996, 0.030000000000001, 0.028999999999996, 0.030000000000001, 0.03000000000
0001, 0.030000000000001, 0.033000000000001, 0.031999999999996, 0.032000000000011
, 0.033000000000015, 0.03400000000002, 0.035000000000025, 0.03400000000002, 0.03
3999999999992, 0.038000000000011, 0.034999999999997, 0.037000000000006, 0.037999
999999982, 0.036000000000001, 0.039000000000016, 0.038999999999987, 0.0399999999
99992, 0.038999999999987, 0.039000000000016, 0.04000000000002, 0.039000000000016
, 0.039999999999992, 0.040999999999997, 0.040999999999997, 0.040999999999997, 0.
043000000000006, 0.043000000000006, 0.043999999999983, 0.043999999999983, 0.0440
0000000004}

For an array of 250 elements:
bubble_sort: 55527 comparisons, 0.018
ins_sort: 15914 comparisons, 0.0039999999999996
merge_sort: 5590 comparisons, 0.0020000000000007

For an array of 500 elements:
bubble_sort: 237524 comparisons, 0.072
ins_sort:  66876 comparisons, 0.018000000000001
merge_sort: 23030 comparisons, 0.0039999999999996

Bubble sort comparisons increase drastically.
Insertion sort comparisons roughly triple.
Merge sort comparisons roughly double.

(c) Ratio of number of comparisons for different pairs of algorithms:

> util.print_array(util.array_ratios(bubble_count, insertion_count))
{4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
, 4, 4, 4, 4, 4, 4, 5, 4, 4, 4, 4, 4, 4, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
4, 4, 4, 4, 4, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 5, 4, 5, 4, 4, 4, 4, 4, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4}

bubble_count does about 4 times more comparisons than insertion_count.

> util.print_array(util.array_ratios(bubble_count, merge_count))
{9, 10, 11, 11, 10, 11, 11, 11, 11, 11, 11, 11, 10, 10, 10, 10, 11, 10, 10, 10,
10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
10, 10, 10, 10, 10, 10, 10, 9, 10, 9, 10, 9, 9, 9, 9, 10, 9, 9, 9, 9, 9, 9, 9, 9
, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
9, 9, 9, 9, 9, 9, 9, 9, 9, 9}

bubble_count does about 10 times more work than merge_count.

> util.print_array(util.array_ratios(insertion_count, merge_count))
{3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}

insertion_count does about 3 times more work than merge_count.

(d)
For already sorted inputs:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj1"
> a = {17, 54, 262, 385, 400, 539, 800, 814, 879, 920}
> b = {1, 5, 100, 128, 197, 204, 286, 314, 389, 500}
> util.print_array(a)
{17, 54, 262, 385, 400, 539, 800, 814, 879, 920}
> util.print_array(b)
{1, 5, 100, 128, 197, 204, 286, 314, 389, 500}
> test_sorts_with_2_inputs(a, b)
For array a:
Ratio of comparisons to time for bubble sort:
9
Ratio of comparisons to time for insertion sort:
9
Ratio of comparisons to time for merge sort:
34
For array b:
Ratio of comparisons to time for bubble sort:
9
Ratio of comparisons to time for insertion sort:
9
Ratio of comparisons to time for merge sort:
68

For reversed inputs:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj1"
> a = {1500, 1325, 1299, 1101, 989, 865, 654, 321, 100, 9}
> b = {1700, 1499, 1321, 1111, 854, 543, 314, 213, 111, 5}
> util.print_array(a)
{1500, 1325, 1299, 1101, 989, 865, 654, 321, 100, 9}
> util.print_array(b)
{1700, 1499, 1321, 1111, 854, 543, 314, 213, 111, 5}
> test_sorts_with_2_inputs(a, b)
For array a:
Ratio of comparisons to time for bubble sort:
90
Ratio of comparisons to time for insertion sort:
54
Ratio of comparisons to time for merge sort:
34
For array b:
Ratio of comparisons to time for bubble sort:
90
Ratio of comparisons to time for insertion sort:
54
Ratio of comparisons to time for merge sort:
68

For randomly generated inputs:
Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj1"
> a = util.random_int_array(10, 5000)
> b = util.random_int_array(10, 5000)
> util.print_array(a)
{1663, 4968, 2833, 4501, 407, 2366, 2732, 4591, 2578, 3109}
> util.print_array(b)
{3223, 871, 2520, 796, 2803, 4265, 946, 4669, 3826, 3018}
> test_sorts_with_2_inputs(a, b)
For array a:
Ratio of comparisons to time for bubble sort:
54
Ratio of comparisons to time for insertion sort:
30
Ratio of comparisons to time for merge sort:
34
For array b:
Ratio of comparisons to time for bubble sort:
45
Ratio of comparisons to time for insertion sort:
25
Ratio of comparisons to time for merge sort:
68

Bubble sort performs the best when input array is already sorted, the worst when the input array is reverse-sorted.
Insertion sort performs the best when input array is already sorted, the worst when the input array is reverse-sorted.
Merge sort performs the same in all 3 cases.

--]]

-- Part 3

--[[
in_place_ins_sort

Note:  This procedure will permanently change the order of entries in
the array.  Copy the array before giving it if you want to keep the
original!
--]]
function in_place_ins_sort(a)
	local i, k, temp
	local in_place_ins_comparisons_counter = util.make_collector()
	for i = 1, #a do
		temp = a[i]
		k = i
		while(k > 0 and a[k - 1] ~= nil and temp < a[k - 1]) do
			in_place_ins_comparisons_counter.inc()
			a[k] = a[k - 1]
			k = k - 1
		end
		a[k] = temp
	end
	local num_comparisons = in_place_ins_comparisons_counter.reveal()
	return num_comparisons, a
end

--[[
testing in_place_ins_sort:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj1"
> a = util.random_int_array(10, 100)
> util.print_array(a)
{41, 76, 5, 81, 28, 29, 47, 38, 59, 66}
> comp, b = in_place_ins_sort(util.copy_table(a))
> util.print_array(a)
{41, 76, 5, 81, 28, 29, 47, 38, 59, 66}
> util.print_array(b)
{5, 28, 29, 38, 41, 47, 59, 66, 76, 81}
> print(comp)
18
> ins_comp, c = insertion_sort(util.copy_table(a))
> util.print_array(a)
{41, 76, 5, 81, 28, 29, 47, 38, 59, 66}
> util.print_array(c)
{5, 28, 29, 38, 41, 47, 59, 66, 76, 81}
> print(ins_comp)
27
> print(is_sorted_array(b))
true
> print(is_sorted_array(c))
true
> print(is_sorted_array(a))
false
> print(equal_arrays_checker(c, b))
true
> print(equal_arrays_checker(b, c))
true
--]]

function test_4_sorts()
	--arrays to store the values of time taken and number of comparisons made
	--for the different sorting functions
	bubble_times = {}
	bubble_count = {}
	insertion_times = {}
	insertion_count = {}
	merge_times = {}
	merge_count = {}
	in_place_ins_times = {}
	in_place_ins_count = {}

	collector = util.make_collector()
	for i = 1, 100 do
		local a = util.random_int_array(50*i, 1000000)

		local v, t_bubble, c_bubble = util.run_with_time_and_collector(bubble_sort, util.copy_table(a), collector)
		--throw away the v variable
		bubble_times[i] = t_bubble
		bubble_count[i] = c_bubble

		local v, t_ins, c_ins = util.run_with_time_and_collector(insertion_sort, util.copy_table(a), collector)
		--throw away the v variable
		insertion_times[i] = t_ins
		insertion_count[i] = c_ins

		local v, t_merge, c_merge = util.run_with_time_and_collector(ms_top, util.copy_table(a), collector)
		--throw away the v variable
		merge_times[i] = t_merge
		merge_count[i] = c_merge

		local v, t_inp_ins, c_inp_ins = util.run_with_time_and_collector(in_place_ins_sort, util.copy_table(a), collector)
		--throw away the v variable
		in_place_ins_times[i] = t_inp_ins
		in_place_ins_count[i] = c_inp_ins
	end
	print("Ratio of comparisons to time for bubble sort:")
	util.print_array(util.array_ratios(bubble_count, bubble_times))
	print("Ratio of comparisons to time for insertion sort:")
	util.print_array(util.array_ratios(insertion_count, insertion_times))
	print("Ratio of comparisons to time for merge sort:")
	util.print_array(util.array_ratios(merge_count, merge_times))
	print("Ratio of comparisons to time for in-place insertion sort:")
	util.print_array(util.array_ratios(in_place_ins_count, in_place_ins_times))
end


--special version of test_4_sorts adapted for two input arrays

function test_4_sorts_with_2_inputs(a, b)
	local collector = util.make_collector()

	local v, t_bubble_a, c_bubble_a = util.run_with_time_and_collector(bubble_sort, util.copy_table(a), collector)
	local v, t_ins_a, c_ins_a = util.run_with_time_and_collector(insertion_sort, util.copy_table(a), collector)
	local v, t_merge_a, c_merge_a = util.run_with_time_and_collector(ms_top, util.copy_table(a), collector)
	local v, t_inp_ins_a, c_inp_ins_a = util.run_with_time_and_collector(in_place_ins_sort, util.copy_table(a), collector)

	local v, t_bubble_b, c_bubble_b = util.run_with_time_and_collector(bubble_sort, util.copy_table(b), collector)
	local v, t_ins_b, c_ins_b = util.run_with_time_and_collector(insertion_sort, util.copy_table(b), collector)
	local v, t_merge_b, c_merge_b = util.run_with_time_and_collector(ms_top, util.copy_table(b), collector)
	local v, t_inp_ins_b, c_inp_ins_b = util.run_with_time_and_collector(in_place_ins_sort, util.copy_table(b), collector)

	print("For array a:")
	print("Ratio of comparisons to time for bubble sort:")
	print(math.ceil(c_bubble_a, t_bubble_a))
	print("Ratio of comparisons to time for insertion sort:")
	print(math.ceil(c_ins_a, t_ins_a))
	print("Ratio of comparisons to time for merge sort:")
	print(math.ceil(c_merge_a, t_merge_a))
	print("Ratio of comparisons to time for in-place insertion sort:")
	print(math.ceil(c_inp_ins_a, t_inp_ins_a))
	print("For array b:")
	print("Ratio of comparisons to time for bubble sort:")
	print(math.ceil(c_bubble_b, t_bubble_b))
	print("Ratio of comparisons to time for insertion sort:")
	print(math.ceil(c_ins_b, t_ins_b))
	print("Ratio of comparisons to time for merge sort:")
	print(math.ceil(c_merge_b, t_merge_b))
	print("Ratio of comparisons to time for in-place insertion sort:")
	print(math.ceil(c_inp_ins_b, t_inp_ins_b))

end

--[[
Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj1"
> test_4_sorts()
Ratio of comparisons to time for bubble sort:
{1.#INF, 2706000, 3302834, 3217167, 3333834, 3351292, 3366824, 3387067, 3330764,
 3393201, 3384424, 3422010, 3276404, 3333693, 3372886, 3431262, 3474688, 3360263
, 3334034, 3328872, 3282249, 3386526, 3389399, 3393730, 3399283, 3443296, 333673
2, 3345757, 3377802, 3393736, 3335275, 3294115, 3370172, 3148537, 3218314, 29190
07, 2902767, 3033403, 2783668, 3202682, 3344740, 3130996, 3323020, 3374086, 3310
360, 3373681, 3141316, 3376048, 3387131, 3348907, 3323161, 3360593, 3359420, 335
9047, 3405478, 3405803, 3405646, 3369953, 3359165, 3377734, 3377354, 3409128, 34
08918, 3261258, 3267793, 3194750, 3345932, 3360925, 3353669, 3399907, 3391116, 3
358485, 3347976, 3346583, 3298571, 3349240, 3384435, 3378426, 3367446, 3375436,
3393230, 3381530, 3422339, 3395534, 3332643, 3380221, 3359599, 3430259, 3342818,
 3394617, 3377948, 3395531, 3321234, 2936555, 3328196, 3120278, 2723569, 2955849
, 3068292, 3338606}
Ratio of comparisons to time for insertion sort:
{1.#INF, 1.#INF, 2780000, 5088501, 3080801, 3183286, 3368667, 4004401, 3770385,
3775313, 3619550, 3715261, 3540897, 3491795, 3740595, 3543410, 3721542, 3640893,
 3543462, 3637258, 3639369, 3593036, 3748943, 3623909, 3660248, 3745706, 3612884
, 3741771, 3726719, 3718497, 3612434, 3685503, 3564736, 3053642, 3594113, 270186
2, 3205442, 3427937, 3034641, 3645368, 3516397, 3693723, 3602682, 3694022, 36858
11, 3477853, 3241920, 3625810, 3710055, 3719922, 3603310, 3691298, 3689674, 3723
915, 3712730, 3692270, 3647895, 3714559, 3695518, 3699546, 3695436, 3719874, 371
3685, 3544392, 3556013, 3595742, 3561959, 3668199, 3671377, 3682512, 3663496, 36
22572, 3656850, 3572641, 3609382, 3715346, 3708920, 3682244, 3639649, 3662043, 3
632846, 3591486, 3744858, 3517330, 3571083, 3714958, 3666645, 3704047, 3624578,
3685025, 3714342, 3695744, 3587398, 3036560, 3638802, 2777150, 2618055, 3382353,
 3589723, 3628094}
Ratio of comparisons to time for merge sort:
{286001, 958001, 2052001, 1798000, 2795000, 4039000, 5533000, 7277000, 4635501,
5757501, 7014001, 8408000, 7951600, 9286801, 10732000, 10239334, 11627000, 11234
001, 11008001, 12255001, 13574001, 13304889, 14610667, 14384800, 15680000, 17035
201, 16773091, 18114182, 19509819, 20960001, 19008616, 18876001, 20144001, 21454
858, 21288000, 21179501, 21119059, 23736001, 18233091, 23504445, 22281700, 27578
706, 25931158, 30423295, 28544737, 29902843, 31295158, 29605334, 32473300, 32279
524, 30735827, 32027305, 34862819, 34695044, 36071305, 35914334, 38908609, 35711
616, 40114834, 38371539, 38267186, 41131462, 40973038, 39440552, 40756207, 43597
643, 45006715, 44837656, 44701534, 46081667, 47483467, 44460849, 45774607, 48580
188, 49975626, 49834061, 48299372, 49630915, 52480471, 49520000, 53736972, 53611
167, 52102895, 53434685, 54784895, 56153527, 56065180, 54632927, 57351451, 60227
334, 61650616, 60014196, 55944223, 57224401, 58520134, 47235334, 48282843, 57398
572, 61141235, 62456298}
Ratio of comparisons to time for in-place insertion sort:
{1.#INF, 2316001, 2705500, 2494501, 2525834, 2748000, 2497417, 2643000, 2698112,
 2852667, 2565786, 2737162, 2685185, 2682319, 2753061, 2872426, 2653508, 2743122
, 2797269, 2726979, 2701402, 2733782, 2777855, 2786961, 2669249, 2733465, 276614
9, 2722919, 2792302, 2695400, 2652775, 2765152, 2710025, 2527848, 2742702, 23021
55, 2482839, 2639769, 2421387, 2667939, 2629732, 2659760, 2627867, 2723541, 2750
044, 2665223, 2692686, 2726903, 2757580, 2760184, 2757244, 2699238, 2733874, 274
9613, 2787393, 2747306, 2757922, 2748288, 2755187, 2770966, 2756984, 2738301, 26
66839, 2651240, 2697228, 2714131, 2740181, 2693659, 2696730, 2720854, 2706642, 2
704874, 2681697, 2716476, 2686846, 2752252, 2707654, 2715863, 2733948, 2751439,
2703462, 2777492, 2771509, 2424700, 2734612, 2755484, 2771251, 2707783, 2712546,
 2746322, 2743331, 2767054, 1569829, 2541539, 2720313, 2348026, 2182833, 2456985
, 2688534, 2636409}

(a) For in-place insertion sort, the ratio of comparisons per unit time is
fairly constant.
(b) For in-place insertion sort, the array storing number of comparisons is:
> util.print_array(in_place_ins_count)
{605, 2316, 5411, 9978, 15155, 21984, 29969, 39645, 48566, 59906, 71842, 84852,
102037, 118022, 137653, 155111, 177785, 202991, 229376, 253609, 275543, 300716,
325009, 353944, 397718, 418220, 464713, 503740, 527745, 552557, 623402, 658106,
672086, 712853, 735044, 819567, 876442, 913360, 978240, 1000477, 1017706, 111709
9, 1161517, 1198358, 1317271, 1319285, 1362499, 1426170, 1500123, 1611947, 16405
60, 1684324, 1727808, 1825743, 1853616, 1972565, 2043620, 2110685, 2195884, 2250
024, 2321380, 2385060, 2496161, 2534585, 2645980, 2722273, 2742921, 2909151, 299
6066, 2979335, 3077451, 3245848, 3378937, 3401027, 3500960, 3663247, 3701362, 37
77765, 3934151, 3918048, 4111965, 4205122, 4362355, 4395980, 4520312, 4631968, 4
688956, 4773821, 4972096, 5058724, 5217815, 5365316, 5415909, 5543096, 5693614,
5755010, 5854356, 5958188, 6108349, 6369562}

The number of comparisons increase by smaller amounts as the array size increases.

(c) Ratios of number of comparisons for different pairs of algorithms:

> util.print_array(util.array_ratios(bubble_count, insertion_count))
{3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 4, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
4, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4, 5,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4}

Bubble sort does roughly 4 times more comparisons than insertion sort.

> util.print_array(util.array_ratios(bubble_count, merge_count))
{7, 9, 10, 11, 11, 10, 11, 11, 10, 10, 11, 11, 11, 11, 10, 11, 11, 10, 11, 11, 1
0, 11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 1
0, 10, 10, 10, 10, 10, 9, 9, 9, 10, 9, 9, 9, 9, 10, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
9, 9, 9, 9, 9, 9, 9, 9, 9}

Bubble sort does roughly 10 times more comparisons than merge sort.

> util.print_array(util.array_ratios(bubble_count, in_place_ins_count))
{4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 4, 5, 4, 4, 5, 4, 4, 4, 4, 5, 4, 4, 4, 4, 4
, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
4, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4, 5,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4}

Bubble sort does roughly 4 times more comparisons than in-place insertion sort.

> util.print_array(util.array_ratios(insertion_count, merge_count))
{3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}

Insertion sort does roughly 3 times more comparisons than merge sort.

> util.print_array(util.array_ratios(insertion_count, in_place_ins_count))
{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2}

Insertion sort does roughly 2 times more comparisons than in-place insertion sort.

> util.print_array(util.array_ratios(merge_count, in_place_ins_count))
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}

Merge sort does roughly the same number of comparisons as in-place insertion sort.

(d)
For already sorted inputs:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj1"
> a = {17, 54, 262, 385, 400, 539, 800, 814, 879, 920}
> b = {1, 5, 100, 128, 197, 204, 286, 314, 389, 500}
> util.print_array(a)
{17, 54, 262, 385, 400, 539, 800, 814, 879, 920}
> util.print_array(b)
{1, 5, 100, 128, 197, 204, 286, 314, 389, 500}
> test_4_sorts_with_2_inputs(a, b)
For array a:
Ratio of comparisons to time for bubble sort:
9
Ratio of comparisons to time for insertion sort:
9
Ratio of comparisons to time for merge sort:
34
Ratio of comparisons to time for in-place insertion sort:
0
For array b:
Ratio of comparisons to time for bubble sort:
9
Ratio of comparisons to time for insertion sort:
9
Ratio of comparisons to time for merge sort:
68
Ratio of comparisons to time for in-place insertion sort:
0

For reversed inputs:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj1"
> a = {1500, 1325, 1299, 1101, 989, 865, 654, 321, 100, 9}
> b = {1700, 1499, 1321, 1111, 854, 543, 314, 213, 111, 5}
> util.print_array(a)
{1500, 1325, 1299, 1101, 989, 865, 654, 321, 100, 9}
> util.print_array(b)
{1700, 1499, 1321, 1111, 854, 543, 314, 213, 111, 5}
> test_4_sorts_with_2_inputs(a, b)
For array a:
Ratio of comparisons to time for bubble sort:
90
Ratio of comparisons to time for insertion sort:
54
Ratio of comparisons to time for merge sort:
34
Ratio of comparisons to time for in-place insertion sort:
45
For array b:
Ratio of comparisons to time for bubble sort:
90
Ratio of comparisons to time for insertion sort:
54
Ratio of comparisons to time for merge sort:
68
Ratio of comparisons to time for in-place insertion sort:
45

For randomly generated inputs:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj1"
> a = util.random_int_array(10, 5000)
> b = util.random_int_array(10, 5000)
> util.print_array(a)
{3010, 4468, 2593, 1304, 1658, 1389, 1565, 187, 2582, 985}
> util.print_array(b)
{2930, 2645, 3608, 1026, 3455, 2814, 225, 2745, 4768, 917}
> test_4_sorts_with_2_inputs(a, b)
For array a:
Ratio of comparisons to time for bubble sort:
81
Ratio of comparisons to time for insertion sort:
43
Ratio of comparisons to time for merge sort:
34
Ratio of comparisons to time for in-place insertion sort:
34
For array b:
Ratio of comparisons to time for bubble sort:
81
Ratio of comparisons to time for insertion sort:
35
Ratio of comparisons to time for merge sort:
68
Ratio of comparisons to time for in-place insertion sort:
26

Bubble sort performs the best when input array is already sorted, the worst when the input array is reverse-sorted.
Insertion sort performs the best when input array is already sorted, the worst when the input array is reverse-sorted.
Merge sort performs the same in all 3 cases.
In-place Insertion sort performs the best when input array is already sorted, the worst when the input array is reverse-sorted.

--]]
