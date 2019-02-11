module Booking


import TopHat



// Helpers /////////////////////////////////////////////////////////////////////


remove :: a (List a) -> List a | Storable a
remove x [y:ys]
  | x === y   = ys
  | otherwise = [y : remove x ys]
remove x []   = []


removeElems :: (List a) (List a) -> List a | Storable a
removeElems []     ys = ys
removeElems [x:xs] ys = removeElems xs (remove x ys)



// Data ////////////////////////////////////////////////////////////////////////


:: Nationality
  = Dutch
  | British
  | German


:: Passenger =
  { first_name :: String
  , last_name :: String
  , nationality :: Nationality
  , age :: Int
  }


:: Flight
  = ToAmsterdam
  | ToLondon
  | ToBerlin


:: Row   :== Int
:: Chair :== Char
:: Seat  = Seat Row Chair


:: Booking =
  { passengers :: List Passenger
  , flight :: Flight
  , seats :: List Seat
  }



// Stores //////////////////////////////////////////////////////////////////////


free_seat_store :: Ref (List Seat)
free_seat_store =
  globalRef "Free seats" [ Seat r p \\ r <- [1..4], p <- ['A'..'D'] ]



// Checks //////////////////////////////////////////////////////////////////////


valid :: Passenger -> Bool
valid p = p.age >= 0


adult :: Passenger -> Bool
adult p = p.age >= 18



// Tasks ///////////////////////////////////////////////////////////////////////


enter_passengers :: Task (List Passenger)
enter_passengers =
  enter "Passenger details" >?*
    [ ( "Continue", all valid &&& any adult &&& not o empty, pure ) ]


enter_flight :: Task Flight
enter_flight =
  enter "Flight details" >?*
    [ ( "Continue", always, pure ) ]


choose_seats :: Int -> Task (List Seat)
choose_seats n =
  select "Pick a seat" [] free_seat_store >?*
    [ ( "Continue"
      , \seats -> length seats == n
      , \seats -> free_seat_store <<- removeElems seats >>= \_ -> pure seats
      )
    ]


make_booking :: Task Booking
make_booking =
  ( enter_flight
      <&>
    enter_passengers
  ) >>= \( flight, passengers ) ->
  choose_seats (length passengers) >>= \seats ->
  view "Booking" { passengers = passengers, flight = flight, seats = seats }


main :: Task Booking
main =
  watch "Free seats" free_seat_store &> make_booking



// Boilerplate /////////////////////////////////////////////////////////////////


//XXX: We can't refere to `Storable` here, some bug in generics...
derive class iTask Seat, Flight, Booking, Passenger, Nationality


Start :: *World -> *World
Start world = run main world
