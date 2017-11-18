module Drasil.Speciation.Concepts where --whole file is used

import Language.Drasil

import Data.Drasil.Concepts.Documentation (assumption, 
  dataDefn, goalStmt, inModel, likelyChg, notApp, physSyst, 
  requirement, srs, thModel, typUnc, response, type_)

import Control.Lens ((^.))
{--}

specnProg :: ConceptChunk
specnProg = dcc' "speciationProg" (nounPhraseSP "Speciation Diagram Generator program")
  "The speciation diagram generator program" "SpecGen" 

{-Acronyms-}
acronyms = [assumption, dataDefn, goalStmt, inModel, likelyChg, notApp, 
  physSyst, requirement, srs, thModel, typUnc, specgen]

specgen :: CI

specgen      = commonIdea "specgen"  (specnProg ^. term)   "SpecGen"  
  
{-Acronyms-}
{- acronyms :: [CI]
acronyms = [assumption, annealedGlass, aR, dataDefn, fullyTGlass,
  goalStmt, glassTypeFac, heatSGlass, iGlass, inModel, likelyChg, 
  loadDurFactor, lGlass, lResistance, lShareFac, notApp, nFL,
  physSyst, requirement, stdOffDist, srs, thModel, eqTNT, typUnc]

annealedGlass, aR, fullyTGlass, glassTypeFac, heatSGlass, loadDurFactor,
  iGlass, lGlass, lResistance, lShareFac, eqTNT, gLassBR, stdOffDist, nFL :: CI

--FIXME: Add compound nounphrases

annealedGlass = commonIdea "annealedGlass" (nounPhraseSP "annealed glass")          "AN"
aR            = commonIdea "aR"            (nounPhraseSP "aspect ratio")            "AR"
fullyTGlass   = commonIdea "fullyTGlass"   (nounPhraseSP "fully tempered glass")    "FT"
glassTypeFac  = commonIdea "glassTypeFac"  (nounPhraseSP "glass type factor")       "GTF"
heatSGlass    = commonIdea "heatSGlass"    (nounPhraseSP "heat strengthened glass") "HS"
iGlass        = commonIdea "iGlass"        (nounPhraseSP "insulating glass")        "IG"
lGlass        = commonIdea "lGlass"        (nounPhraseSP "laminated glass")         "LG"
lResistance   = commonIdea "lResistance"   (nounPhraseSP "load resistance")         "LR"
lShareFac     = commonIdea "lShareFac"     (nounPhraseSP "load share factor")       "LSF"
eqTNT         = commonIdea "eqTNT"         (nounPhraseSP "TNT (Trinitrotoluene) Equivalent Factor") "TNT"
gLassBR       = commonIdea "gLassBR"       (pn "GlassBR")                           "GlassBR"
stdOffDist    = commonIdea "stdOffDist"    (nounPhraseSP "stand off distance")      "SD"
loadDurFactor = commonIdea "loadDurFactor" (nounPhraseSP "load duration factor")    "LDF"
nFL           = commonIdea "nFL"           (nounPhraseSP "non-factored load")       "NFL"

{-Terminology-}
-- TODO: See if we can make some of these terms less specific and/or parameterized.
 
beam, blastRisk, cantilever, edge, glaPlane, glaSlab, plane,
  glass, ptOfExplsn, responseTy :: NamedChunk
beam         = npnc "beam"       (nounPhraseSP "beam")
blastRisk    = npnc "blastRisk"  (nounPhraseSP "blast risk")
cantilever   = npnc "cantilever" (nounPhraseSP "cantilever")
edge         = npnc "edge"       (nounPhraseSP "edge")
glass        = npnc "glass"      (nounPhraseSP "glass")
glaSlab      = npnc "glaSlab"    (nounPhraseSP "glass slab")
plane        = npnc "plane"      (nounPhraseSP "plane")

ptOfExplsn   = npnc "ptOfExplsn" (cn' "point of explosion")

glaPlane     = compoundNC glass plane
responseTy   = compoundNC response type_
-}