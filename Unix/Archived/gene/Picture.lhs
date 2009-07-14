> module Picture where
>	 
> type Picture = [[Char]]

A horse...

> horse :: Picture
> horse = [".......##...",
>   ".....##..#..",
>   "...##.....#.",
>   "..#.......#.",
>   "..#...#...#.",
>   "..#...###.#.",
>   ".#....#..##.",
>   "..#...#.....",
>   "...#...#....",
>   "....#..#....",
>   ".....#.#....",
>   "......##...."]

A completely white picture.

> white :: Picture
> white = ["............",
>   "............",
>   "............",
>   "............",
>   "............",
>   "............",
>   "............",
>   "............",
>   "............",
>   "............",
>   "............",
>   "............"]

Getting a picture onto the screen.

> printPicture :: Picture -> IO ()
> printPicture = putStr . concat . map (++"\n")
>	


Compute the likeness between two pictures; the higher the better.

> score :: Picture -> Picture -> Int
> score p1 p2 = sum $ map scorelines (zip p1 p2)
>     where
>     scorelines ([], []) = 0
>     scorelines ((x:xs), (y:ys))
>      |  x == y = 1 + scorelines (xs, ys)
>      | otherwise = scorelines (xs, ys)
