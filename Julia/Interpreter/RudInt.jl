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

# <AE> ::= <number>
type Num <: AE
    n::Real
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

	elseif expr[1] == :mod
		return Binop(mod, parse( expr[2] ), parse(expr[3]))

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
