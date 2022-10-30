# utils
function _read_toml(fn::AbstractString) 
    isfile(fn) || return Dict()
    return Pkg.TOML.parsefile(fn)
end

function _write_toml(fn::AbstractString, d::Dict)
    open(fn, "w") do io
        Pkg.TOML.print(io, d)
    end
end

# warn api
WARN = true
export version_warn
version_warn(f::Bool) = (global WARN = f)

function _man_ver(man::Dict) 
    if haskey(man, "manifest_format")
        return VersionNumber(man["manifest_format"])
    else
        return VersionNumber("1.0")
    end
end

function _man_deps(man::Dict)
    ver = _man_ver(man)
    if ver.major == 1
        return man
    elseif ver.major == 2
        return man["deps"]
    end
end
