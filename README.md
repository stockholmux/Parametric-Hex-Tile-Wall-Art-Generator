# Parametric Hex Wall Art Generator

This OpenSCAD program will generate a tessellated set of hexagon "tiles" composited with the SVG artwork of your choosing for which you can generate 3D Printable STLs.

## The Story

I had a colleague who showed a really slick 3D Printing project where he made some cool wall art by splitting a drawing out over a series of hexagon tiles. He used TinkerCAD to do this in a labourious process of manually laying out the hexagons, deleting all hexagons but one, saving and undoing. It looked like such a pain! 

I said, "you know, this is a good job for OpenSCAD." Sure enough - an hour later I had a working prototype!

## Installation

This script relies upon the [BOSL2 library](https://github.com/revarbat/BOSL2) to generate the hexagons (because I'm lazy and it's good). To install this, clone the BOSL2 library into this project's directory:

```shell
$ git clone https://github.com/revarbat/BOSL2
```

From here you can open `hex.scad` in OpenSCAD.

## Customizer

This design is fully parametric. You can specify whatever you want as far as the tile size, counts, and your own artwork. If you have the customizer hidden, you can reveal it OpenSCAD by going to the `Window` -> `Customizer` menu item.

## Generating tiles for printing

By default, this will show you the entire tile set. **This is not useful for 3D printing!** You'll just get a single STL with all the tiles connected. 

Instead go to the Customizer, tick the `Show Only` box and the tile you want to generate by specifying the `onlyX` and `onlyY` coordinates. This will isolate a single tile and then you can render it (F6). From here you can generate a STL for 3D printing (F7).

**Don't be surprised if it seems like it's hung with a CPU at 100% when trying to generate an STL** (see the next section and FAQ).

## From the command line

OpenSCAD works from the command line as well. In this project this is _super_ helpful. You can pass in a JSON file, a OpenSCAD source, and an output and OpenSCAD will generate an STL for you. No mouse move/move/click/click! Instead, go get a coffee and let your computer do all the hard work. 

Included in this repo is `generate.json` and `generate.sh`. These are great starting points where you can generate entire rows of tiles without human interaction! 

Here is the rough usage of `generate.sh`. The first argument (`5` in the example) is the number of tiles in the X direction you want to generate starting from 0. The next argument (`0` in the example) is the row number, i.e. the Y direction. The third argument (`row0.json` in the example) is the temp file that will be used during generation. This file will be deleted at the end of the script. The third argument is only really important if you're running multiple versions of the script concurrently.

```shell
$ bash generate.sh 5 0 row0.json 
```
(I'm explicitly using `bash` here to avoid any issues with permissions)

**Note that this file _may not work_ on your machine** as it's setup for OpenSCAD installed on MacOS. Alter it to fit your needs. You also need `yq` installed on your machine (if you're on a mac and use Homebrew install it by running `brew install yq`).


## Slicing

If you just print the tiles from the generated STL, you'll have a beautiful single colour tile. If that's what you're going for, great! 

However most people want something with more pop, you'll need to do a filament swap to get another colour. There are lots of ways of doing this, but here is how you do it in Cura on a single colour printer:

1. Slice the model and find the layer in which your design and border first start to appear using the layer preview slider. Write this layer number down.
2. Go to the `Extensions` -> `Post Processing` -> `Modify G-Code` menu item. 
3. Then in the new window click `Add a script` then `Filament Change`
4. Add the layer number from the first step and put this in the field labeled `Layer`. You may want to adjust the other settings here, but that's specific to your printer.

If you have an IDEX printer, Pallet Pro, AMS or some other method of changing filament colours mid-print, do whatever you normally do to change colours you lucky dog.

## FAQ

1. **Why is this so slow to generate the STL files?!** SVG import and extrusion in OpenSCAD is a known slow operation. The resulting mesh of a small SVG file (a few kb) will explode into a very large 3D solid mesh (likely dozens of megabytes). Additionally, OpenSCAD is, at the time of writing, single threaded, only works on a single core of the CPU and doesn't take advantage of GPUs for this operation.
2. **What can I do to make it faster?** *Simplify your SVG file.* The resulting mesh is proportional to the number of curves and points in the SVG paths. Many SVG files, especially those generated computationally, have many irrelevant points in the curves. If you're using Inkscape, you can use `Path` -> `Simplify` to do this on each curve in the artwork. 
3. **I've already simplified my SVG, are their other option to speed up the operation?** Yup. Use more CPU cores at once. Most modern machines have many CPU cores. Since OpenSCAD is bound to a single core it can't take advantage of this. However, you can run many instances of command line rendering at one time with little to no penalty, so that is is a great option. 
3. **I got an error that says something about a mesh not being closed. What does that mean?!** Oh brother. `ERROR: The given mesh is not closed! Unable to convert to CGAL_Nef_Polyhedron` is an obtuse error message, isn't it? Basically this means that OpenSCAD can't reason about a way to make a solid object. Many objects can appear to be solid, but have impossible geometry, like many points converging together in exactly the same space. There is lots written about this around the web, but in this context, the best thing to do is, again, simplify your SVG file. Failing that, you'll need to manually look for places where the SVG curves self-intersect (which is beyond the scope of this README)

## License

This project is licensed under the BSD-3-Clause License.