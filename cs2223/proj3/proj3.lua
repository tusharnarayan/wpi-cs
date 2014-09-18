-- Project 3: Implementing a Securities Market
-- Tushar Narayan
-- tnarayan@wpi.edu

--[[

Prototype tables and their operations:

BuyOrder{ security = "Universal", bid = 185.32,
          amt = 100, buyer = "Mr B"}

SellOrder{ security = "Universal", quote = 185.32,
           amt = 300, seller = "Ms S"}

Transact{ security = "Universal", sale_price = 185.32,
          amt = 300, buyer = "Mr B", seller = "Ms S" }

--]]

utils = require "util"

pq = require "pq"

dofile "testorders.lua" --the file with test buy and sell orders

-- comparison function for the sell orders
function sellCompFunc (stable1, stable2)
	return stable1.quote < stable2.quote
end

-- comparison function for the buy orders
function buyCompFunc (btable1, btable2)
	return btable1.bid > btable2.bid
end

-- book for Universal security
-- initialized to empty buyOrders and sellOrders
Universal = {
	BuyOrders = pq.build_heap({}, buyCompFunc),
	SellOrders = pq.build_heap({}, sellCompFunc)
}

-- market for all books
-- initialized to empty securities
market = {}

-- transaction log to record all transactions that occur in the market
TransactionLog = {}

