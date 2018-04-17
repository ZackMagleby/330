import Data.Array

-- Type Signature
isPrime :: Int -> Bool
isPrime n = null([x| x <- [2..iSqrt(n)], n `mod` x == 0])

-- Type Signature
primes :: [Int]
primes = [x|x <- [2..], isPrime(x)]

-- Type Signature
isPrimeFast :: Int -> Bool
isPrimeFast 2 = True
isPrimeFast n = null([ x | x <- takeWhile( <= iSqrt(n) ) primesFast, n `mod` x == 0])

-- Type Signature
primesFast :: [Int]
primesFast = [x|x <- [2..], isPrimeFast(x)]

iSqrt :: Int-> Int
iSqrt n = floor(sqrt(fromIntegral n))

-- Type Signature
lcsLength :: String -> String -> Int
lcsLength s1 s2 = a!(length(s1), length(s2)) where 
	a = array ((0,0), (length(s1), length(s2))) 
		([((0,j), 0) | j <- [0..length(s2)]] ++
		[((i,0), 0) | i <- [1..length(s1)]] ++
		[((i,j), if s1!!(i-1) == s2!!(j-1) then a!(i-1, j-1) +1 else max (a!(i-1,j)) (a!(i, j-1)))
			| i <- [1..length(s1)], j <- [1..length(s2)]])