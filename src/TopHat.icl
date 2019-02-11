implementation module TopHat


import Basics

// import iTasks
import qualified iTasks as I
from iTasks import class toPrompt, instance toPrompt String
from iTasks import class Startable, instance Startable (Task a)



// Synonyms ////////////////////////////////////////////////////////////////////


//XXX: Needs reimport because of weird bug using qualified import...
class Storable a | 'I'.iTask a
:: Ref a :== 'I'.Shared a
:: Task a :== 'I'.Task a



// Basic combinators ///////////////////////////////////////////////////////////


// Editors //


view :: Message a -> Task a | Storable a
view label value = 'I'.viewInformation label [] value


edit :: Message a -> Task a | Storable a
edit label value = 'I'.updateInformation label [] value


enter :: Message -> Task a | Storable a
enter label = 'I'.enterInformation label []


// Shares //


// ref :: Message a -> Task (Ref a) | Storable a
// ref label value = 'I'.return <| 'I'.sharedStore label value


withRef :: a ((Ref a) -> Task b) -> Task b | Storable a & Storable b
withRef value cont = 'I'.withShared value cont


modify :: (Ref a) (a -> a) -> Task a | Storable a
modify ref fun = 'I'.upd fun ref


watch :: Message (Ref a) -> Task a | Storable a
watch label ref = 'I'.viewSharedInformation label [] ref


update :: Message (Ref a) -> Task a | Storable a
update label ref = 'I'.updateSharedInformation label [] ref


select :: Message (List a) (Ref (List a)) -> Task (List a) | Storable a
select label default ref = 'I'.updateMultipleChoiceWithShared label [] ref default



// Startup /////////////////////////////////////////////////////////////////////


run :: (Task a) *World -> *World | Storable a
run task world = 'I'.startEngine task world
