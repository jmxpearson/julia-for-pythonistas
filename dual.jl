immutable Dual <: Real
    val::Float64
    adj::Float64
end

Base.show(io::IO, x::Dual) = print(io, "$(x.val) + $(x.adj)ϵ")

Base.convert(::Type{Dual}, x::Real) = Dual(x, 0)  # first argument is not named, but is if type Type{Dual}
Base.convert(::Type{Dual}, x::Dual) = x  # corner case, since Dual <: Real

Base.promote_rule(::Type{Float64}, ::Type{Dual}) = Dual
Base.promote_rule(::Type{Int64}, ::Type{Dual}) = Dual
Base.promote_rule(::Type{Float32}, ::Type{Dual}) = Dual

import Base: +, -, /, *, abs, <, ==, <=
+(x::Dual, y::Dual) = Dual(x.val + y.val, x.adj + y.adj)
-(x::Dual) = Dual(-x.val, -x.adj)
-(x::Dual, y::Dual) = x + -y
*(x::Dual, y::Dual) = Dual(x.val * y.val, x.val * y.adj + x.adj + y.val)
/(x::Dual, y::Dual) = Dual(x.val/y.val, x.adj/y.val - (x.val * y.adj)/y.val^2)
abs(x::Dual) = x.val > 0 ? x : -x
==(x::Dual, y::Dual) = x.val == y.val && x.adj == y.adj
<(x::Dual, y::Dual) = x.val == y.val ? x.adj < y.adj : x.val < y.val
<=(x::Dual, y::Dual) = x < y || x == y

import Base.log
log(x::Dual) = Dual(log(x.val), x.adj/x.val)
