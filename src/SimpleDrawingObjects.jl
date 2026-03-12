module SimpleDrawingObjects
using SimpleDrawing, Plots

import SimpleDrawing: draw
import Base: show

export SimpleDrawingObject,
    FilledObject,
    Arc,
    Arrow,
    Circle,
    ClosedCurve,
    Disk,
    Ellipse,
    FilledCircle,
    FilledClosedCurve,
    FilledEllipse,
    FilledPolygon,
    FilledRectangle,
    OpenCurve,
    Point,
    Polygon,
    PolygonalPath,
    Rectangle,
    Segment,
    get_attributes,
    reset_attributes!,
    set_attribute!,
    set_fillalpha!,
    set_fillcolor!,
    set_linecolor!,
    set_linestyle!,
    set_linewidth!,
    set_pointcolor!,
    set_pointsize!

"""
    SimpleDrawingObject

Parent abstract type for all geometric objects defined in `SimpleDrawingObjects`.
"""
abstract type SimpleDrawingObject end

"""
    FilledObject

Subtype of `SimpleDrawingObject` for geometric objects that can be filled with color. 
"""
abstract type FilledObject <: SimpleDrawingObject end

include("segments.jl")
include("polygons.jl")
include("path.jl")
include("circles.jl")
include("ellipses.jl")
include("arcs.jl")
include("curves.jl")
include("points.jl")
include("attributes.jl")

function draw(os::Vector{T}) where {T<:SimpleDrawingObject}
    if length(os) == 0
        finish()
        return nothing
    end
    for o in os
        draw(o)
    end
    return finish()
end

"""
    _mush(xs::Vector{S}, ys::Vector{T}) where {S,T <: Real}

Combine lists of real numbers into a list of complex numbers. 
"""
function _mush(xs::Vector{S}, ys::Vector{T}) where {S,T<:Real}
    if length(xs) != length(ys)
        throw(ArgumentError("The two lists of numbers must be the same length"))
    end

    return xs + im * ys
end

end # module DrawingObjects
