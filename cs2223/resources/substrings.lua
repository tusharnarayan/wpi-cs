#!/usr/local/bin/lua -i 
function array_of_string (s) 
   t = {} 
   for i = 1, string.len (s) do
      t[i] = string.byte (s,i) 
   end
   return (t) 
end 

function substring (s1,s2) 
   local j = 1
   for i = 1, string.len(s1) do 
      j = string.find(s2,string.sub(s1,i,i), j, true)
      if not(j) then return false else end 
   end
   return true 
end

	 
-- t is a table where t[i] = true means to use i, 
-- and t[i] = false means to omit i 

function substring_masking (s1,s2,t)
   local j = 0
   for i = 1, string.len(s1) do 
      if t[i] 
      then 
	 j = string.find(s2,string.sub(s1,i,i),j+1,true)
	 if not(j) then return false end 
      end
   end
   return true 
end

-- generate a 1 to bound (inclusive) array initialized with true  

function full_boolean_array (bound) 
   local t = {} 
   for i = 1, bound do 
      t[i]=true 
   end
   return t 
end 

function copy_array (src) 
   local t = {} 
   for i = 1, #src do 
      t[i]=src[i]
   end 
   return t 
end 

function first_rise (a) 
   for i = 1,#a do
      if a[i] then 
      else 
	 for j = i+1, #a do 
	    if a[j] then return j
	    else 
	    end	 
	 end 
      end 
   end
   return (#a)+1
end

function generate_sets (bound) 
   local function update_held (g,lv) 
      local t,c = g() 
      if not(t) then return nil,nil end 
      local t1 = copy_array(t)
      table.insert(t1, lv)
      local i 
      if lv then i = 1 else i = 0 end 
      return t1, c+i 
   end 

   if bound == 0 
   then 
      local fst = true 
      return function () 
		if fst 
		then fst = false ;  return {}, 0
		else return nil,nil
		end 
	     end
   else 
      local gen1 = generate_sets (bound-1) 
      local gen2 = generate_sets (bound-1) 
      local held1,held1_card = update_held (gen1,true) 
      local held2,held2_card = update_held (gen2,false)
      return function () 
		if held1 and held1_card >= held2_card
		then 
		   local t,tc = held1,held1_card
		   --		   print (".")
		   held1,held1_card = update_held (gen1,true) 
		   return t,tc
		elseif held2 then 
		   local t,tc = held2,held2_card
		   held2,held2_card = update_held (gen2,false) 
		   return t,tc
		else
		   return nil,nil 
		end
	     end
   end
end
	 
function count_subsets (bound) 
   local ct = 0 
   for s,c in generate_sets(bound) do 
      print (c,unpack (s)); ct = ct+1
   end
   print (ct) 
end

function countem (bound) 
   local start = os.clock() 
   local done  
   local ct = 0 
   for s in generate_sets(bound) do 
      ct = ct+1
   end
   done = os.clock() 
   print (ct) 
   print (done-start)
end

function count_members(set) 
   local r = 0 
   for i,b in pairs(set) do 
      if b then r = r+1 end 
   end
   return r
end 

function decreasing (bound) 
   local c = bound  
   for s in generate_sets(bound) do 
      local m = count_members(s) 
      if m > c then 
	 print(m, c, unpack(s)) 
	 return
      else
	 c = count_members(s)
      end
   end
end

function mask_string (str, set) 
   local l = string.len(str)
   local res_tab = {} 

   for i = 1, l do 
      if set[i] 
      then table.insert(res_tab, string.byte(str,i))
      end 
   end
   return string.char(unpack(res_tab))
end
   
function a_longest_common_substring(s1,s2) 
   if string.len(s1)>string.len(s2)
   then s1,s2 = s2,s1 
   end 

   for set in generate_sets (string.len(s1)) do 
      if substring_masking (s1,s2,set) 
      then return mask_string(s1,set)
      end
   end 
   return ""
end 

function set_randomseed () 
   local d = os.date() .. os.clock () 
   local t = {string.byte(d,1,string.len(d))}
   local c = 1 
   for i = 1, #t do 
      _,c = math.modf(math.exp((math.log(t[i]*c))/2))
      -- print (t[i], c)
   end 
   -- print((math.modf(c*100000000)))
   math.randomseed (math.modf(c*10000000000000))
end

set_randomseed ()


function random_string (lb,ub,len) 

   local t = {} 
   for i = 1,len do 
      t[i] = math.random(lb,ub)
   end
   return string.char(unpack(t))
end

start = 97

function lcs_random(alphabet_size, len) 
   local s1 = random_string(start,start+alphabet_size, len)
   local s2 = random_string(start,start+alphabet_size, len)

   print ("s1:", s1) 
   print ("s2:", s2) 
   local t0 = os.clock() 
   local v = a_longest_common_substring(s1,s2)
   print ("time: ", os.clock()-t0)
   print ("lcs: ", v)
   return v
end

function lcs_slow(len) 
   lcs_random(25, len)
end 

function run_timed (thunk) 
   local t0, t1
   local v
   
   t0 = os.clock () 
   v = thunk ()
   t1 = os.clock () 


   print(string.format("\nElapsed time: %f\n", (t1-t0)))
   if v then 
      print(string.format("Result: %s", v))
      return v 
   end
end 

function accumulate_timed (thunk, ct) 
   local t0, t1
   local total = 0

   for i = 1, ct do  
   
      t0 = os.clock () 
      v = thunk ()
      t1 = os.clock () 

      total = total+(t1-t0)
   end 
   
   print(string.format("\n****\nTotal for %d reps: %f\n", ct, total))
end
   


function lcs_string(s1,s2,t) 
   local m = #t
   local n = #(t[m]) 
   local l = {}

   local function traverse(i,j) 
      if i > 0 and j > 0 then
	 if string.byte(s1,i) == string.byte(s2,j) 
	 then table.insert(l, string.byte(s1,i))
	    --	    print(string.byte(s1,i))
	    traverse(i-1,j-1)
	 else if i > 1 and j > 1 
	    then 
	       if t[i][j-1] > t[i-1][j]
	       then traverse(i,j-1)
	       else traverse(i-1,j)
	       end
	    else if i == 1 
	       then traverse(i,j-1)
	       else traverse(i-1,j)
	       end
	    end
	 end
      end
   end

   traverse(m,n)
   return string.reverse(string.char(unpack(l)))
end


function lcs_length (s1,s2) 
   local m = string.len(s1) 
   local n = string.len(s2) 
   local t = {} 
   local fstj = string.find(s2,string.sub(s1,1,1), 1, true)
   local fsti = string.find(s1,string.sub(s2,1,1), 1, true)

   local t1 = {} 

   for j = 1,n do 
      if fstj and j<fstj 
      then table.insert(t1,0) 
      else if fstj 
	 then table.insert(t1,1)
	 else table.insert(t1,0) 
	 end
      end
   end
   table.insert(t,1,t1)

   for i = 2,m do 
      local ti = {} 
      table.insert(t,i,ti)

      if fsti and i<fsti
      then table.insert(ti,0) 
      else -- print ("Hah!", fsti)
	 if fsti 
	 then table.insert(ti,1)
	 else table.insert(ti,0) 
	 end
      end

      for j = 2,n do 
	 if string.byte(s1,i) == string.byte(s2,j)
	 then 
	    table.insert(ti,(t[i-1][j-1]+1))
	 else 
	    if t[i-1][j] >= t[i][j-1]
	    then table.insert(ti,t[i-1][j])   
	    else table.insert(ti,t[i][j-1])
	    end
	 end
      end
   end

--      for i = 1,m do 
--         print(unpack(t[i]))
--      end

   local res = lcs_string(s1,s2,t)

   if string.len(res) ~= t[m][n] 
   then
      error(string.format("String %s has length %d, \nbut %d predicted", 
			  res, string.len(res), t[m][n]))
   end

   return t[m][n], res 
end 
	 
function ans1_reps(alphabet_size, len, ct)
   accumulate_timed(
      function () 
         local s1 = random_string(start,start+alphabet_size, len)
	 local s2 = random_string(start,start+alphabet_size, len)
	 local a1

	 print ("s1:", s1) 
	 print ("s2:", s2) 
	 a1 = a_longest_common_substring(s1,s2)
	 print("ans1:", a1)
      end,
   ct)
end

function ans2_reps(alphabet_size, len, ct)
   accumulate_timed(
      function () 
         local s1 = random_string(start,start+alphabet_size, len)
	 local s2 = random_string(start,start+alphabet_size, len)
	 local a2,l2

	 print (s1) 
	 print (s2) 
	 l2,a2 = lcs_length(s1,s2)
	 print(l2, a2)
      end,
   ct)
end


function access_2_d_table(t,i,j) 
   local ti = t[i] 
   if ti then return ti[j] 
   else return nil 
   end 
end 

function update_2_d_table(t,i,j,v)
   local ti = t[i] 
   if ti then ti[j] = v 
   else 
      t[i] = {}; t[i][j] = v 
   end 
end 

function recursively_memoize_binop(o) 
   local memo_table = {} 
   local function fn(arg1,arg2) 
      local cached = access_2_d_table(memo_table,arg1,arg2) 
      if cached then return cached 
      else 
	 local new_val = o(arg1,arg2,fn) 
	 update_2_d_table(memo_table,arg1,arg2,new_val)
	 return new_val
      end 
   end
   return fn
end

function lcs_oper(s1,s2) 
   local function oper(i,j,g) 
      if i == 0 or j == 0 then return 0 
      else if string.byte(s1,i) == string.byte(s2,j)
	 then 
	    return 1+g(i-1,j-1)
	 else 
	    return math.max(g(i,j-1), g(i-1,j))
	 end 
      end 
   end 
   return oper 
end 

function lcs_max(s1,s2) 
   return 
   recursively_memoize_binop(
      lcs_oper(s1,s2))(
      string.len(s1),string.len(s2))
end 

function lcs_max_substring(s1,s2)
   local f = 
      recursively_memoize_binop(lcs_oper(s1,s2))
   local function g(i,j) 
      if i > 0 and j > 0 
      then if f(i,j) == f(i-1,j) 
	 then 
	    return g(i-1,j)
	 else if f(i,j) == f(i,j-1) 
	    then 
	       return g(i,j-1)
	    else if f(i,j) == 1+f(i-1,j-1)
	       then 
		  local t = g(i-1,j-1)
		  table.insert(t, string.byte(s1,i))
		  return t 
	       end 
	    end 
	 end 
      else 
	 return {} 
      end 
   end 
   local r = string.char(unpack(g(string.len(s1),string.len(s2))))
   return string.len(r), r
end 


      
function compare_random(alphabet_size, len) 
   local s1 = random_string(start,start+alphabet_size, len)
   local s2 = random_string(start,start+alphabet_size, len)

   local a1, a2, l2

   print (s1) 
   print (s2) 
   run_timed (function () 
		 a1 = a_longest_common_substring(s1,s2)
		 print(a1) 
	      end)
   run_timed (function() 
		 l2,a2 = lcs_max_substring(s1,s2) 
		 -- was:   lcs_length(s1,s2)
		 print(l2,a2) 
	      end)
   if string.len(a1) ~= l2 
   then error(string.format("Ans 1 %s has length %d, \nbut ans 2  predicts %d", 
			    a1, string.len(a1), l2))
   end
end

function compare_random_two(alphabet_size, len) 
   local s1 = random_string(start,start+alphabet_size, len)
   local s2 = random_string(start,start+alphabet_size, len)

   local a1, a2, l2

   print (s1) 
   print (s2) 
   run_timed (function () 
		 _, a1 = lcs_length(s1,s2)
		 print(a1) 
	      end)
   run_timed (function() 
		 l2,a2 = lcs_max_substring(s1,s2) 
		 -- was:   lcs_length(s1,s2)
		 print(l2,a2) 
	      end)
   if string.len(a1) ~= l2 
   then error(string.format("Ans 1 %s has length %d, \nbut ans 2  predicts %d", 
			    a1, string.len(a1), l2))
   end
   if a1 ~= a2 then print("Ha!!, difference here") end 
end



function run_random(alphabet_size, len) 
   local s1 = random_string(start,start+alphabet_size, len)
   local s2 = random_string(start,start+alphabet_size, len)

   local a1, a2, l2

   print (s1) 
   print (s2) 
   run_timed (function() 
		 l2,a2 = lcs_max_substring(s1,s2) 
		 -- was:   lcs_length(s1,s2)
		 print(l2,a2) 
	      end)
end
