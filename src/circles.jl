struct Circle <: SimpleDrawingObject
    ctr::ComplexF64
    rad::Float64
    props::Dict{Symbol,Any}

    function Circle(z::Number, r::Real)
        if r <= 0
            throw(ArgumentError("Radius must be positive"))
        end
        o = new(z, r, _blank_props())
        reset_attributes!(o)
        return o
    end
end

"""
    Circle(z::Number, r::Real)
    Circle(x::Real, y::Real, r::Real)

Create a circle centered at `z` [at `(x,y)`] with radius `r`.
"""
Circle(x::Real, y::Real, r::Real) = Circle(complex(x, y), r)

struct FilledCircle <: FilledObject
    ctr::ComplexF64
    rad::Float64
    props::Dict{Symbol,Any}

    function FilledCircle(z::Number, r::Real)
        if r < 0
            throw(ArgumentError("Radius may not be negative"))
        end
        d = _blank_props()
        o = new(z, r, d)
        reset_attributes!(o)
        return o
    end
end

"""
    Disk(z::Number, r::Real)
    Disk(x::Real, y::Real, r::Real)

Create a disk, i.e., a filled circle with default fill color set to `:white`.

See: `set_fillcolor!`.
"""
FilledCircle(x::Real, y::Real, r::Real) = FilledCircle(complex(x, y), r)

Disk = FilledCircle
DisC = FilledCircle

function draw(c::Circle)
    return draw_circle(c.ctr, c.rad; c.props...)
end

function draw(d::FilledCircle)
    return draw_disc(d.ctr, d.rad; d.props...)
end

show(io::IO, c::Circle) = print(io, "Circle($(c.ctr), $(c.rad))")
show(io::IO, d::FilledCircle) = print(io, "FilledCircle($(d.ctr), $(d.rad))")
