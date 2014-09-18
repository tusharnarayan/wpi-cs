require "util" 

max_char = 255

function string_of_file(pathname) 
   local f = assert(io.open(pathname,"r"))
   return f:read("*all") 
end 

function make_frequency_table() 
   local r = {} 
   for i = 1,max_char do r[i] = 0 end 
   return r 
end 


function enrich_frequency_table(t,pathname) 
   local s = string_of_file(pathname)
   for i = 1,string.len(s) do 
      local char_num = string.byte(s,i)
      t[char_num] = t[char_num]+1
   end 
end 

function print_frequency_table(t) 
   for i = 1,max_char do 
      if t[i]>0 then print(string.char(i), t[i]) end 
   end 
end 


dofile("pq2.lua")

-- A *node* is a table { freq = x, ...} 
-- It is a *leaf* if it is of the form 
-- 
-- { freq = x, char = c, ...}
-- 
-- and it is an *internal node* if it is if the form
-- 
-- { freq = x, left = node1, right = node2 ...}
-- 
-- We will assume that no table 
-- with char has either left or right, 
-- and vice versa.  

function is_leaf (node)
   if node.char then 
      return true 
   else
      return false
   end
end 

function is_internal (node) 
   if node.left then 
      return true 
   else 
      return false
   end 
end 

-- We first give a function that, given a 
-- frequency table, builds an array containing 
-- one leaf node for every non-0 character-frequency entry 

function leaves_of_frequency_table(t) 
   local result = {} 
   local j = 0 
   for i = 1, max_char do 
      if t[i]>0 then 
         result[j] = { freq = t[i], 
                       char = string.char(i) } 
         j = j+1 
      end 
   end 
   return result 
end 

function compare_nodes(n1,n2) 
   return n1.freq < n2.freq 
end 

function heap_of_frequency_table(t) 
   return build_heap(leaves_of_frequency_table(t), 
                     compare_nodes)
end 

function huffman(leaf_array) 
   local h = build_heap(leaf_array, compare_nodes)
   while 1 < h.heap_bound do 
      local l = extract_top(h) 
      local r = extract_top(h) 
      insert(h, 
             { freq = l.freq+r.freq,
               left = l, 
               right = r })
   end 
   return extract_top(h)
end 

function build(pn)
   local ft = make_frequency_table() 
   enrich_frequency_table(ft, pn)
   local leaves = leaves_of_frequency_table(ft) 
   local h = build_heap(leaves, compare_nodes)
   return huffman(h), h, leaves, ft
end 
             
function cons(new_element, list) 
   return { first = new_element, rest = list } 
end 

function binary_string_of_list(list) 
   if list and list.rest
   then 
      return string.format("%s%d", 
                           binary_string_of_list(list.rest), 
                           list.first)
   elseif list 
   then 
      return string.format("%d", list.first)
   else 
      return ""
   end 
end 





function encoding_table(huff_tree) 
   local result = {} 

   local function translate(prefix,node) 
      if is_leaf(node) 
      then 
         result[node.char] = binary_string_of_list(prefix) 
      else 
         local left_prefix   = cons(0,prefix)
         local right_prefix  = cons(1,prefix)

         translate(left_prefix, node.left)
         translate(right_prefix, node.right)
      end 
   end 

   translate(nil,huff_tree)
   return result
end 
      
q = require"queues"

function visit_bf(node) 
   local visit_q = q.new() 
   local distance = {} 
   local rep = {} 
   local aggregate_length = 0 

   local function visit_next () 
      local n = q.dequeue(visit_q) 

      if not(n) then return end 

      if is_leaf(n) 
      then 
	 print(n.char, distance[n], rep[n])
	 aggregate_length = aggregate_length + (n.freq * distance[n])
      else 
	 distance[n.left] = distance[n]+1
	 distance[n.right] = distance[n]+1
	 rep[n.left] = string.format("%s%s", rep[n], "0")
	 rep[n.right] = string.format("%s%s", rep[n], "1")

	 q.enqueue(visit_q, n.left)
	 q.enqueue(visit_q, n.right)
      end 
      visit_next(n) 
   end 
   distance[node] = 0 
   rep[node] = "" 
   q.enqueue(visit_q, node)
   visit_next(node)
   print(aggregate_length/8)
end 


   

   
tab, heap, leaves, ft = build("oliver_twist.txt")
print_frequency_table(ft)
leaves = leaves_of_frequency_table(ft) 
initial_heap = heap_of_frequency_table(ft) 
-- util.serialize(tab) 
et = encoding_table(tab)
visit_bf(tab)


tab1, heap1, leaves1, ft1 = build("trois_mousquetaires.txt")
-- print_frequency_table(ft1)
-- initial_heap = heap_of_frequency_table(ft1) 
-- serialize(tab1) 
-- et = encoding_table(tab1)

