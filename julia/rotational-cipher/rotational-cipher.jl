function rotate(k::Integer, char::AbstractChar)
    0 <= k <= 26 || throw(DomainError("Key out of bounds (0 <= k <= 26)."))
    # We don't modify values outside of strictly alpha ASCII
    if char in 'A':'Z'
        return 'A' + (char + k - 'A') % 26
    elseif char in 'a':'z'
        return 'a' + (char + k - 'a') % 26
    else
        return char
    end
end    

function rotate(k::Integer, plaintext::AbstractString)
    # Multiple dispatch really makes everything cleaner!
    map(x -> rotate(k, x), plaintext)
end


for i in 0:26
    # Generate the non-standard string literals
    # Dynamically create R<i> with i = 0:26
    name = Symbol("R", i, "_str")
    @eval begin
        macro $name(plaintext)
            rotate($i, plaintext)
        end
    end
end