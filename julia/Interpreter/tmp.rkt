module RudInt

push!(LOAD_PATH, pwd())

using Error
using Lexer
export parse, calc, interp
#
# ===========TYPES================
#
abstract type AE
end

type Binop <: AE
	op::Function
	lhs::AE
	rhs::AE
end

type Unop <: AE
	op::Function
	lhs::AE
end

# <AE> ::= <number>
type Num <: AE
    n::Real
end

#
# =======COLLATZ DEFINITION============
#

function collatz( n::Real )
  return collatz_helper( n, 0 )
end

function collatz_helper( n::Real, num_iters::Int )
  if n == 1
    return num_iters
  end
  if mod(n,2)==0
    return collatz_helper( n/2, num_iters+1 )
  else
    return collatz_helper( 3*n+1, num_iters+1 )
  end
end

#
# ===========PARSE===============
#

function parse( expr::Number )
    return Num( expr )
end

function parse( expr::Array{Any} )

	if length(expr) > 3
		throw(LispError("Too many expressions!"))

    elseif expr[1] == :+
        return Binop( +, parse( expr[2] ), parse( expr[3] ) )

    elseif expr[1] == :-
		println(expr[3])
        return Binop(-, parse( expr[2] ), parse( expr[3] ) )

    elseif expr[1] == :*
        return Binop(*, parse( expr[2] ), parse(expr[3]))

    elseif expr[1] == :/
		if calc(parse(expr[3])) == 0
			throw(LispError("Cannot divide by zero!"))
		end
        return Binop(/, parse( expr[2] ), parse(expr[3]))

	elseif expr[1] == :mod
		return Binop(mod, parse( expr[2] ), parse(expr[3]))

	elseif expr[1] == :collatz
		return Unop(collatz, parse(expr[2]));

	else
    	throw(LispError("Unknown operator!"))
	end
end

function parse( expr::Any )
  throw( LispError("Invalid type $expr") )
end

#
# ===========CALCULATE===============
#

function calc( ast::Num )
    return ast.n
end

function calc(ast::Binop)
    return ast.op(calc(ast.lhs), calc(ast.rhs))
end

function calc(ast::Unop)
	return ast.op(calc(ast.lhs))
end

#
# =============INTERPRETE=======================
#

function interp( cs::AbstractString )
    lxd = Lexer.lex( cs )
    ast = parse( lxd )
    return calc( ast )
end

end #module



function lexParse(str)
  RudInt.parse(Lexer.lex(str))
end

function parseInter(str)
  RudInt.calc(lexParse(str))
end

function removeNL(str)
  replace(string(str), "
", "")
end

function testerr(f, param)
  try
    return removeNL(f(param))
  catch Y
    return "Error"
  end
end

println(testerr(lexParse, "(+ 1 2)"))
println(testerr(lexParse, "(- 1 2)"))
println(testerr(lexParse, "+ 1 2"))
println(testerr(lexParse, "(a)"))

println(testerr(parseInter, "(- 1 2)"))
println(testerr(parseInter, "(* 1 2)"))
println(testerr(parseInter, "(collatz -1)"))
println(testerr(parseInter, "(/ 1 0)"))
