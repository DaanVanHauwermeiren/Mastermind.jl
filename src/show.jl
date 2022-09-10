function Base.show(io::IO, ::MIME"text/plain", z::Mstrmnd)
    println(io, "A game of Mastermind:")
    println(io, "The code has a length of $(size(z.board, 1)), with a maximum of $(size(z.board, 2)) tries, entries use the datatype $(eltype(z.board))")
    if z.round > 1
        println(io, "The guesses so far are:")
        Base.show(io, MIME"text/plain"(), z.board[:,1:z.round-1])
    end
end
