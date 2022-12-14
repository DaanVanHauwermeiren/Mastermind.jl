# this file is not used anymore, just for showcasing how to construct the behaviour with a fixed element type for the code pegs

mutable struct Mstrmnd
    # the board, with the shape defined in the constructor
    board::Array{Char}
    # the winning combination of items from code_pegs
    # NOTE: Tuple{Vararg{Char}} means a tuple a variable number of Strings
    solution::Tuple{Vararg{Char}}
    # the current round
    round::Int
    # code_pegs is a string of possible symbols on the board
    # this could be defined as a set, but then I would have to redefine the constructor of the solution
    # so not doing that at the moment
    code_pegs::Tuple{Vararg{Char}}
    scores::Vector{String}
    status::Symbol
    symbol_exactmatch::Char
    symbol_match::Char
end

function Mstrmnd(code_pegs::Tuple{Vararg{Char}}, shape::Int=4, max_guesses::Int=12,
    symbol_exactmatch::Char='⬛', symbol_match::Char='⬜')
    return Mstrmnd(
    # init empty board
    Array{Char}(undef, shape, max_guesses),
    # sample 4 times randomly from code_pegs
    code_pegs[rand(1:end, shape)],
    one(Int),
    code_pegs,
    Vector{String}[],
    :ongoing,
    symbol_exactmatch,
    symbol_match
    )
end

"""
check whether each of the pegs are valid: check against the allowed code_pegs field of the input Mastermind instance
NOTE: no shape check is performed
"""
function check_pegs(m::Mstrmnd, pegs::Tuple{Vararg{Char}})
    @assert all([peg in m.code_pegs for peg in pegs]) "Some pegs are not valid, check Mastermind.code_pegs"
end


"""
check the shape of a guess
just using length because of the Vector type is enforced
"""
check_shape_guess(m::Mstrmnd, pegs::Tuple{Vararg{Char}}) = @assert length(pegs) == length(m.solution) "size $(length(pegs)) found, but $(length(game.solution)) expected"

function score(m::Mstrmnd, pegs::Tuple{Vararg{Char}})
    # check exact matches at location
    exact_matches = collect(m.solution .== pegs)
    # store the scoring 
    scoring = repeat(m.symbol_exactmatch, sum(exact_matches))
    # remove the exact matches from the solution and the guess, so that
    # it possible to simply loop over the arrays
    # this might not be the best solution, but it seems to work
    remaining_solution = collect(m.solution)[.!exact_matches]
    for peg in pegs[.!exact_matches]
        # index that get the first match a peg in the remaining solution
        idx = findfirst(x->x==peg, remaining_solution)
        # if the index is not nothing, pop from the remaining solution and update the score
        if idx !== nothing
            popat!(remaining_solution, idx)
            scoring *= m.symbol_match
        end
    end
    if scoring == repeat(m.symbol_exactmatch, length(pegs))
        print("Congrats, you won")
        m.status = :won
    end
    return scoring
end

function guess!(m::Mstrmnd, pegs::Tuple{Vararg{Char}})
    # if round is larger than the shape of the board: abort because game over
    if m.round > size(m.board, 2)
        print("No more guesses possible, game over!")
        m.status = :fail
        return
    elseif m.status == :won
        print("No need for guesses, you have won")
        return
    end
    # check if the guess is valid in 2 steps
    # correct elements in the vector of pegs
    check_pegs(m, pegs)
    # correct length of the guess
    check_shape_guess(m, pegs)
    # allocate the guess
    m.board[:, m.round] = collect(pegs)
    # score the guess and return info on its correctness
    push!(m.scores, score(m, pegs))
    m.round += 1
    return m.scores[end]
end