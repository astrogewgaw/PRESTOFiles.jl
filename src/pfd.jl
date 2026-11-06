using OrderedCollections

str(s) = String(read(s, read(s, Int32)))
str(s, n) = rstrip(String(read(s, n)), Char(0))

function loadpfd(f::AbstractString)
    open(f) do s
        loadpfd(s)
    end
end

function loadpfd(s::IOStream)
    meta = Dict()
    for (key, typ) in pairs(
        OrderedDict(
            :ndms => Int32,
            :nperiods => Int32,
            :npdots => Int32,
            :nsub => Int32,
            :npart => Int32,
            :nbin => Int32,
            :nchan => Int32,
            :pstep => Int32,
            :pdstep => Int32,
            :dmstep => Int32,
            :ndmfact => Int32,
            :npfact => Int32,
            :filename => String,
            :candname => String,
            :telescope => String,
            :pgdev => String,
            :ra => String,
            :dec => String,
            :dt => Float64,
            :T₀ => Float64,
            :Tₙ => Float64,
            :tepoch => Float64,
            :bepoch => Float64,
            :vavg => Float64,
            :f₀ => Float64,
            :df => Float64,
            :bestdm => Float64,
        ))
        if (key == :ra) || (key == :dec)
            meta[key] = str(s, 16)
        else
            meta[key] = (typ == String) ? str(s) : read(s, typ)
        end
    end
    for key in [:topo, :bary, :fold]
        meta[key] = Dict(subkey => read(s, subtyp) for (subkey, subtyp) in pairs(
            OrderedDict(
                :power => Float64,
                :p => Float64,
                :pd => Float64,
                :pdd => Float64,
            )))
    end
    meta[:orb] = Dict(key => read(s, typ) for (key, typ) in pairs(
        OrderedDict(
            :p => Float64,
            :e => Float64,
            :x => Float64,
            :w => Float64,
            :t => Float64,
            :pd => Float64,
            :wd => Float64,
        )))
    for key in [:dms, :periods, :pdots]
        meta[key] = read!(s, Array{Float64}(undef, meta[Symbol("n", key)]))
    end
    data = read!(s, Array{Float64}(undef, (meta[:nsub], meta[:npart], meta[:nbin])))
    meta[:stats] = read!(s, Array{Float64}(undef, (7, meta[:nsub], meta[:npart])))
    meta, data
end
