function loaddat(f::AbstractString)
    open(f) do s
        loaddat(s)
    end
end

function loaddat(s::IOStream)
    f, = match(r"<file (.+)>", s.name)
    f, _ = splitext(f)
    f *= ".inf"
    meta = loadinf(f)
    data = Array{Float32}(undef, meta[:nt])
    read!(s, data)
    meta, data
end
