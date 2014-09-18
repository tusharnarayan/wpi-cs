function time(f,arg) 
   local t0 = os.clock() 
   local v = f(arg) 
   local t1 = os.clock() 

   print("Arg", arg, "val:", v, 
	 "time", t1-t0)
   return v
end 

function fib(n) 
   if n == 1 then return 1 
   else if n == 2 then return 1 
      else return fib(n-1)+fib(n-2)
      end 
   end
end 

function memoize(f)
   local memo_table = {} 
   function f_memoized(arg) 
      local cached = memo_table[arg] 
      if cached then return cached 
      else 
	 local new_val = f(arg) 
	 memo_table[arg] = new_val 
	 return new_val
      end 
   end
   return f_memoized
end

fibm = memoize(fib)

function fib_oper(n,g) 
   if n == 1 then return 1 
   else if n == 2 then return 1 
      else return g(n-1)+g(n-2)
      end 
   end
end 

function CHAOS(n) 
   return CHAOS(n) 
end

function fib2 (n) 
   return fib_oper(n,CHAOS)
end 

function fib3 (n) 
   return fib_oper(n,fib2)
end 

function fib4 (n) 
   return fib_oper(n,fib3)
end 

function fib_rec(n) 
   return fib_oper(n,fib_rec)
end 
      
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

fib_rm = 
   recursively_memoize_oper(
    fib_oper)



function fib_iter(n) 
   local function f(v1,v2,rest) 
      if rest == 0 then return v2
      else return f(v2,v1+v2,rest-1)
      end 
   end 

   if n == 1 then return 1 
   else if n == 2 then return 1 
      else return f(1,1,n-2)
      end 
   end 
end 


-- for i = 1,38 do io.write(fib(i), "  "); io.flush() end 

-- for i = 1,38 do time(fib,i) end 
-- for i = 1,38 do time(fibm,i) end 

-- for i = 1,38 do time(fib_rec,i) end 

-- local f = memoize(fib) for i = 1,38 do time(f,i) end 

-- for i = 1,38 do time(fib_rm,i) end 


-- for i = 1,38 do time(fib_iter,i) end 
