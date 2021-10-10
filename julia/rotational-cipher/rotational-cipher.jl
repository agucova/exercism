function rotate(k::Integer, char::AbstractChar)
    if ! (0 <= k <= 26)
        throw(DomainError("Key out of bounds (0 <= k <= 26)."))
    end
    # We don't modify values outside of strictly alpha ASCII
    if isascii(char) && isletter(char)
        # Implements the wrap-around behaviour with char arithmetic
        if isuppercase(char)
            return Char((codepoint(char) + k - 65) % 26 + 65)
        else
            return Char((codepoint(char) + k - 97) % 26 + 97)
        end
    else
        return char
    end
end    

function rotate(k::Integer, plaintext::AbstractString)
    # Multiple dispatch really makes everything cleaner!
    ciphertext = ""
    for char in plaintext
        # Wanted to use the dot operator for this, 
        # but apparently it passes strings instead of chars.
        ciphertext *= rotate(k, char)
    end
    ciphertext
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