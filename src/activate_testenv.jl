# macro fun
function _activate_testenv(runtests_dir)

    # loading stuf
    pkg_proj_file = Base.active_project()
    isfile(pkg_proj_file) || error("Package proj missing, expected at ", pkg_proj_file)

    pkg_man_file = joinpath(dirname(pkg_proj_file), "Manifest.toml")
    isfile(pkg_man_file) && try; Pkg.upgrade_manifest(pkg_man_file) catch; end
    
    test_proj_file = joinpath(runtests_dir, "env", "Project.toml")
    isfile(test_proj_file) || error("Test proj missing, expected at ", test_proj_file)

    test_man_file = joinpath(runtests_dir, "env", "Manifest.toml")
    isfile(test_man_file) && try; Pkg.upgrade_manifest(test_man_file) catch; end
    
    pkg_man = _read_toml(pkg_man_file) 
    test_man = _read_toml(test_man_file)

    # merging
    # pkg_man[deps] ⊆ test_man[deps]
    for (k, dat0) in pkg_man
        dat1 = get!(test_man, k, dat0)
        if dat0 isa Dict
            merge!(dat1, dat0)
        end
    end
    
    # write
    _write_toml(test_man_file, test_man)
    
    # activate
    Pkg.activate(test_proj_file)
    Pkg.resolve()
    
    # warn
    pkg_deps = get!(pkg_man, "deps", Dict())
    test_deps = get!(test_man, "deps", Dict())
    if WARN
        for (pkg, dat0) in pkg_deps
            
            haskey(test_deps, pkg) || @warn("RunTestsEnv: Package $(pkg) is missing in the test Manifest.jl")
            dat1 = first(test_deps[pkg])
            
            # versions
            ver0 = get(first(dat0), "version", "")
            isempty(ver0) && continue # ignore (usually builtin stuff)
            ver1 = get(dat1, "version", "")
            
            (ver0 != ver1) && 
                @warn("RunTestsEnv: Package $(pkg) versions missmatch, src '$(ver0)' != test '$(ver1)'")
            
        end
    end
end

# macro
export @activate_testenv
macro activate_testenv()
    __source__.file === nothing && return nothing
    _file = String(__source__.file::Symbol)
    endswith(_file, "test/runtests.jl") || 
        error("Sorry, this should be called from `test/runtests.jl`")
    _dirname = dirname(_file)
    isempty(_dirname) && error("Parent directory missing")
    _dirname = abspath(_dirname)
    _activate_testenv(_dirname)
end
