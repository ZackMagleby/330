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

# <AE> ::= <number>
type Num <: AE
    n::Real
end

# <AE> ::= (+ <AE> <AE>)
type PlusNode <: AE
    lhs::AE
    rhs::AE
end

# <AE> ::= (- <AE> <AE>)
type MinusNode <: AE
    lhs::AE
    rhs::AE
end

type MultiplyNode <: AE
    lhs::AE
    rhs::AE
end

type DivideNode <: AE
    lhs::AE
    rhs::AE
end

#
# ===========PARSE===============
#

function parse( expr::Number )
    return Num( expr )
end

function parse( expr::Array{Any} )

    if expr[1] == :+
        return Binop( +, parse( expr[2] ), parse( expr[3] ) )

    elseif expr[1] == :-
        return Binop(-, parse( expr[2] ), parse( expr[3] ) )

    elseif expr[1] == :*
        return Binop(*, parse( expr[2] ), parse(expr[3]))

    elseif expr[1] == :/
		if count(parse(expr[3])) == 0
			throw(LispError("Cannot divide by zero!"))
		end
        return Binop(/, parse( expr[2] ), parse(expr[3]))
    end

    throw(LispError("Unknown operator!"))
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
    return ast.op(ast.lhs, ast.rhs)
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
