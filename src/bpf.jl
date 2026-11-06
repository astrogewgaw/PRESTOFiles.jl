function loadbpf(f::AbstractString)
    open(f) do s
        loadbpf(s)
    end
end

function loadbpf(s::IOStream)
end
