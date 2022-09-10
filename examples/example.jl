using Pkg
# activate the environment in the folder where this file resides
# NOTE: this is NOT the GH main directory
Pkg.activate(@__DIR__)
Pkg.add("Revise")
# add the package Mastermind in the folder above in develop mode
Pkg.develop(path=(@__DIR__)*"/../")

using Revise
using Mastermind

code_pegs = Tuple(['🔵',  '🟤',  '🟢',  '🟣',  '🟡',  '🔴'])
symbol_exactmatch = '⬛'
symbol_match = '⬜'

# init a game
game = Mastermind.Mstrmnd(code_pegs)
game.status
game.solution
Mastermind.guess!(game, Tuple(['🟢', '🟣', '🟣', '🟡']))
game.round
game.scores
guess!(game, Tuple(['🔴', '🟣', '🟣', '🟡']))
guess!(game, Tuple(['🟢', '🟣', '🟡', '🟡']))
guess!(game, Tuple(['🟢', '🔴', '🟡', '🟡']))
guess!(game, Tuple(['🟢', '🔴', '🟡', '🟤']))

game

# available methods for the struct
methods(Mastermind.Mstrmnd)
# modules that have been import from the module
# names(x::Module; all::Bool = false, imported::Bool = false)
# source : https://discourse.julialang.org/t/how-do-i-get-a-list-of-functions-defined-in-a-module/22266
names(Mastermind; all=false, imported=false)