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


   

function weighted_interval_sched(value,pred_compat) 
   local function sched_oper(j, opt) 
      if j<1 
      then
	 return 0 
      else 
	 return 
	 math.max(value[j]+opt(pred_compat[j]),
		  opt(j-1))
      end 
   end 
   return sched_oper
end 

v1 = {2,4,4,7,2,1}
p1 = {0,0,1,0,3,3} 

compute_opt = 
   recursively_memoize_oper(weighted_interval_sched(v1,p1))



function print_opt_schedule(value,pred_compat)
   local f = recursively_memoize_oper(weighted_interval_sched(value,pred_compat)) 
   local function printer(j) 
      if 1 <= j 
      then if f(j) == f(j-1) 
	 then 
	    printer(j-1)
	 else 
	    printer(pred_compat[j])
	    print(j)
	 end 
      end 
   end 
   printer(#value)
end 
     
--  
-- 
--[[
 pred_compat = {0,0,0,1,0,2,3,5}
 value = {2,4,4,7,2,1,5,6}
 compute_opt = 
   recursively_memoize_oper(
     weighted_interval_sched)
--]]
   
local coi_memo_table = { [0] = 0 } 

function compute_opt_iter(value,pred_compat,j) 
   if coi_memo_table[j] 
   then 
      return coi_memo_table[j]
   else 
      for i = 1,j do 
	 coi_memo_table[i] = 
	    math.max(
	    value[i] + 
	       coi_memo_table[pred_compat[i]],  
	    coi_memo_table[i-1])
      end 
   end 
   return coi_memo_table[j]
end 

function print_opt_schedule_iter(value,pred_compat,j) 
   if 1 <= j 
   then if compute_opt_iter(value,pred_compat,j) ==
      compute_opt_iter(value,pred_compat,j-1) 
      then 
	 print_opt_schedule_iter(value,pred_compat,j-1)
      else 
	 print_opt_schedule_iter(value,pred_compat,pred_compat[j])
	 print(j)
      end 
   end 
end 

