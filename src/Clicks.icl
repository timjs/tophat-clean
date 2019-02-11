module Clicks


import TopHat



// Helpers /////////////////////////////////////////////////////////////////////


succ :: Int -> Int
succ n =
  n + 1



// Tasks ///////////////////////////////////////////////////////////////////////


/*
let count : Int -> Task Int = λ n : Int.
  view n >>? λ _.
  count (n + 1) <?> count 0
*/


count_choice :: Int -> Task Int
count_choice n =
  view "Clicks" n >?= \_ ->
    (count_choice (n + 1) <?> count_choice 0)


count_shared :: (Ref Int) -> Task ( Int, Unit )
count_shared n =
  forever $
    watch "Clicks" n <&> ((n <<- succ) <?> (n <<- const 0))


count_list :: Int -> Task Int
count_list n =
  view "Clicks" n >?*
    [ ( "Click", always, const $ count_list (n + 1) )
    , ( "Reset", always, const $ count_list 0 )
    ]



main =
  withRef 0 $ \n ->
    count_shared n
  // count_choice 0



// Boilerplate /////////////////////////////////////////////////////////////////


// derive class iTask ...


Start :: *World -> *World
Start world = run main world
