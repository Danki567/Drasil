module Drasil.SSP.SSPUnits where

import Language.Drasil
import Language.Drasil.SI_Units

import Control.Lens ((^.))

--degree--
degree :: FundUnit
degree = UD (CC "Degree" (S "angle")) (UName (Special Circle))

--unitless--
unitless :: FundUnit
unitless = UD (CC "Unitless" (S "unitless")) (UName $ Atomic "unitless")

--N/m^3--
specific_weight :: DerUChunk
specific_weight = makeDerU (CC "specific weight"
  (S "weight per unit volume")) (USynonym (UDiv (newton ^. unit) (UPow (metre ^. unit) (3))))

--Nm--
newton_metre :: DerUChunk
newton_metre = makeDerU (CC "newton metre" (S "newton metre")) (USynonym (UProd [newton ^. unit, metre ^. unit]))

--N/m--
newton_per_metre :: DerUChunk
newton_per_metre = makeDerU (CC "newton per metre" (S "newton per metre")) (USynonym (UDiv (newton ^. unit) (metre ^. unit)))
