struct RationalNumber{T <: Int} <: Real
    a::T
    b::T
    function RationalNumber{T}(a, b) where {T <: Int}
        if b == 0
            throw(ArgumentError("The denominator can't be zero."))
        end
        g_c_d = gcd(a, b)
        a, b = a / g_c_d, b / g_c_d
        a = b < 0 ? - a : a
        b = abs(b)
        new(a, b)
    end
end 

RationalNumber(x::T, y::T) where {T<:Int} = RationalNumber{T}(x, y)
 
Base.:+(x::RationalNumber, y::RationalNumber) = RationalNumber(x.a * y.b + y.a * x.b, x.b * y.b)
Base.:-(x::RationalNumber, y::RationalNumber) = RationalNumber(x.a * y.b - y.a * x.b, x.b * y.b)

Base.:*(x::RationalNumber, y::RationalNumber) = RationalNumber(x.a * y.a, x.b * y.b)

Base.:/(x::RationalNumber, y::RationalNumber) = RationalNumber(x.a * y.b, x.b * y.a)
Base.://(x::RationalNumber, y::RationalNumber) = x / y

Base.:^(x::RationalNumber, n::Integer) = n >= 0 ? RationalNumber(x.a^n, x.b^n) : RationalNumber(x.b^abs(n), x.a^abs(n))
Base.:^(x::Real, y::RationalNumber) = x^(y.a / y.b)

Base.zero(x::RationalNumber) = RationalNumber(0, 1)
Base.zero(::Type{RationalNumber{T}}) where {T<:Int} = RationalNumber(0, 1)
Base.one(x::RationalNumber) = RationalNumber(1, 1)
Base.one(::Type{RationalNumber{T}}) where {T<:Int} = RationalNumber(1, 1)

Base.abs(r::RationalNumber) = RationalNumber(abs(r.a), abs(r.b))

numerator(x::RationalNumber) = x.a
denominator(x::RationalNumber) = x.b

convert(::Type{RationalNumber{Int}}, x::Int) = RationalNumber(x, 1)

promote_rule(::Type{RationalNumber{T}}, ::Type{Int}) where {T<:Int} = RationalNumber{T}