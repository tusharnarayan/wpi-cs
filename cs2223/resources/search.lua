require "util" 

dofile "sorting_updated.lua"

function s(a,bot,top,v) 
   local mid = math.floor((bot+top)/2)
   local mid_val = a[mid] 

   if mid_val == v then return mid end 
   if top == bot   then return false end 

   if v < mid_val 
   then 
      return s(a, bot, mid, v) 
   else
      return s(a, mid+1, top, v)
   end 
end 

function s_top(a,v) 
   return s(a,1,#a,v)
end 