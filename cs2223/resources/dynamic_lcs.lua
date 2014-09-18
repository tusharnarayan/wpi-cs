--[[

Two strings and 
some longest common substrings

ngynahfipoej
fopkkwycnccq

fo

2	yn

also: 

toghukdmilwc
ndstaxuswxip
tuw

3	tui

--]] 


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
	   g(i-1,j)
	 else if f(i,j) == f(i,j-1) 
	    then 
	       g(i,j-1)
	    else if f(i,j) == 1+f(i-1,j-1)
	       then 
		  g(i-1,j-1)
		  io.write(string.sub(s1,i,i))
	       end 
	    end 
	 end 
      end 
   end 
   io.write(string.format("\nLength %d\nSubstring: ", 
			  f(string.len(s1),string.len(s2))))
   g(string.len(s1),string.len(s2))
   io.write("\n\n")
end 

function lcs_iter(s1,s2) 
   local t = {} 
   function install_val(i,j) 
      if i == 0 or j == 0 
      then update_2_d_table(t,i,j,0)
      else if string.byte(s1,i) == string.byte(s2,j)
	 then 
	    update_2_d_table(t,i,j,
			     1 + access_2_d_table(t,i-1,j-1))
	 else 
	    update_2_d_table(t,i,j,
			     math.max(access_2_d_table(t,i,j-1), 
				      access_2_d_table(t,i-1,j)))
	 end 
      end 
   end 
   
   for i = 0,string.len(s1) do 
      for j = 0,string.len(s2) do 
	 install_val(i,j)
      end 
   end 
   return t
end 

function lcs_iter_len(s1,s2)
   local t = lcs_iter(s1,s2)
   return access_2_d_table(t,string.len(s1),
			   string.len(s2))
end 

function lcs_iter_str(s1,s2)
   local t = lcs_iter(s1,s2)
   local function g(i,j) 
      if i > 0 and j > 0 
      then local val_i_j = access_2_d_table(t,i,j)
	 if val_i_j == access_2_d_table(t,i-1,j)
	 then 
	    g(i-1,j)
	 else if val_i_j == access_2_d_table(t,i,j-1)
	    then 
	       g(i,j-1)
	    else if val_i_j == 1+access_2_d_table(t,i-1,j-1)
	       then 
		  g(i-1,j-1)
		  io.write(string.sub(s1,i,i))
	       else 
		  error("Huh?") 
	       end 
	    end 
	 end
      end
   end 
   io.write(string.format(
	       "\nLength %d\nSubstring: ", 
	       access_2_d_table(t,string.len(s1),string.len(s2))))
   g(string.len(s1),string.len(s2))
   io.write("\n\n")
end 


function lcs_quick(len)
   local s1 = random_string(97,97+25, len)
   local s2 = random_string(97,97+25, len)

   --   print ("s1:", s1) 
   --   print ("s2:", s2) 
   local t0 = os.clock() 
   lcs_iter_str(s1,s2)
   print("time: ", os.clock()-t0)
end 



