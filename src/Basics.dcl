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

import Data.Func
import Data.GenEq


// Synonyms ////////////////////////////////////////////////////////////////////

:: Unit :== ()
:: List a :== [a]


// Booleans ////////////////////////////////////////////////////////////////////

(|||) infixr 2 //:: (a -> Bool) -> (a -> Bool) -> a -> Bool
(|||) l r x :== l x || r x

(&&&) infixr 3 //:: (a -> Bool) -> (a -> Bool) -> a -> Bool
(&&&) l r x :== l x && r x

always :== const True
