using Match

function loadinf(f::AbstractString)
    open(f) do s
        loadinf(s)
    end
end

function loadinf(s::IOStream)
    meta = Dict()
    onoffs = Vector()
    notes = String("")
    for line in readlines(s)
        m = match(r"\s+(.+?)\s+=\s+(.+)"i, line)
        if isnothing(m)
            strip(line) == "Any additional notes:" || (notes = notes * " " * strip(line))
        else
            d, v = m
            @match d begin
                "Data file name without suffix" => (meta[:filename] = String(v))
                "Telescope used" => (meta[:telescope] = String(v))
                "Instrument used" => (meta[:instrument] = String(v))
                "Object being observed" => (meta[:object] = String(v))
                "J2000 Right Ascension (hh:mm:ss.ssss)" => (meta[:ra] = String(v))
                "J2000 Declination     (dd:mm:ss.ssss)" => (meta[:dec] = String(v))
                "Data observed by" => (meta[:observer] = String(v))
                "Epoch of observation (MJD)" => (meta[:mjd] = parse(Float64, v))
                "Barycentered?           (1=yes, 0=no)" => (meta[:barycentered] = Bool(parse(Int64, v) != 0))
                "Barycentered?           (1 yes, 0 no)" => (meta[:barycentered] = Bool(parse(Int64, v) != 0))
                "Number of bins in the time series" => (meta[:nt] = parse(Int64, v))
                "Width of each time series bin (sec)" => (meta[:dt] = parse(Float64, v))
                "Any breaks in the data? (1=yes, 0=no)" => (meta[:breaks] = Bool(parse(Int64, v) != 0))
                "Any breaks in the data? (1 yes, 0 no)" => (meta[:breaks] = Bool(parse(Int64, v) != 0))
                "Type of observation (EM band)" => (meta[:emband] = String(v))
                "Beam diameter (arcsec)" => (meta[:beamdiam] = parse(Float64, v))
                "Dispersion measure (cm-3 pc)" => (meta[:dm] = parse(Float64, v))
                "Central freq of low channel (MHz)" => (meta[:f₀] = parse(Float64, v))
                "Total bandwidth (MHz)" => (meta[:Δf] = parse(Float64, v))
                "Number of channels" => (meta[:nf] = parse(Int64, v))
                "Channel bandwidth (MHz)" => (meta[:δf] = parse(Float64, v))
                "Field-of-view diameter (arcsec)" => (meta[:fov] = parse(Float64, v))
                "Central energy (kev)" => (meta[:E₀] = parse(Float64, v))
                "Energy bandpass (kev)" => (meta[:ΔE] = parse(Float64, v))
                "Photometric filter used" => (meta[:photofilter] = String(v))
                "Central wavelength (nm)" => (meta[:λ₀] = parse(Float64, v))
                "Bandpass (nm)" => (meta[:Δλ] = parse(Float64, v))
                "Data analyzed by" => (meta[:analyst] = String(v))
                _ => push!(onoffs, parse.(Int64, split(v, ",")))
            end
        end
    end
    meta[:onoffs] = onoffs
    meta[:notes] = strip(notes)
    meta
end
