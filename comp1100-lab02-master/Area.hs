module Area where
    -- Adds 1 to integer
    inc :: Int -> Int
    inc x = x + 1

    -- Gets area of square given base length
    areaSquare :: Double -> Double
    areaSquare b = 
        if b > 0 then 
            b ** 2
        else 0

    -- Takes the base and the width and multiplies togehter
    areaRect :: Double -> Double -> Double
    areaRect b w =
        if b > 0 && w > 0 then 
            b * w
        else 0

    -- Calculates a value needed for the area of a triangle
    --s :: Double -> Double -> Double -> Double -> Double
    -- s a b c d = ((a + b + c) / 2) - d

    -- Calculates area of a triangle
    areaTri :: Double -> Double -> Double -> Double
    areaTri a b c = sqrt (s a b c 0 * s a b c a  * s a b c b * s a b c c)
        where
            s a b c d = ((a + b + c) / 2) - d

    -- add two cubic numbers
    sumCubes :: Double -> Double -> Double
    sumCubes m n = cube m + cube n
        where
            cube x = x * x * x

    -- data Param = Param {w :: Int, b :: Int}
    --f :: Param -> Int