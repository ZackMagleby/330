defmodule Elixir_Intro do

def fib(1) do 1 end
def fib(0) do 0 end
def fib(n) do
	fib(n-1) + fib(n-2)
end


#=======================================

def area(:square, {side_length}) do
	side_length * side_length
end

def area(:rectangle, {length, height}) do
	length * height
end

def area(:circle, {radius}) do
	(radius * radius) * :math.pi
end

def area(:triangle, {base, height}) do
	(base * height) / 2
end

#================================================

def sqrList(list) do
	for n <- list do
		n * n
	end
end

#================================================

def calcTotals(list) do
	for {item, quantity, price} <- list do
		{item, (quantity * price)}
	end
end

#================================================

def map(function, vals) do
	for n <- vals do
		function.(n)
	end
end

#================================================

def quickSortServer() do
	receive do
		{list, pid} -> send(pid, {qsort(list),self()})
	end
	quickSortServer()
end

#================================================

def qsort([]) do [] end
def qsort(list) do
	pivot = Enum.random(list)
	rest = list --[pivot]
	smaller = for n <- rest, n < pivot do n end
	larger = for n <- rest, n >= pivot do n end
	qsort(smaller) ++ [pivot] ++ qsort(larger)
end

end
