definition module TopHat

import Basics

import qualified iTasks as I


// Types ///////////////////////////////////////////////////////////////////////

class Storable a | 'I'.iTask a

:: Ref a
:: Task a

:: Message :== String
:: Label :== String


// Editors /////////////////////////////////////////////////////////////////////

view :: Message a -> Task a | Storable a
edit :: Message a -> Task a | Storable a
enter :: Message -> Task a | Storable a


// References //////////////////////////////////////////////////////////////////

// Create //

withRef :: a ((Ref a) -> Task b) -> Task b | Storable a & Storable b


// Modify //

(<<-) infixr 2
(<<-) :== modify
modify :: (Ref a) (a -> a) -> Task a | Storable a


// Watch //

watch :: Message (Ref a) -> Task a | Storable a
update :: Message (Ref a) -> Task a | Storable a
select :: Message (List a) (Ref (List a)) -> Task (List a) | Storable a


// Steps ///////////////////////////////////////////////////////////////////////

always :== const True


// Parallels ///////////////////////////////////////////////////////////////////

(<&>) infixr 4 :: (Task a) (Task b) -> Task ( a, b ) | Storable a & Storable b
(<&) infixl 4 :: (Task a) (Task b) -> Task a | Storable a & Storable b
(&>) infixr 4 :: (Task a) (Task b) -> Task b | Storable a & Storable b


// Choices /////////////////////////////////////////////////////////////////////

(<|>) infixr 3 :: (Task a) (Task a) -> Task a | Storable a
// (<?>) infixr 3 :: (Task a) (Task a) -> Task a | Storable a


// Fail ////////////////////////////////////////////////////////////////////////

fail :: Task a


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



// Looping //

forever :: (Task a) -> Task a | Storable a
forever t =
  t >>= \_ -> t


*/
