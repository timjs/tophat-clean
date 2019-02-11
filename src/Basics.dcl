definition module Basics


import StdFunc
import StdBool
import StdList



// Synonyms ////////////////////////////////////////////////////////////////////


:: Unit :== ()
:: List a :== [a]



// Functions ///////////////////////////////////////////////////////////////////


(<|) infixr 0 // :: (a -> b) a -> b
(<|) f x :== f x


(|>) infixr 0 // :: a (a -> b) -> b
(|>) x f :== f x


(|||) infixr 2 //:: (a -> Bool) -> (a -> Bool) -> a -> Bool
(|||) l r x :== l x || r x


(&&&) infixr 3 //:: (a -> Bool) -> (a -> Bool) -> a -> Bool
(&&&) l r x :== l x && r x



// Lists ///////////////////////////////////////////////////////////////////////


empty :== isEmpty
