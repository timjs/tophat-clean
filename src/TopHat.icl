implementation module TopHat

import Basics

// import iTasks

import qualified iTasks as I
from iTasks import class iTask
from iTasks import -&&-, -||-, -||, ||-

from iTasks import class Startable, instance Startable (Task a)
from iTasks import <<@, :: Label, class tune, instance tune Label (Task a)

from iTasks import generic gEq, generic gDefault, generic JSONDecode, generic JSONEncode, generic gText, generic gEditor
from iTasks import :: JSONNode, :: TextFormat, :: Editor, :: EditorPurpose

from Data.Functor import class Functor(fmap)
from iTasks import instance Functor Task

from iTasks import instance Identifiable SDSLens, instance Readable SDSLens, instance Writeable SDSLens, instance Modifiable SDSLens, instance Registrable SDSLens
from iTasks import class Identifiable, class Readable, class Writeable, class Modifiable, class Registrable
from iTasks import :: SDSLens

// from iTasks import class toPrompt, instance toPrompt String
// from iTasks import class Startable, instance Startable (Task a)
// from iTasks import class Applicative, pure, instance Applicative Task


// Synonyms ////////////////////////////////////////////////////////////////////

//XXX: Needs reimport because of weird bug using qualified import...
class Storable a | iTask a
class Encodable a | JSONEncode{|*|}, TC a
class Decodable a | JSONDecode{|*|}, TC a

:: Ref a :== 'I'.SimpleSDSLens a

:: Task a :== 'I'.Task a


// Editors /////////////////////////////////////////////////////////////////////

// Normal //

enter :: Message -> Task a | Storable a
enter msg = 'I'.enterInformation [] <<@ 'I'.Label msg

update :: Message a -> Task a | Storable a
update msg val = 'I'.updateInformation [] val <<@ 'I'.Label msg

view :: Message a -> Task a | Storable a
view msg val = 'I'.viewInformation [] val <<@ 'I'.Label msg


// Shared //

change :: Message (Ref a) -> Task a | Storable a
change msg ref = 'I'.updateSharedInformation [] ref <<@ 'I'.Label msg

watch :: Message (Ref a) -> Task a | Storable a
watch msg ref = 'I'.viewSharedInformation [] ref <<@ 'I'.Label msg


// Select //

select :: (List (Tag, Task a)) -> Task a
select options = done () >?* map trans options
where
  trans ( l, t ) = ( l, const True, const t )


// Combinators /////////////////////////////////////////////////////////////////

// Transform //

transform :: (a -> b) (Task a) -> Task b
transform fun task = fmap fun task


// Steps //

(>>*) infixl 1 :: (Task a) (List ( a -> Bool, a -> Task b )) -> Task b | Encodable a
(>>*) task options = 'I'.step task (const ?None) $ map trans options
where
  trans ( p, t ) = 'I'.OnValue ('I'.ifValue p t)

(>>=) infixl 1 :: (Task a) (a -> Task b) -> Task b | Encodable a
(>>=) task cont = task >>* [ ( const True, cont ) ]

// (>>) infixl 1 :: (Task a) (Task b) -> Task b | Encodable a
// (>>) task next = task >>= \_ -> next

(>?*) infixl 1 :: (Task a) (List ( Tag, a -> Bool, a -> Task b )) -> Task b | Encodable a
(>?*) task options = 'I'.step task (const ?None) $ map trans options
where
  trans ( a, p, t ) = 'I'.OnAction ('I'.Action a) ('I'.ifValue p t)

(>?=) infixl 1 :: (Task a) (a -> Task b) -> Task b | Encodable a
(>?=) task cont = task >?* [ ( "Continue", const True, cont ) ]

// (>?) infixl 1 :: (Task a) (Task b) -> Task b | Encodable a
// (>?) task next = task >?= \_ -> next


// Pairs //

(<&>) infixr 4 :: (Task a) (Task b) -> Task ( a, b ) | Storable a & Storable b
(<&>) x y = (-&&-) x y

(<&) infixl 4 :: (Task a) (Task b) -> Task a | Storable a & Storable b
(<&) x y = (-||) x y

(&>) infixr 4 :: (Task a) (Task b) -> Task b | Storable a & Storable b
(&>) x y = (||-) x y


// Choices //

(<|>) infixr 3 :: (Task a) (Task a) -> Task a | Storable a
(<|>) x y = (-||-) x y

(<?>) infixr 3 :: (Task a) (Task a) -> Task a | Encodable a
(<?>) x y = done () >?* [ ( "Left", const True, \_ -> x ), ( "Right", const True, \_ -> y ) ]


// Basics //////////////////////////////////////////////////////////////////////

fail :: Task a
fail = 'I'.transform (\_ -> 'I'.NoValue) $ done ()

done :: a -> Task a
done a = 'I'.return a


// Loops ///////////////////////////////////////////////////////////////////////

replay :: (Task a) -> Task a | Encodable a
replay t = t >?* [ ( "Repeat", const True, \_ -> replay t ), ( "Exit", const True, \x -> done x ) ]

forever :: (Task a) -> Task a | Encodable a
forever t = t >>= \_ -> forever t


// References //////////////////////////////////////////////////////////////////

// share :: a -> Task (Ref a) | Storable a
// share val = withShared val done

withShared :: a ((Ref a) -> Task b) -> Task b | Storable a & Storable b
withShared val cont = 'I'.withShared val cont

globalShare :: Tag a -> Ref a | Storable a
globalShare lbl val = 'I'.sharedStore lbl val

pick :: Message (List a) (Ref (List a)) -> Task (List a) | Storable a
pick msg default ref = 'I'.updateMultipleChoiceWithShared [] ref default <<@ 'I'.Label msg

(<<-) infixr 2 :: (Ref a) a -> Task Unit | Storable, Encodable a
(<<-) ref val = 'I'.set val ref >>= \_ -> done ()

(<<=) infixr 2 :: (Ref a) (a -> a) -> Task Unit | Storable, Encodable a
(<<=) ref fun = 'I'.upd fun ref >>= \_ -> done ()


// Startup /////////////////////////////////////////////////////////////////////

run :: (Task a) *World -> *World | Storable a
run task world = 'I'.startEngine task world
