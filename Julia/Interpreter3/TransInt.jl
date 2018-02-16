module TransInt

push!(LOAD_PATH, pwd())

using Error
using Lexer
export parse, calc, interp, analyze, NumVal, ClosureVal
#
# ===========TYPES================
#

abstract type AE
end

type PlusNode <: AE
	op::Function
	nums::Array{AE}
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
  cond::AE
  zerobranch::AE
  nzerobranch::AE
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
  formal::Array{Symbol}
  fun_body::AE
end

type FuncAppNode <: AE
  fun_expr::AE
  arg_expr::Array{AE}
end


abstract type RetVal end

abstract type Environment end

type NumVal <: RetVal
  n::Real
end

type ClosureVal <: RetVal
  formal::Array{Symbol}
  body::AE
  env::Environment
end

#
# =======ENVIRONMENTS===========
#

type EmptyEnv <: Environment
end

type ExtendedEnv <: Environment
  dict::Dict{Symbol, RetVal}
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
:collatz => collatz,
:if0 => +,
:with => +)


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
	try
		grabFunction(expr)
	catch
		return VarRefNode( expr )
	end
	throw(LispError("Symbol cannot be id"))
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
		if !isa(expr[2], Array)
			throw(LispError("Not an Array!!"))
		end
		if length(expr[2]) != length(unique(expr[2]))
			throw(LispError("Unique Value Error!"))
		end
		# if !mapreduce(x-> type(x) == Symbol && !(x in keys), (r, l) -> r && l, true, expr[2])
		# 	throw(LispError("Not a symbol or it is a keywork"))
		# end
		return FuncDefNode( expr[2], parse(expr[3]) )
	elseif expr[1] == :+
		if(length(expr) < 3)
			throw(LispError("Too few Arguments!"))
		end
		return PlusNode(+, map(x->parse(x), expr[2:end]))
	elseif expr[1] == :and
		parsed = parse(expr[length(expr)])
		ifNode = If0Node(parsed, Num(0), Num(1))
		for i = length(expr)-1:1
			parsed = parse(expr[i])
			ifNode = If0Node(parsed, 0, ifNode)
		end
		return ifNode
	end

	binaryOps = Symbol[:-, :/, :*, :mod]
	unaryOps = Symbol[:collatz]

	if length(expr) > 4
		throw(LispError("Too many expressions!"))

	elseif length(expr) == 4
		if(expr[1] == :if0)
			return If0Node(parse(expr[2]), parse(expr[3]), parse(expr[4]))
		end

    elseif expr[1] in binaryOps
		if length(expr) == 3
			return Binop( grabFunction(expr[1]), parse( expr[2] ), parse( expr[3] ) )
		elseif length(expr) == 2 && expr[1] == :-
			return Binop( grabFucntion(expr[1]), 0, parse(expr[2]))
		else
			throw(LispError("Too many expressions"))
		end

    elseif expr[1] in unaryOps
		if length(expr) == 2
			if (expr[1] == :collatz) && calc(parse(expr[2]), EmptyEnv()).n <= 0
				throw(LispError("Collatz must be > 0"))
			else
				return Unop(grabFunction(expr[1]), parse(expr[2]))
			end
		else
			throw(LispError("Too few expressions"))
		end

	else
    	parsed = map(x->parse(x), expr)
		return FuncAppNode(parsed[1], parsed[2:end])
	end
end

function parse( expr::Any )
  throw( LispError("Invalid type $expr") )
end

#
# ===========CALCULATE===============
#

function calc(ast::AE)
	return calc(ast, EmptyEnv())
end

function calc( ast::Num, env::Environment )
    return NumVal(ast.n)
end

function calc(ast::PlusNode, env::Environment)
	sum = 0
	for i = 1:length(ast.nums)
		sum = sum + calc(ast.nums[i]).n
	end
	return NumVal(sum)
end

function calc(ast::Binop, env::Environment)
	if (ast.op == /) && calc(ast.rhs, env).n == 0
		throw(LispError("Cannot divide by Zero"))
	else
		leftNum = calc(ast.lhs, env)
		rightNum = calc(ast.rhs, env)
		if typeof(leftNum) != NumVal || typeof(rightNum) != NumVal
			throw(LispError("Incorrect Type!"))
		end
    	return NumVal(ast.op(leftNum.n, rightNum.n))
	end
end

function calc(ast::Unop, env::Environment)
	return NumVal(ast.op(calc(ast.lhs, env).n))
end

function calc( ast::If0Node, env::Environment )
    cond = calc( ast.cond, env ).n
    if cond == 0
        return calc( ast.zerobranch, env )
    else
        return calc( ast.nzerobranch, env )
    end
end

function calc( ast::WithNode, env::Environment )
	tempDict = Dict()
	for i = 1:length(ast.nodes)
		tempDict[ast.nodes[i].sym] = calc(ast.nodes[i].binding_expr, env)
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
    return ClosureVal( ast.formal, ast.fun_body , env )
end

function calc( ast::FuncAppNode, env::Environment )
    closure_val = calc( ast.fun_expr, env )
	if typeof(closure_val) == ClosureVal
	    actual_parameter = map(x-> calc(x, env), ast.arg_expr)
		D = Dict(zip(closure_val.formal, actual_parameter))
		return calc(closure_val.body, ExtendedEnv(D, closure_val.env))
	else
		throw(LispError("Not A closureVal"))
	end
end

#
# =============ANALYZE=======================
#
function analyze(ast::AE)
	return ast
end

function analyze(ast::Num)
	return ast
end

function analyze(ast::VarRefNode)
	return ast
end

function analyze(ast::PlusNode)
	return PlusNode(+, map(x->analyze(x), ast.nums))
end

function analyze(ast::Binop)
	return Binop(ast.op, analyze(ast.lhs), analyze(ast.rhs))
end

function analyze(ast::Unop)
	return Unop(ast.op, analyze(ast.lhs))
end

function analyze(ast::If0Node)
	return If0Node(analyze(ast.cond), analyze(ast.zerobranch), analyze(ast.nzerobranch))
end

function analyze(ast::FuncDefNode)
	return FuncDefNode(ast.formal, analyze(ast.fun_body))
end

function analyze(ast::FuncAppNode)
	FuncAppNode(analyze(ast.fun_expr), map(x->analyze(x), ast.arg_expr))
end

function analyze(ast::WithNode)
	formals = map(x->x.sym, ast.nodes)
	args = map(x->analyze(x.binding_expr) , ast.nodes)
	return FuncAppNode(FuncDefNode(formals, analyze(ast.body)), args)
end
#
# =============INTERPRETE=======================
#

function interp( cs::AbstractString )
    lxd = Lexer.lex( cs )
    ast = parse( lxd )
	ast = analyze(ast)
	env = EmptyEnv();
    return calc( ast, env )
end

end #module
