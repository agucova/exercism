struct RationalNumber{T <: Integer} <: Real
    a::T
    b::T
    function RationalNumber{T}(a, b) where {T <: Integer}
        a == b == 0 && throw(ArgumentError("The numerator and denominator can't be both zero.."))
        # Simplify the fraction
        g_c_d = gcd(a, b)
        a, b = a / g_c_d, b / g_c_d
        # Simplify signs to the numerator
        a = b < 0 ? - a : a
        b = abs(b)
    new(a, b)
    end
end 

# Shorthand for usign RationalNumber(x, y) directly
RationalNumber(x::T, y::T) where {T <: Integer} = RationalNumber{T}(x, y)

# Arithmetic and Equality
Base.:+(x::RationalNumber, y::RationalNumber) = RationalNumber(x.a * y.b + y.a * x.b, x.b * y.b)
Base.:-(x::RationalNumber, y::RationalNumber) = RationalNumber(x.a * y.b - y.a * x.b, x.b * y.b)
Base.:*(x::RationalNumber, y::RationalNumber) = RationalNumber(x.a * y.a, x.b * y.b)
Base.:/(x::RationalNumber, y::RationalNumber) = RationalNumber(x.a * y.b, x.b * y.a)
Base.://(x::RationalNumber, y::RationalNumber) = x / y
Base.:^(x::RationalNumber, n::Integer) = n >= 0 ? RationalNumber(x.a^n, x.b^n) : RationalNumber(x.b^abs(n), x.a^abs(n))
Base.:^(x::Real, y::RationalNumber) = x^(y.a / y.b)
Base.:<(x::RationalNumber, y::RationalNumber) = x.a / x.b < y.a / y.b
Base.:(==)(x::RationalNumber, y::RationalNumber) = x.a == y.a && x.b == y.b
Base.:(<=)(x::RationalNumber, y::RationalNumber) = x < y || x == y
Base.abs(r::RationalNumber) = RationalNumber(abs(r.a), abs(r.b))
Base.isinf(r::RationalNumber) = r.a in (1, -1) && r.b == 0

# Basic Identities
Base.zero(x::RationalNumber) = RationalNumber(0, 1)
Base.zero(::Type{RationalNumber{T}}) where {T <: Integer} = RationalNumber(0, 1)
Base.one(x::RationalNumber) = RationalNumber(1, 1)
Base.one(::Type{RationalNumber{T}}) where {T <: Integer} = RationalNumber(1, 1)

# Integer promotion
Base.convert(::Type{RationalNumber{T}}, x::T) where {T <: Integer} = RationalNumber{T}(x, 1)
Base.promote_rule(::Type{RationalNumber{T}}, ::Type{S}) where {T <: Integer,S <: Integer} = RationalNumber{promote_type(T, S)}

# Float promotion
Base.convert(::Type{S}, x::RationalNumber{T}) where {T <: Integer,S <: AbstractFloat} = x.a / x.b
Base.promote_rule(::Type{RationalNumber{T}}, ::Type{S}) where {T <: Integer,S <: AbstractFloat} = S

# Pretty printing
Base.show(io::IO, x::RationalNumber) = print(io, x.a, "//", x.b)

# Helper functions
Base.numerator(x::RationalNumber) = x.a
Base.denominator(x::RationalNumber) = x.b