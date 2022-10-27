using RunTestsEnv
# @activate_testenv # Like this (see comment below)

using Test


@testset "RunTestsEnv.jl" begin

    # only a test pkg
    @test_throws ArgumentError @eval using SparseArrays

    # Usually you'll place this below 'using RunTestsEnv'
    # and use the macro '@activate_testenv'
    RunTestsEnv._activate_testenv(@__DIR__)

    # now it works
    @eval using SparseArrays
    @test sprand(5, 5, 0.1) isa SparseMatrixCSC

end
