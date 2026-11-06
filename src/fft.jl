function loadfft(f::AbstractString)
    open(f) do s
        loadfft(s)
    end
end

function loadfft(s::IOStream)
    f, = match(r"<file (.+)>", s.name)
    f, _ = splitext(f)
    f *= ".inf"
    meta = loadinf(f)
    data = Array{ComplexF64}(undef, meta[:nt])
    read!(s, data)
    meta, data
end
