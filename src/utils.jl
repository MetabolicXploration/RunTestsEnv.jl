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