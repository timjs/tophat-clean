definition module TopHat

import Basics

//FIXME: Due to a bug in Clean generics,
// the compiler crashes when refering to `Storable` in a `derive` declaration.
// Therefore we export the `iTask` class explicitly
// import qualified iTasks as I

from iTasks import class iTask
//NOTE: these types and generics apparently need to be reexported
from iTasks import generic gEq, generic gDefault, generic JSONDecode, generic JSONEncode, generic gText, generic gEditor
from iTasks import :: JSONNode, :: TextFormat, :: Editor, :: EditorPurpose


// Types ///////////////////////////////////////////////////////////////////////

class Storable a | iTask a
class Encodable a | JSONEncode{|*|}, TC a
class Decodable a | JSONDecode{|*|}, TC a

:: Ref a
:: Task a

:: Message :== String
:: Tag :== String // Label is already defined by iTasks and needs to be imported in the .icl...


// Editors /////////////////////////////////////////////////////////////////////

enter :: Message -> Task a | Storable a
update :: Message a -> Task a | Storable a
view :: Message a -> Task a | Storable a

change :: Message (Ref a) -> Task a | Storable a
watch :: Message (Ref a) -> Task a | Storable a

select :: (List (Tag, Task a)) -> Task a


// Combinators /////////////////////////////////////////////////////////////////

// Transform //

transform :: (a -> b) (Task a) -> Task b


// Steps //

(>>*) infixl 1 :: (Task a) (List ( a -> Bool, a -> Task b )) -> Task b | Encodable a
(>>=) infixl 1 :: (Task a) (a -> Task b) -> Task b | Encodable a

(>?*) infixl 1 :: (Task a) (List ( Tag, a -> Bool, a -> Task b )) -> Task b | Encodable a
(>?=) infixl 1 :: (Task a) (a -> Task b) -> Task b | Encodable a


// Pairs //

(<&>) infixr 4 :: (Task a) (Task b) -> Task ( a, b ) | Storable a & Storable b
(<&) infixl 4 :: (Task a) (Task b) -> Task a | Storable a & Storable b
(&>) infixr 4 :: (Task a) (Task b) -> Task b | Storable a & Storable b


// Choices //

(<|>) infixr 3 :: (Task a) (Task a) -> Task a | Storable a
(<?>) infixr 3 :: (Task a) (Task a) -> Task a | Encodable a


// Fail and Done ///////////////////////////////////////////////////////////////

fail :: Task a
done :: a -> Task a


// Loops ///////////////////////////////////////////////////////////////////////

replay :: (Task a) -> Task a | Encodable a
forever :: (Task a) -> Task a | Encodable a

// References //////////////////////////////////////////////////////////////////

// share :: a -> Task (Ref a) | Storable a
withShared :: a ((Ref a) -> Task b) -> Task b | Storable a & Storable b
globalShare :: Tag a -> Ref a | Storable a

pick :: Message (List a) (Ref (List a)) -> Task (List a) | Storable a
(<<-) infixr 2 :: (Ref a) a -> Task Unit | Storable, Encodable a
(<<=) infixr 2 :: (Ref a) (a -> a) -> Task Unit | Storable, Encodable a


// Startup /////////////////////////////////////////////////////////////////////

run :: (Task a) *World -> *World | Storable a
