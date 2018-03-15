
defmodule Fibb do
    def fib(1) do 1 end
    def fib(0) do 1 end
    def fib(n) do
        fib(n-1) + fib(n-2)
    end
end

defmodule Area do
    def area(:square, {side_length}}) do
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

end

defmodule SquareList do
    def sqrList(list) do
        for n <- list do
            n * n
        end
    end
end

defmodule Calculate do
    def calcTotals([list]) do
        for n <- list do
            calcTotal(n)
        end
    end

    def calcTotals({:item, quantity, price}) do
        {:item, (quantity * price)}
    end
end

defmodule MapFunction do
    def map(function, vals) do
        for n <- vals do
            function.(n)
        end
    end
end

defmodule Server do
    def quickSortServer() do
        receive do
            {message, list} -> send(pid, {qsort(list),self()})
        end
        quickSortServer()
    end

    def sendList(pid, list) do
        #get random pivot, and send
        send(pid, {list, self()})
        waitForList()
    end

    def waitForList() do
        recieve do
            {list, pid} -> list
        end
    end
end

defmodule QSort do
    def qsort([]) do [] end
    def qsort([pivot|rest]) do
        smaller = for n <- rest, n < pivot do n end
        larger = for n <- rest, n >= pivot do n end
        qsort(smaller) ++ [pivot] ++ qsort(larger)
    end
end
