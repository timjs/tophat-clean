definition module Basics


import StdFunctions

import StdBool
import StdChar
import StdInt
import StdReal
import StdString

import StdList
import StdMaybe
import StdTuple



// Synonyms ////////////////////////////////////////////////////////////////////


:: Unit :== ()
:: List a :== [a]



// Functions ///////////////////////////////////////////////////////////////////


(<|) infixr 0 // :: (a -> b) a -> b
(<|) f x :== f x


(|>) infixl 1 // :: a (a -> b) -> b
(|>) x f :== f x


(<<<) infixr 9 // :: (b -> c) (a -> b) -> a -> c
(<<<) f g x :== f (g x)


(>>>) infixr 9 // :: (a -> b) (b -> c) -> a -> c
(>>>) g f x :== f (g x)



// Booleans ////////////////////////////////////////////////////////////////////


(|||) infixr 2 //:: (a -> Bool) -> (a -> Bool) -> a -> Bool
(|||) l r x :== l x || r x


(&&&) infixr 3 //:: (a -> Bool) -> (a -> Bool) -> a -> Bool
(&&&) l r x :== l x && r x



// Lists ///////////////////////////////////////////////////////////////////////


empty :== isEmpty
