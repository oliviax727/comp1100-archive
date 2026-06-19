# u7280249 Technical Report

NOTE: THE 'D' KEY IS NOT BINDED TO PRINTING TO CONSOLE, INSTEAD USE 'E'

### Testing

##### Task 1

All helper functions in task 1 were tested using the 'cabal v2-test' command. This was done in combination with a direct analysis of the code to ensure that the function produced a desired output.

Due to the simplicity of the functions, only one input was provided via GHCi, which was to show that the function worked as intended. This involved manual input:

For toolToLabel and nextTool, I inputted 'LineTool Nothing'.

For nextColour, I inputted black

##### Task 2

For Parallelograms, I used vectors to find the fourth point, and then draw a polygon with all four points.

Given vectors OB, OA, OC (in order of provided argument), OD = OB + OC - OA.

This required the use of a vecAdd funtion.

For Circles, I calculated the radius by halving the distance between the provided points. Then I translated the circle according to their midpoints.

For Squares, all for corners lie on a line that is perpendicular to the one between the two midpoints, and intersecting one of the two midpoints. Furthermore, the corner would be seperated from the midpoint by half the length of the square. Using trigenometry, the exact location of all four points can be found.

For all other shapes, the way to draw them was trivial.

To test this, I used the command CodeWorld.drawingOf (View.colourShapesToPicture Model.mystery) in the GHCi simulation.

##### Task 3

I used helper functions that break down the task into smaller problems:

For the PointerPress event:
1. Checked if it was a ParallelogramTool with two inputted points
2. If not, it would 'append' a new point to the arguments of Tool
3. If it was, it would construct a parallelogram using the toolToShape function

For the PointerRelease event:
1. If it was a ParallelogramTool or PolygonTool, it would return the model unchanged
2. The program would construct a function using the toolToShape funciton, and reset the argument of the tool using nullTool

For the Spacebar, the program will construct a polygon using the toolToShape function if the current tool is a polygonTool with three points.

For the backspace, I removed the head of the list, if the list was not empty.

To test, I drew one of each shape, cycling through every colour and tool type, and then I deleted them all from the canvas.

For the isIncomplete function, I assumed that the first argument was not Nothing if the second argument was not Nothing .

##### Task 4

I used recursion in order to flip the coordinates of each point in each argument of each shape in the set of colourShapes.

To simplify the use of helper functions, I included a boolean condition that would determine if the code flips on its X or Y axis.

To test this, I pressed X and Y on the mystery image, in different combinations

##### Task 5

I attempted tasks 5.1 and 5.3, using a select feature where you can select shapes between two points.

Firstly, I introduced a new tool: SelectTool, which would allow the user to select a rectangular section of the plane.

Secondly, I made a function that would return true if a given ColourShape is in range. Since there is no API function determening if a Picture overlaps with another, for each shape I determined (using mathematics) if it lied entirely within the rectangular selection range:
- For most shapes, it was trivial
- Some shapes required the measurement of a list of inputs
- For parallelograms and squares, I had to detect if any corner points were out of range
- For Circles, I found that there was no way to tell if it lied within the region. The best I could do was to inscribe a square in the circle, then see if anythose four points lied in range

Then I made two functions, both would:
- Go through every element in the list of colourshapes
- If it was in the selected range, then it would either remove the shape from the list, or move all of it's points by a vector

Lastly, I bound these functions to a Q key for delete, the WASD keys for translation, and a click-drag-release for selection. Note that after every keypress, I removed the selection area.

It was not too difficult implementing this component, however the amount of functions I required to cover every case was very large. However, I don't think there really is any method to prevent this from happening (polymorphic functions aren't going to help).

To test, I inputted values into every function on repl, and checked the return. I did this multiple times for any boundary conditions (i.e. tested pointInRange multiple times).