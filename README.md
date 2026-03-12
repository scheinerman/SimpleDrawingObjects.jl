# SimpleDrawingObjects

This is a companion module to [SimpleDrawing](https://github.com/scheinerman/SimpleDrawing.jl).
Its purpose is to simplify the drawing of basic shapes. 

## Introduction

This module defines some basic shapes (such as `Circle`) that can be endowed with attributes (such as line thickness and color). The underlying visualization of these objects is provided by [Plots](https://docs.juliaplots.org/stable/).

The general workflow is to (1) create a shape, (2) specify appearance attributes for that shape, and (3) visualize it using the `draw` function.

### Example
```
using SimpleDrawingObjects, SimpleDrawing
C = Circle(2-im, 3)         # circle centered at (2,-1) with radius 3
set_linecolor!(C, :red)     
set_linewidth!(C, 2)
set_linestyle!(C, :dash)
newdraw()                   # erases the drawing window (from SimpleDrawing)
draw(C)                     # draws the circle
```
Here is the result:

![](circle_example.png)

Note that the center of the circle is specified as a complex number. Alternatively, we 
could have used `Circle(2,-1,3)`. Note that `Circle(2,3)` is understood as `Circle(2+0im,3)` and 
would create a circle centered at `(2,0)`.

### Comparison

The same image (only using `SimpleDrawing`) could be accomplished like this:
```
draw_circle(2-im, 3, color=:red, linestyle=:dash, width=2)
```

The advantage of using a `SimpleDrawingObject` is that its appearance attributes (color, line width, etc.) can be modified.


## Supported Objects  

* Line Segments
    * `Segment` 
    * `Arrow` (a `Segment` with an arrow at one end)
* Polygons
    * `Polygon`, `FilledPolygon`
    * `Rectangle`, `FilledRectangle` (for axis-parallel rectangles)
    * `PolygonalPath` (unfilled, not closed)
* Circles
    * `Circle`, `FilledCircle` 
    * `Arc` (arc of a circle)
    * `Ellipse`, `FilledEllipse`
* Spline Curves
    * `OpenCurve` 
    * `ClosedCurve`
    * `FilledClosedCurve`
* Points
    * `Point`

More information on each of these is provided below. 

## Drawing objects

The `draw` function causes the object to be drawn on the screen. 

The `draw` function may be applied to a list (vector) of objects, in which case the objects
in the list are drawn in the order presented.

## Attributes

Each `SimpleDrawingObject` has attributes that affect how it is drawn. The following methods are provided for setting object attributes:
* `set_linecolor!(o, c)` assigns the line color `c` to `o`. Default: `:black`
* `set_linewidth!(o, w)` sets the line thickness of the lines drawn to be `w`. Default: `1`. 
* `set_linestyle!(o, style)` sets the line style of `o` to `style`. Default: `solid`. 

These functions pertain only to `Point`s:
* `set_pointsize!(p, sz)` pertains only to `Point`s and sets the size of the `Point`. Default: `2`.
* `set_pointcolor!(p, col)` pertains only to `Point`s and sets the color of the `Point`. Defaut: `:black`. 

These functions pertain only to filled objects:
* `set_fillcolor!(o, col)` sets the interior color to `col`. Default: `:white`.
* `set_fillalpha!(o, α)` sets the transparency of the fill to `α`. Note that `α = 0` is completely transparent and `α = 1` is completely opaque. Default: `1`.


More generally, use `set_attribute!(o, attr, val)` to set `o`'s attribute `attr` to the value `val`. Use with caution. 

Use `reset_attributes!(o)` to return `o` to its "factory default" attributes. 

The function `get_attributes(o)` returns a view into `o`'s attribute dictionary which can then be directly manipulated (if you dare).

More information on object attributes can be found in the [Plots](https://docs.juliaplots.org/stable/generated/attributes_series/) documentation. 


## Line Segments

Create a new line segment using one of these:
* `Segment(a, b)` where `a` and `b` are complex numbers.
* `Segment(x, y, xx, yy)` where the arguments are real numbers; this creates a segment from `(x,y)` to `(xx,yy)`.

* `Arrow(a, b)` creates a line segment from `a` to `b` with an arrowhead at `b`. This is equivalent to:
    * `s = Segment(a, b)`
    * `set_attribute!(s, :arrow, true)`

## Polygons

Polygons are created from a list of complex numbers. The following are equivalent
* `Polygon([1-2im, 3+im, 4, -1-im])`
* `Polygon(1-2im, 3+im, 4, -1-im)`
* `Polygon([1,3,4,-1], [-2,1,0,-1])`



The convenience function `Rectangle` creates an axis-parallel rectangle. 
* `Rectangle(a, b)` creates a rectangle with opposite corners at `a` and `b` (as complex numbers).
* `Rectangle(x, y, xx, yy)` creates a rectangle with opposite corners `(x,y)` and `(xx,yy)`. 

The interior of a `Polygon` is blank. To create a filled-in polygon, use `FilledPolygon` (as well as `FilledRectangle`).

A polygon with `n` sides is defined using `n` points. The last point in the list is joined to the
first to create a closed figure. We also provide this function:
* `PolygonalPath(pts)` to create a polygonal path in which the last point is not joined to the first.

## Circular Shapes

### Circles
Circles are created from a center and a radius:
* `Circle(z, r)` is the circle centered at (complex) `z` with radius `r`. 
* `Circle(x, y, r)` is the circle centered at `(x,y)` with radius `r`. 


A `FilledCircle` is a circle whose interior has a color. Like circles, create with one of these:
* `FilledCircle(z, r)`
* `FilledCircle(x, y, r)`

`Disk` is a synonym for `FilledCircle`.

### Arcs

Arcs of circles are created with `Arc(ctr, rad, t1, t2, t3)` where:
* `ctr` is (complex) the center of the circle,
* `rad` is the radius of the circle,
* `t1` is the starting angle for the arc,
* `t2` is an angle for a point inside the arc, and
* `t3` is the ending angle for the arc.

We require the intermediante angle `t2` because simply specifying the end points of the arc does not determine which piece of the circle we are considering. 

The center can also be specified as two real numbers: `Arc(x, y, rad, t1, t2, t3)`.

### Ellipses

Create an ellipse using `Ellipse(z, rx, ry)` where `z` is the center (complex) and `rx` and `ry` are the horizontal and vertical radii. Note that only axis-parallel ellipses can be created. Alternatively, use `Ellipse(x, y, rx, ry)` for an ellipse centered at `(x, y)`.

For an ellipse with a filled-in interior, use `FilledEllipse`. 

## Spline Curves

The functions `ClosedCurve` and `OpenCurve` create curves from a list of points (just like `Polygon`). 
The curves are cubic splines through those points. The following are all equivalent:
* `ClosedCurve([1-2im, 3+im, 4, -1-im])`
* `CloseCurve(1-2im, 3+im, 4, -1-im)`
* `ClosedCuve([1,3,4,-1], [-2,1,0,-1])`

We also have `FilledClosedCurve` for a closed curve whose interior is colored.

## Points

Points in the plane are created with `Point(z)` or `Point(x,y)`. A `Point` is rendered as a small dot. These two functions determine the appearance of points:
* `set_pointsize!(p, sz = 3)` sets the size of the point.
* `set_pointcolor!(p, col = :black)` sets the color of the point. 

Finer control over point appearance can be achieved using `set_fillcolor!` and `set_linecolor!` 
for points. The function `set_pointcolor!` sets the fill and the line of the `Point` to the same color. 





