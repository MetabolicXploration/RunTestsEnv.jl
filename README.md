# RunTestsEnv

[![Build Status](https://github.com/MetabolicXploration/RunTestsEnv.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/MetabolicXploration/RunTestsEnv.jl/actions/workflows/CI.yml?query=branch%3Amain)
<!--  [![Coverage](https://codecov.io/gh/MetabolicXploration/RunTestsEnv.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/MetabolicXploration/RunTestsEnv.jl) -->

This package helps to manage a `test/env/Project.toml` test environment.
The main use case is when you need some `dev`ed packages for the tests which aren't (or can’t be) direct dependencies (e.g. because circular dependency).
It SHOULD work with `dev` packages if `Manifest.toml`s are included (locally it's easy, but on `CI` you need to track either a repo or use some kind of relative path system).

It export a single macro `@activate_testenv`, if placed at the top of the `runtests.jl` file it will do the follow: 
  1. Merge the package `Manifest.toml` (if any) with the `test/env/Manifest.toml` (if any) so `test/env/Manifest.toml` becomes a super set of the former (this allows to have test specific dependencies but load the original deps from the package).
  2. Call `Pkg.activate(test/env/Project.toml)`
  3. Call `Pkg.resolve()` and HOPE the `Pkg` solves any minor version issue (in the best case do nothing).

> NOTE: The macro is intended to be call at the beginning of the `runtests.jl` file before importing anything (It check a few stuff and may complain)

The user is responsible to keep sync all `Project.toml`s and `Manifest.toml`s.
The main danger is that you test your code using different versions (which shouldn’t happen if only `Project.toml`s are involved).
The macro will warn you when both `Manifest.toml` have different versions, but this could be ok due to the new test-specific dependencies.

See [here](https://github.com/MetabolicXploration/MetXNetHub.jl/blob/main/test/runtests.jl) for an use case (solving a circular dependency)


