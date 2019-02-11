definition module TopHat


import Basics

import qualified iTasks as I


// Types ///////////////////////////////////////////////////////////////////////

class Storable a | 'I'.iTask a
// :: Ref a :== 'I'.SDSLens Unit a a
:: Task a :== 'I'.Task a

// class Storable a | iTask a
:: Message :== String


// Editors /////////////////////////////////////////////////////////////////////

view :: Message a -> Task a | Storable a
edit :: Message a -> Task a | Storable a
enter :: Message -> Task a | Storable a

/*

// References //////////////////////////////////////////////////////////////////

// Create //

ref :: Message a -> Task (Ref a) | Storable a
withRef :: a ((Ref a) -> Task b) -> Task b | Storable a & Storable b


// Modify //

(<<-) infixr 2
(<<-) :== modify
modify :: (Ref a) (a -> a) -> Task a | Storable a


// Watch //

watch :: Message (Ref a) -> Task a | Storable a
update :: Message (Ref a) -> Task a | Storable a
select :: Message (List a) (Ref a) -> Task (List a) | Storable a
*/

// Startup /////////////////////////////////////////////////////////////////////

run :: (Task a) *World -> *World | Storable a


/*
// Steps //

always :== const True

// Internal step (>>*)
(>>>) infixl 1 :: (Task a) (List ( a -> Bool, a -> Task b )) -> Task b | Storable a & Storable b
(>>>) task options = task >>* map trans options
where
  trans ( p, t ) = OnValue (ifValue p t)

// Internal bind (>>~)
(>>=) infixl 1 :: (Task a) (a -> Task b) -> Task b | Storable a & Storable b
(>>=) task cont = task >>> [ ( always, cont ) ]

// Internal ignore (>>|)
(>>) infixl 1 :: (Task a) (Task b) -> Task b | Storable a & Storable b
(>>) task next = task >>= \_ -> next

// External step (>>*)
(>?>) infixl 1 :: (Task a) (List ( String, a -> Bool, a -> Task b )) -> Task b | Storable a & Storable b
(>?>) task options = task >>* map trans options
where
  trans ( a, p, t ) = OnAction (Action a) (ifValue p t)

// External bind (>>=)
(>?=) infixl 1 :: (Task a) (a -> Task b) -> Task b | Storable a & Storable b
(>?=) task cont = task >?> [ ( "Continue", always, cont ) ]

// External ignore (>>= \_ -> )
(>?) infixl 1 :: (Task a) (Task b) -> Task b | Storable a & Storable b
(>?) task next = task >?= \_ -> next


// Parallels and Choices //

// Internal choice
(<|>) infixr 3 :: (Task a) (Task a) -> Task a | Storable a
(<|>) x y = (-||-) x y

// External choice
(<?>) infixr 3 :: (Task a) (Task a) -> Task a | Storable a
(<?>) fst snd = return () >?> [ ( "Left" , always, const fst ), (  "Right", always, const snd ) ]

// Parallel
(<&>) infixr 4 :: (Task a) (Task b) -> Task ( a, b ) | Storable a & Storable b
(<&>) x y = (-&&-) x y

// Parallel preference
(<&) infixl 4 :: (Task a) (Task b) -> Task a | Storable a & Storable b
(<&) x y = (-||) x y
(&>) infixr 4 :: (Task a) (Task b) -> Task b | Storable a & Storable b
(&>) x y = (||-) x y

// Fail
fail :: Task a | Storable a
fail = transform (\_ -> NoValue) (return ())


// Looping //

forever :: (Task a) -> Task a | Storable a
forever t =
  t >>= \_ -> t


*/
