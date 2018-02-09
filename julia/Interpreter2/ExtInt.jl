module ExtInt

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

type If0Node <: AE
  condition::AE
  zero_branch::AE
  nonzero_branch::AE
end

type BindingNode <: AE
	sym::Symbol
	binding_expr::AE
end

type WithNode <: AE
  nodes::Array{BindingNode}
  body::AE
end

type VarRefNode <: AE
  sym::Symbol
end

type FuncDefNode <: AE
  formal::Symbol
  fun_body::AE
end

type FuncAppNode <: AE
  fun_expr::AE
  arg_expr::AE
end


abstract type RetVal end

abstract type Environment end

type NumVal <: RetVal
  n::Real
end

type ClosureVal <: RetVal
  formal::Symbol
  body::AE
  env::Environment
end

#
# =======ENVIRONMENTS===========
#

type EmptyEnv <: Environment
end

type ExtendedEnv <: Environment
  dict::Dict
  parent::Environment
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
# ===========DICTIONARY===============
#

myDict = Dict(
:+ => +,
:-  => -,
:* => *,
:/ => /,
:mod => mod,
:collatz => collatz)


function grabFunction(expr::Symbol)
	try
		return myDict[expr]
	catch
		throw(LispError("Function not in Dictionary"))
	end
end
#
# ===========PARSE===============
#

function parse( expr::Number )
    return Num( expr )
end

function parse( expr::Symbol )
    return VarRefNode( expr )
end

function parse( expr::Array{Any} )

	if expr[1] == :with
		tempArray = []
		for i = 1:length(expr[2])
			node = BindingNode(expr[2][i][1], parse(expr[2][i][2]))
			push!(tempArray, node)
		end
		return WithNode( tempArray, parse(expr[3]))

	elseif expr[1] == :lambda
		return FuncDefNode( expr[2], parse(expr[3]) )
	end

	if length(expr) > 4
		throw(LispError("Too many expressions!"))

	elseif length(expr) == 4
		if(expr[1] == :if0)
			return If0Node(parse(expr[2]), parse(expr[3]), parse(expr[4]))
		end

    elseif length(expr) == 3
		if (expr[1] != :collatz) && (expr[1] != :mod)
			return Binop( grabFunction(expr[1]), parse( expr[2] ), parse( expr[3] ) )
		else
			throw(LispError("Too many expressions"))
		end

    elseif length(expr) == 2
		if (expr[1] == :collatz) || (expr[1] == :mod) || (expr[1] == :-)
			return Unop(grabFunction(expr[1]), parse(expr[2]))
		else
			throw(LispError("Too few expressions"))
		end

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

function calc( ast::Num, env::Environment )
    return NumVal(ast.n)
end

function calc(ast::Binop, env::Environment)
	if (ast.op == /) && calc(ast.rhs, env) == 0
		throw(LispError("Cannot divide by Zero"))
	else
    	return ast.op(calc(ast.lhs, env).n, calc(ast.rhs, env).n)
	end
end

function calc(ast::Unop, env::Environment)
	if (ast.op == collatz) && calc(ast.lhs, env) <= 0
		throw(ListError("Collatz must be > 0"))
	else
		return ast.op(calc(ast.lhs, env))
	end
end

function calc( ast::If0Node, env::Environment )
    cond = calc( ast.cond, env )
    if cond == 0
        return calc( ast.zerobranch, env )
    else
        return calc( ast.nzerobranch, env )
    end
end

function calc( ast::WithNode, env::Environment )
	tempDict = Dict()
	for i = 1:length(ast.nodes)
		tempDict[ast.nodes[i].sym] = ast.nodes[i].binding_expr
	end
    ext_env = ExtendedEnv(tempDict, env )
    return calc( ast.body, ext_env )
end

function calc( ast::VarRefNode, env::EmptyEnv )
    throw( Error.LispError("Undefined variable " * string( ast.sym )) )
end

function calc( ast::VarRefNode, env::ExtendedEnv )
	try
		return env.dict[ast.sym]
	catch
		return calc( ast, env.parent )
	end

	# if isdefined(env.dict[ast.sym])
    #     return env.dict[ast.sym]
    # else
    #     return calc( ast, env.parent )
    # end
end

function calc( ast::FuncDefNode, env::Environment )
    return ClosureVal( ast.formal, ast.body , env )
end

function calc( ast::FuncAppNode, env::Environment )
    closure_val = calc( ast.fun_expr, env )
    actual_parameter = calc( ast.arg_expr, env )
    ext_env = ExtendedEnv( closure_val.formal,
                           actual_parameter,
                           closure_val.env )
    return calc( closure_val.body, ext_env )
end

#
# =============INTERPRETE=======================
#

function interp( cs::AbstractString )
    lxd = Lexer.lex( cs )
    ast = parse( lxd )
	env = EmptyEnv();
    return calc( ast, env )
end

end #module
