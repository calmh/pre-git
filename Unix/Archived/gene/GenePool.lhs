> module GenePool where
> import Random
> import Picture
>     
> type GenePool = [Picture]
>
> poolSize :: Int
> poolSize = 100
>
> randomList :: [Int]
> randomList = randomRs (0, 1) $ mkStdGen 10
> 
> randomPic :: [Int]
> randomPic = [ take 10 randomList
> 
>-- replenish :: GenePool -> GenePool
>       
