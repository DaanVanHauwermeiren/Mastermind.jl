"""
How to run these test?
Open the REPL
goto package mode by typing `]`
activate the package environment: `activate .`
do all the tests (still in package mode): `test`
"""

using Mastermind
using Test

@testset "Mastermind.jl" verbose=true begin
    
    # this testset is maybe a bit overkill
    @testset "test elements withing Mstrmnd instance" begin
        game = Mastermind.Mstrmnd{Int}(
            Array{Int}(undef, 3, 12), 
            Tuple([1, 1, 2]),
            1,
            Tuple([1, 2, 3]),
            Vector{String}[],
            :ongoing,
            '✓',
            '-'
        )
        @test eltype(game.board) <: Int
        @test size(game.board) == (3, 12)
        @test game.solution == Tuple([1,1,2])
        @test game.round == 1
        @test game.code_pegs == Tuple([1, 2, 3])
        @test eltype(game.scores) <: String
        @test length(game.scores) == 0
        @test game.status == :ongoing
        @test game.symbol_exactmatch == '✓'
        @test game.symbol_match == '-'
    end

    @testset "test info messages" begin
        game = Mastermind.Mstrmnd{Int}(
            # 3 code, max 3 guesses
            Array{Int}(undef, 3, 3), 
            Tuple([1, 1, 2]), # correct code
            1,
            Tuple([1, 2, 3]),
            Vector{String}[],
            :ongoing,
            '✓',
            '-'
        )
        # guess something wrong: no warning
        @test_nowarn Mastermind.guess!(game, Tuple([1, 1, 3]))
        # guess correct code
        @test_logs (:info,"Congrats, you won") Mastermind.guess!(game, Tuple([1, 1, 2]))
        # no more guesses possible because of winning
        @test_logs (:info,"No need for guesses, you have won") Mastermind.guess!(game, Tuple([1, 1, 2]))

        game = Mastermind.Mstrmnd{Int}(
            # 3 code, max 3 guesses
            Array{Int}(undef, 3, 3), 
            Tuple([1, 1, 2]), # correct code
            1,
            Tuple([1, 2, 3]),
            Vector{String}[],
            :ongoing,
            '✓',
            '-'
        ) 
        # guess something wrong 3x: no warning
        @test_nowarn Mastermind.guess!(game, Tuple([1, 1, 3]))
        @test_nowarn Mastermind.guess!(game, Tuple([1, 1, 3]))
        @test_nowarn Mastermind.guess!(game, Tuple([1, 1, 3]))
        # test no more guesses possible
        @test_logs (:info,"No more guesses possible, game over!") Mastermind.guess!(game, Tuple([1, 1, 3]))

    end

    @testset "test constructor with different inputs" begin
        # code pegs defined by a tuple with different element types is not supported
        @test_throws MethodError Mastermind.Mstrmnd(Tuple([1, 2, "se"]))
        
        @test_nowarn Mastermind.Mstrmnd(Tuple([1, 2, 3]))
        @test_nowarn Mastermind.Mstrmnd(Tuple([1., 2., 3.]))
        @test_nowarn Mastermind.Mstrmnd(Tuple(["1", "2", "3"]))
        @test_nowarn Mastermind.Mstrmnd(Tuple(['1', '2', '3']))
    
        # wrong input length should thrown an AssertionError
        @test_throws AssertionError Mastermind.guess!(Mastermind.Mstrmnd(Tuple([1, 2, 3]), shape=4), Tuple([1, 1, 3]))

    end

end