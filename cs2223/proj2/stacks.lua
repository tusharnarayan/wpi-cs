module(..., package.seeall) 

function new() 
   return { top = 0 } 
end

function empty(stack) 
   return (stack.top == 0)
end 

function push(stack, v) 
   stack.top = stack.top+1
   stack[stack.top] = v 
end 

function top(stack) 
   return stack[stack.top]
end

function pop(stack) 
   local v = stack[stack.top]
   stack.top = stack.top-1
   return v
end 



 

   