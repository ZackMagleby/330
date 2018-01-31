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

# <AE> ::= <number>
type NumNode <: AE
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

#
# ===========PARSE===============
#

function parse( expr::Number )
    return NumNode( expr )
end

function parse( expr::Array{Any} )

    if expr[1] == :+
        return PlusNode( parse( expr[2] ), parse( expr[3] ) )

    elseif expr[1] == :-
        return MinusNode( parse( expr[2] ), parse( expr[3] ) )

    end

    throw(LispError("Unknown operator!"))
end

function parse( expr::Any )
  throw( LispError("Invalid type $expr") )
end

#
# ===========CALCULATE===============
#

function calc( ast::NumNode )
    return ast.n
end

function calc( ast::PlusNode )
    return calc( ast.lhs ) + calc( ast.rhs )
end

function calc( ast::MinusNode )
    return calc( ast.lhs ) - calc( ast.rhs )
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