-- function to execute a transaction using tops of the heaps, if possible
function execute_one_transaction(book)
	--do both heaps have at least one element?
	if not(#book.SellOrders > 0 and #book.BuyOrders > 0) then
	--nothing can be done, market is in equilibrium
	return false
	else
		--look at the top of the two heaps
		sellOrdersTop = pq.find_top(book.SellOrders)
		buyOrdersTop = pq.find_top(book.BuyOrders)
		--if no transaction is possible because bid below quote, do nothing
		if buyOrdersTop.bid < sellOrdersTop.quote then
			return false --equilibrium achieved
		--else take smaller of two quantities:
		else
			---if some buy order remaining, decrease quantity and discard sell order
			if sellOrdersTop.amt < buyOrdersTop.amt then
				smaller_quantity = sellOrdersTop.amt --store smaller quantity for entry into Transaction Log later
				book.BuyOrders[1].amt = buyOrdersTop.amt - sellOrdersTop.amt
				pq.delete(book.SellOrders, 1)
			----if sell order has larger quantity, decrease that and discard buy order
			elseif sellOrdersTop.amt > buyOrdersTop.amt then
				smaller_quantity = buyOrdersTop.amt --store smaller quantity for entry into Transaction Log later
				book.SellOrders[1].amt = sellOrdersTop.amt - buyOrdersTop.amt
				pq.delete(book.BuyOrders, 1)
			----if equal, both used up (aka discard both)
			else
				smaller_quantity = buyOrdersTop.amt --values equal, store either one for entry into Transaction Log later
				pq.delete(book.SellOrders, 1)
				pq.delete(book.BuyOrders, 1)
			end
			--insert transaction at the end of the transaction log
			--[[
			table.insert takes table, index (which is existing size + 1 in this case,
			so that the new record gets added at the end), and data to insert
			--]]
			table.insert(TransactionLog, #TransactionLog + 1,
				{security = sellOrdersTop.security , sale_price = buyOrdersTop.amt,
				amt = smaller_quantity, buyer = buyOrdersTop.buyer,
				seller = sellOrdersTop.seller})
			return true --more transactions may still be possible
		end
	end
end

-- function to bring the book to equilibrium
function bring_to_equilibrium(book)
	can_transact = true -- flag to indicate if transactions are possible; start assuming true
	-- execute transactions until equilibrium (continue to look for more transactions until none possible)
	while(can_transact) do
		can_transact = execute_one_transaction(book)
	end
end

-- function to bring the market to equilibrium
function bring_market_to_equilibrium(market)
	for k, v in pairs(market) do
		bring_to_equilibrium(v.book)
	end
end

-- function to accept a new buy order
function BuyOrder(buyOrder)
   -- install a new buy order table for the appropriate security
   -- by putting it in the right priority queue (heap)
   foundSecurity = false -- flag to indicate if security already exists, assume it doesn't
   for k, v in pairs(market) do -- check if book for security exists in market
		if(v.security == buyOrder.security) then
			pq.insert(v.book.BuyOrders, buyOrder) -- insert buy order in the book
			foundSecurity = true -- set flag
			-- then bring that security's book to equilibrium
			bring_to_equilibrium(v.book)
		end
	end
	if(foundSecurity == false) then -- security not encountered previously
	-- make new book in market associated with this security
	-- insert the buy order in the buyOrders priority queue (heap)
	-- initialize sellOrders priority queue (heap) to empty
		table.insert(market, #market + 1,
			{security = buyOrder.security,
				book = {BuyOrders = pq.build_heap({buyOrder}, buyCompFunc),
						SellOrders = pq.build_heap({}, sellCompFunc)}})
		bring_market_to_equilibrium(market) -- bring the market to equilibrium - why not?
		-- equilibrium is actually not required (since just one order currently exists), but why not?
	end
end

-- function to accept a new sell order
function SellOrder(sellOrder)
   -- install a new sell order table for the appropriate security
   -- by putting it in the right priority queue (heap)
   foundSecurity = false -- flag to indicate if security already exists, assume it doesn't
   for k, v in pairs(market) do -- check if book for security exists in market
		if(v.security == sellOrder.security) then
			pq.insert(v.book.SellOrders, sellOrder)  -- insert sell order in the book
			foundSecurity = true -- set flag
			-- then bring that security's book to equilibrium
			bring_to_equilibrium(v.book)
		end
	end
	if(foundSecurity == false) then -- security not encountered previously
	-- make new book in market associated with this security
	-- insert the sell order in the sellOrders priority queue (heap)
	-- initialize buyOrders priority queue (heap) to empty
		table.insert(market, #market + 1,
			{security = sellOrder.security,
				book = {BuyOrders = pq.build_heap({}, buyCompFunc),
						SellOrders = pq.build_heap({sellOrder}, sellCompFunc)}})
		bring_market_to_equilibrium(market) -- bring the market to equilibrium - why not?
		-- equilibrium is actually not required (since just one order currently exists), but why not?
	end
end

-- function to print tables recursively
function printTable(inputTable)
	-- helper function that prints a table
    local function printTableHelper(subTable, formatString)
	--[[
	For every key, value pair in the table
	if the value is not a table, print the key and value pair
	if the value is a table, call the helper recursively with the inner table
	--]]
	-- formatString is a string to recursively increase
	-- indentation on every recursive call
        for k,v in pairs(subTable) do
            if (type(v) == "table") then
				print(formatString..tostring(k))
                printTableHelper(v, formatString.."\t")
			else
				print(formatString..tostring(k),":", v)
            end
        end
    end
	-- actual function just calls the helper with initial values
    io.write("{")
	printTableHelper(inputTable, "");
	io.write("}\n")
end

--[[
Test cases.
Note that this is from a run that had a market with the Universal security.
Universal security in turn has the orders from testorders.lua.
However, since these orders were added via hardcode, the market
was not brought to equilibrium. The purpose was to demonstrate the
bring_to_equilibrium function that brings a book to equilibrium; and to
check the details of the Transaction Log.
Subsequently, the market and Universal security were initialized to empty,
to allow custom market files to be used for testing.

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj3"
> printTable(TransactionLog)
{}
> printTable(market)
{1
        book
                SellOrders
                        1
                                quote   :       14.56
                                amt     :       350
                                seller  :       Mr C
                                security        :       Universal
                        2
                                quote   :       109.66
                                amt     :       25
                                seller  :       Mr J
                                security        :       Universal
                        3
                                quote   :       181
                                amt     :       150
                                seller  :       Mr A
                                security        :       Universal
                        4
                                quote   :       111.89
                                amt     :       50
                                seller  :       Mr I
                                security        :       Universal
                        5
                                quote   :       121.5
                                amt     :       400
                                seller  :       Mr E
                                security        :       Universal
                        6
                                quote   :       1888.1
                                amt     :       750
                                seller  :       Mr F
                                security        :       Universal
                        7
                                quote   :       1678
                                amt     :       950
                                seller  :       Mr G
                                security        :       Universal
                        8
                                quote   :       567
                                amt     :       100
                                seller  :       Mr H
                                security        :       Universal
                        9
                                quote   :       178.77
                                amt     :       1500
                                seller  :       Mr D
                                security        :       Universal
                        10
                                quote   :       1345.67
                                amt     :       200
                                seller  :       Mr B
                                security        :       Universal
                        compare :       function: 00421138
                        heap_bound      :       10
                BuyOrders
                        1
                                bid     :       7585.89
                                amt     :       170
                                buyer   :       Ms U
                                security        :       Universal
                        2
                                bid     :       2345.39
                                amt     :       800
                                buyer   :       Ms S
                                security        :       Universal
                        3
                                bid     :       1210.32
                                amt     :       10
                                buyer   :       Ms X
                                security        :       Universal
                        4
                                bid     :       185.32
                                amt     :       450
                                buyer   :       Ms Y
                                security        :       Universal
                        5
                                bid     :       854.12
                                amt     :       60
                                buyer   :       Ms Q
                                security        :       Universal
                        6
                                bid     :       120.32
                                amt     :       150
                                buyer   :       Ms Z
                                security        :       Universal
                        7
                                bid     :       120.22
                                amt     :       104
                                buyer   :       Ms T
                                security        :       Universal
                        8
                                bid     :       172.32
                                amt     :       1560
                                buyer   :       Ms W
                                security        :       Universal
                        9
                                bid     :       120.2
                                amt     :       750
                                buyer   :       Ms R
                                security        :       Universal
                        10
                                bid     :       143.67
                                amt     :       160
                                buyer   :       Ms V
                                security        :       Universal
                        compare :       function: 00420FB8
                        heap_bound      :       10
        security        :       Universal
}
> bring_to_equilibrium(market[1].book)
> printTable(market)
{1
        book
                SellOrders
                        1
                                quote   :       178.77
                                amt     :       835
                                seller  :       Mr D
                                security        :       Universal
                        2
                                quote   :       567
                                amt     :       100
                                seller  :       Mr H
                                security        :       Universal
                        3
                                quote   :       181
                                amt     :       150
                                seller  :       Mr A
                                security        :       Universal
                        4
                                quote   :       1678
                                amt     :       950
                                seller  :       Mr G
                                security        :       Universal
                        5
                                quote   :       1345.67
                                amt     :       200
                                seller  :       Mr B
                                security        :       Universal
                        6
                                quote   :       1888.1
                                amt     :       750
                                seller  :       Mr F
                                security        :       Universal
                        compare :       function: 00421138
                        heap_bound      :       6
                BuyOrders
                        1
                                bid     :       172.32
                                amt     :       1560
                                buyer   :       Ms W
                                security        :       Universal
                        2
                                bid     :       143.67
                                amt     :       160
                                buyer   :       Ms V
                                security        :       Universal
                        3
                                bid     :       120.32
                                amt     :       150
                                buyer   :       Ms Z
                                security        :       Universal
                        4
                                bid     :       120.22
                                amt     :       104
                                buyer   :       Ms T
                                security        :       Universal
                        5
                                bid     :       120.2
                                amt     :       750
                                buyer   :       Ms R
                                security        :       Universal
                        compare :       function: 00420FB8
                        heap_bound      :       5
        security        :       Universal
}
> printTable(TransactionLog)
{1
        sale_price      :       170
        seller  :       Mr C
        amt     :       170
        buyer   :       Ms U
        security        :       Universal
2
        sale_price      :       620
        seller  :       Mr C
        amt     :       180
        buyer   :       Ms S
        security        :       Universal
3
        sale_price      :       595
        seller  :       Mr J
        amt     :       25
        buyer   :       Ms S
        security        :       Universal
4
        sale_price      :       545
        seller  :       Mr I
        amt     :       50
        buyer   :       Ms S
        security        :       Universal
5
        sale_price      :       145
        seller  :       Mr E
        amt     :       400
        buyer   :       Ms S
        security        :       Universal
6
        sale_price      :       145
        seller  :       Mr D
        amt     :       145
        buyer   :       Ms S
        security        :       Universal
7
        sale_price      :       10
        seller  :       Mr D
        amt     :       10
        buyer   :       Ms X
        security        :       Universal
8
        sale_price      :       60
        seller  :       Mr D
        amt     :       60
        buyer   :       Ms Q
        security        :       Universal
9
        sale_price      :       450
        seller  :       Mr D
        amt     :       450
        buyer   :       Ms Y
        security        :       Universal
}

================================================================================

Tests with empty market and Universal:
Notice that the Universal variable is not being updated, since the market has been
implemented. However, the security Universal in the market is updated, as expected.

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj3"
> printTable(TransactionLog)
{}
> printTable(market)
{}
> printTable(Universal)
{SellOrders
        heap_bound      :       0
        compare :       function: 00415F08
BuyOrders
        heap_bound      :       0
        compare :       function: 00415F28
}
> BuyOrder({security = "Universal", bid = 751.54, amt = 5000, buyer = "Ms P"})
> printTable(Universal)
{SellOrders
        heap_bound      :       0
        compare :       function: 00415F08
BuyOrders
        heap_bound      :       0
        compare :       function: 00415F28
}
> printTable(market)
{1
        book
                SellOrders
                        heap_bound      :       0
                        compare :       function: 00415F08
                BuyOrders
                        1
                                bid     :       751.54
                                amt     :       5000
                                buyer   :       Ms P
                                security        :       Universal
                        compare :       function: 00415F28
                        heap_bound      :       1
        security        :       Universal
}
> printTable(TransactionLog)
{}
> SellOrder({security = "Universal", quote = 750.57, amt = 4000, seller = "Mr Q"
})
> printTable(market)
{1
        book
                SellOrders
                        compare :       function: 00415F08
                        heap_bound      :       0
                BuyOrders
                        1
                                bid     :       751.54
                                amt     :       1000
                                buyer   :       Ms P
                                security        :       Universal
                        compare :       function: 00415F28
                        heap_bound      :       1
        security        :       Universal
}
> printTable(TransactionLog)
{1
        sale_price      :       1000
        seller  :       Mr Q
        amt     :       4000
        buyer   :       Ms P
        security        :       Universal
}

================================================================================
Test cases for BuyOrder and SellOrder:

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj3"
> SellOrder({security = "Universal", quote = 178.77, amt = 1500, seller = "Mr D"
})
> SellOrder({security = "Universal", quote = 109.66, amt = 25, seller = "Mr J"})

> printTable(market)
{1
        book
                SellOrders
                        1
                                quote   :       109.66
                                amt     :       25
                                seller  :       Mr J
                                security        :       Universal
                        2
                                quote   :       178.77
                                amt     :       1500
                                seller  :       Mr D
                                security        :       Universal
                        heap_bound      :       2
                        compare :       function: 00416348
                BuyOrders
                        heap_bound      :       0
                        compare :       function: 00416428
        security        :       Universal
}
> SellOrder({security = "Universal", quote = 111.89, amt = 50, seller = "Mr I"})

> printTable(market)
{1
        book
                SellOrders
                        1
                                quote   :       109.66
                                amt     :       25
                                seller  :       Mr J
                                security        :       Universal
                        2
                                quote   :       178.77
                                amt     :       1500
                                seller  :       Mr D
                                security        :       Universal
                        3
                                quote   :       111.89
                                amt     :       50
                                seller  :       Mr I
                                security        :       Universal
                        compare :       function: 00416348
                        heap_bound      :       3
                BuyOrders
                        heap_bound      :       0
                        compare :       function: 00416428
        security        :       Universal
}
> BuyOrder({security = "Universal", bid = 120.32, amt = 150, buyer = "Ms Z"})
> BuyOrder({security = "Universal", bid = 143.67, amt = 160, buyer = "Ms V"})
> BuyOrder({security = "Universal", bid = 120.20, amt = 750, buyer = "Ms R"})
> printTable(market)
{1
        book
                SellOrders
                        1
                                quote   :       178.77
                                amt     :       1500
                                seller  :       Mr D
                                security        :       Universal
                        compare :       function: 00416348
                        heap_bound      :       1
                BuyOrders
                        1
                                bid     :       143.67
                                amt     :       160
                                buyer   :       Ms V
                                security        :       Universal
                        2
                                bid     :       120.32
                                amt     :       75
                                buyer   :       Ms Z
                                security        :       Universal
                        3
                                bid     :       120.2
                                amt     :       750
                                buyer   :       Ms R
                                security        :       Universal
                        compare :       function: 00416428
                        heap_bound      :       3
        security        :       Universal
}
> printTable(TransactionLog)
{1
        sale_price      :       125
        seller  :       Mr J
        amt     :       25
        buyer   :       Ms Z
        security        :       Universal
2
        sale_price      :       75
        seller  :       Mr I
        amt     :       50
        buyer   :       Ms Z
        security        :       Universal
}

================================================================================
Tests for market code, using the following commands:

>dofile "testmarket.lua"
--after output printed, the following commands were used to check state
--of the market and the transaction log:
>printTable(market)
>printTable(TransactionLog)

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> dofile "testmarket.lua"
{}
{}
{1
        book
                SellOrders
                        heap_bound      :       0
                        compare :       function: 002CFDD0
                BuyOrders
                        1
                                bid     :       863.57
                                amt     :       38
                                buyer   :       Ms L
                                security        :       Universal
                        2
                                bid     :       120.32
                                amt     :       50
                                buyer   :       Ms H
                                security        :       Universal
                        3
                                bid     :       134.57
                                amt     :       150
                                buyer   :       Ms G
                                security        :       Universal
                        compare :       function: 002CFBB0
                        heap_bound      :       3
        security        :       Universal
}
{}
{1
        book
                SellOrders
                        1
                                quote   :       981
                                amt     :       67
                                seller  :       Mr B
                                security        :       Universal
                        2
                                quote   :       1289.23
                                amt     :       234
                                seller  :       Mr T
                                security        :       Universal
                        3
                                quote   :       11981
                                amt     :       7
                                seller  :       Mr W
                                security        :       Universal
                        compare :       function: 002CFDD0
                        heap_bound      :       3
                BuyOrders
                        1
                                bid     :       134.57
                                amt     :       77
                                buyer   :       Ms G
                                security        :       Universal
                        2
                                bid     :       120.32
                                amt     :       50
                                buyer   :       Ms H
                                security        :       Universal
                        compare :       function: 002CFBB0
                        heap_bound      :       2
        security        :       Universal
}
{1
        sale_price      :       38
        seller  :       Mr A
        amt     :       38
        buyer   :       Ms L
        security        :       Universal
2
        sale_price      :       77
        seller  :       Mr A
        amt     :       73
        buyer   :       Ms G
        security        :       Universal
}
{1
        book
                SellOrders
                        1
                                quote   :       981
                                amt     :       67
                                seller  :       Mr B
                                security        :       Universal
                        2
                                quote   :       1289.23
                                amt     :       234
                                seller  :       Mr T
                                security        :       Universal
                        3
                                quote   :       11981
                                amt     :       7
                                seller  :       Mr W
                                security        :       Universal
                        compare :       function: 002CFDD0
                        heap_bound      :       3
                BuyOrders
                        1
                                bid     :       134.57
                                amt     :       77
                                buyer   :       Ms G
                                security        :       Universal
                        2
                                bid     :       120.32
                                amt     :       50
                                buyer   :       Ms H
                                security        :       Universal
                        compare :       function: 002CFBB0
                        heap_bound      :       2
        security        :       Universal
2
        book
                SellOrders
                        1
                                quote   :       1
                                amt     :       52
                                seller  :       Mr U
                                security        :       WPI
                        2
                                quote   :       181
                                amt     :       15
                                seller  :       Mr Y
                                security        :       WPI
                        3
                                quote   :       11
                                amt     :       7
                                seller  :       Mr R
                                security        :       WPI
                        compare :       function: 002CFDD0
                        heap_bound      :       3
                BuyOrders
                        compare :       function: 002CFBB0
                        heap_bound      :       0
        security        :       WPI
}
{1
        sale_price      :       38
        seller  :       Mr A
        amt     :       38
        buyer   :       Ms L
        security        :       Universal
2
        sale_price      :       77
        seller  :       Mr A
        amt     :       73
        buyer   :       Ms G
        security        :       Universal
3
        sale_price      :       8
        seller  :       Mr R
        amt     :       8
        buyer   :       Mr L
        security        :       WPI
4
        sale_price      :       80
        seller  :       Mr U
        amt     :       80
        buyer   :       Mr K
        security        :       WPI
5
        sale_price      :       18
        seller  :       Mr U
        amt     :       18
        buyer   :       Mr W
        security        :       WPI
}



> printTable(market)
{1
        book
                SellOrders
                        1
                                quote   :       981
                                amt     :       67
                                seller  :       Mr B
                                security        :       Universal
                        2
                                quote   :       1289.23
                                amt     :       234
                                seller  :       Mr T
                                security        :       Universal
                        3
                                quote   :       11981
                                amt     :       7
                                seller  :       Mr W
                                security        :       Universal
                        compare :       function: 002CFDD0
                        heap_bound      :       3
                BuyOrders
                        1
                                bid     :       134.57
                                amt     :       77
                                buyer   :       Ms G
                                security        :       Universal
                        2
                                bid     :       120.32
                                amt     :       50
                                buyer   :       Ms H
                                security        :       Universal
                        compare :       function: 002CFBB0
                        heap_bound      :       2
        security        :       Universal
2
        book
                SellOrders
                        1
                                quote   :       1
                                amt     :       34
                                seller  :       Mr U
                                security        :       WPI
                        2
                                quote   :       181
                                amt     :       15
                                seller  :       Mr Y
                                security        :       WPI
                        3
                                quote   :       11
                                amt     :       7
                                seller  :       Mr R
                                security        :       WPI
                        4
                                quote   :       190
                                amt     :       45
                                seller  :       Mr V
                                security        :       WPI
                        compare :       function: 002CFDD0
                        heap_bound      :       4
                BuyOrders
                        compare :       function: 002CFBB0
                        heap_bound      :       0
        security        :       WPI
3
        book
                SellOrders
                        1
                                quote   :       231
                                amt     :       86
                                seller  :       Mr B
                                security        :       Facebook
                        heap_bound      :       1
                        compare :       function: 002CFDD0
                BuyOrders
                        1
                                bid     :       87
                                amt     :       8
                                buyer   :       Mr I
                                security        :       Facebook
                        2
                                bid     :       85.5
                                amt     :       3
                                buyer   :       Mr G
                                security        :       Facebook
                        3
                                bid     :       85.57
                                amt     :       62
                                buyer   :       Mr N
                                security        :       Facebook
                        compare :       function: 002CFBB0
                        heap_bound      :       3
        security        :       Facebook
}
> printTable(TransactionLog)
{1
        sale_price      :       38
        seller  :       Mr A
        amt     :       38
        buyer   :       Ms L
        security        :       Universal
2
        sale_price      :       77
        seller  :       Mr A
        amt     :       73
        buyer   :       Ms G
        security        :       Universal
3
        sale_price      :       8
        seller  :       Mr R
        amt     :       8
        buyer   :       Mr L
        security        :       WPI
4
        sale_price      :       80
        seller  :       Mr U
        amt     :       80
        buyer   :       Mr K
        security        :       WPI
5
        sale_price      :       18
        seller  :       Mr U
        amt     :       18
        buyer   :       Mr W
        security        :       WPI
6
        sale_price      :       18
        seller  :       Mr U
        amt     :       18
        buyer   :       Mr C
        security        :       WPI
7
        sale_price      :       71
        seller  :       Mr D
        amt     :       12
        buyer   :       Mr N
        security        :       Facebook
8
        sale_price      :       9
        seller  :       Mr B
        amt     :       9
        buyer   :       Mr E
        security        :       Facebook
9
        sale_price      :       67
        seller  :       Mr F
        amt     :       4
        buyer   :       Mr N
        security        :       Facebook
10
        sale_price      :       62
        seller  :       Mr H
        amt     :       5
        buyer   :       Mr N
        security        :       Facebook
}
--]]
