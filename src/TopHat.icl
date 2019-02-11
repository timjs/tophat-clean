implementation module TopHat


import Basics

// import iTasks

import qualified iTasks as I
from iTasks import -&&-, -||-, -||, ||-

from iTasks import class toPrompt, instance toPrompt String
from iTasks import class Startable, instance Startable (Task a)
from iTasks import class Functor, instance Functor Task
from iTasks import class TApplicative, instance TApplicative Task



// Synonyms ////////////////////////////////////////////////////////////////////


//XXX: Needs reimport because of weird bug using qualified import...
class Storable a | 'I'.iTask a


:: Ref a :== 'I'.Shared a


:: Task a :== 'I'.Task a



// Editors /////////////////////////////////////////////////////////////////////


view :: Message a -> Task a | Storable a
view label value = 'I'.viewInformation label [] value


edit :: Message a -> Task a | Storable a
edit label value = 'I'.updateInformation label [] value


enter :: Message -> Task a | Storable a
enter label = 'I'.enterInformation label []



// References //////////////////////////////////////////////////////////////////


globalRef :: Label a -> Ref a | Storable a
globalRef label value = 'I'.sharedStore label value


withRef :: a ((Ref a) -> Task b) -> Task b | Storable a & Storable b
withRef value cont = 'I'.withShared value cont


modify :: (Ref a) (a -> a) -> Task Unit | Storable a
modify ref fun = 'I'.upd fun ref >>= \_ -> pure ()


watch :: Message (Ref a) -> Task a | Storable a
watch label ref = 'I'.viewSharedInformation label [] ref


update :: Message (Ref a) -> Task a | Storable a
update label ref = 'I'.updateSharedInformation label [] ref


select :: Message (List a) (Ref (List a)) -> Task (List a) | Storable a
select label default ref = 'I'.updateMultipleChoiceWithShared label [] ref default



// Steps ///////////////////////////////////////////////////////////////////////


(>>*) infixl 1 :: (Task a) (List ( a -> Bool, a -> Task b )) -> Task b | Storable a & Storable b
(>>*) task options = 'I'.step task (const Nothing) $ map trans options
where
  trans ( p, t ) = 'I'.OnValue ('I'.ifValue p t)


(>>=) infixl 1 :: (Task a) (a -> Task b) -> Task b | Storable a & Storable b
(>>=) task cont = task >>* [ ( always, cont ) ]


// (>>) infixl 1 :: (Task a) (Task b) -> Task b | Storable a & Storable b
// (>>) task next = task >>= \_ -> next


(>?*) infixl 1 :: (Task a) (List ( String, a -> Bool, a -> Task b )) -> Task b | Storable a & Storable b
(>?*) task options = 'I'.step task (const Nothing) $ map trans options
where
  trans ( a, p, t ) = 'I'.OnAction ('I'.Action a) ('I'.ifValue p t)


(>?=) infixl 1 :: (Task a) (a -> Task b) -> Task b | Storable a & Storable b
(>?=) task cont = task >?* [ ( "Continue", always, cont ) ]


// (>?) infixl 1 :: (Task a) (Task b) -> Task b | Storable a & Storable b
// (>?) task next = task >?= \_ -> next



// Parallels ///////////////////////////////////////////////////////////////////


(<&>) infixr 4 :: (Task a) (Task b) -> Task ( a, b ) | Storable a & Storable b
(<&>) x y = (-&&-) x y


(<&) infixl 4 :: (Task a) (Task b) -> Task a | Storable a & Storable b
(<&) x y = (-||) x y


(&>) infixr 4 :: (Task a) (Task b) -> Task b | Storable a & Storable b
(&>) x y = (||-) x y



// Choices /////////////////////////////////////////////////////////////////////


(<|>) infixr 3 :: (Task a) (Task a) -> Task a | Storable a
(<|>) x y = (-||-) x y


(<?>) infixr 3 :: (Task a) (Task a) -> Task a | Storable a
(<?>) fst snd = pure () >?* [ ( "Left" , always, const fst ), (  "Right", always, const snd ) ]



// Fail ////////////////////////////////////////////////////////////////////////


fail :: Task a
fail = 'I'.transform (\_ -> 'I'.NoValue) $ pure ()



// Looping /////////////////////////////////////////////////////////////////////


forever :: (Task a) -> Task a | Storable a
forever t =
  t >>= \_ -> forever t



// Startup /////////////////////////////////////////////////////////////////////


run :: (Task a) *World -> *World | Storable a
run task world = 'I'.startEngine task world
