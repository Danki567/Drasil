module Drasil.NoPCM.Assumptions where --all of this file is exported

import Language.Drasil

import Data.Drasil.Concepts.Documentation (model, assumpDom)

import Data.Drasil.Quantities.PhysicalProperties (vol)
import Data.Drasil.Quantities.Thermodynamics (boil_pt, melt_pt)

import Data.Drasil.Concepts.Thermodynamics as CT (heat)
import qualified Data.Drasil.Quantities.Thermodynamics as QT (temp)

import Data.Drasil.SentenceStructures (foldlSent, sAnd, isThe)

import Drasil.SWHS.Assumptions (newA1, newA2, newA3, newA7, newA8, newA9,
  newA14, newA15, newA20)
import Drasil.SWHS.Concepts (tank, water)
-- import Drasil.SWHS.References (swhsCitations)
import Drasil.SWHS.Unitals (vol_ht_gen, temp_C, temp_init, temp_W, htCap_W, w_density)

-------------------------
-- 4.2.1 : Assumptions --
-------------------------

assumps_Nopcm_list_new :: [AssumpChunk]
assumps_Nopcm_list_new = [newA1, newA2, newA3, newA5NoPCM, newA6NoPCM,
  newA7, newA8, newA9, newA9NoPCM, newA14, newA15, newA16, newA19, newA20]

-- FIXME: Remove the newA*NoPCM AssumpChunk's once SWHS has migrated to
-- ConceptInstance and SCSProg's Assumptions has been migrated to using
-- assumpDom
  
assumpS3, assumpS4, assumpS5, assumpS9_npcm, assumpS12, assumpS13 :: Sentence
assumpDWCoW, assumpSHECoW, assumpCTNTD, assumpNIHGBW, assumpAPT :: ConceptInstance

assumpS3 = 
  (foldlSent [S "The", phrase water, S "in the", phrase tank,
  S "is fully mixed, so the", phrase temp_W `isThe`
  S "same throughout the entire", phrase tank])

assumpS4 = 
  (foldlSent [S "The", phrase w_density, S "has no spatial variation; that is"
  `sC` S "it is constant over their entire", phrase vol])

newA5NoPCM :: AssumpChunk
newA5NoPCM = assump "assumpDVCoW" assumpS4 ("Density-Water-Constant-over-Volume")

assumpDWCoW = cic "assumpDWCoW" assumpS4
  "Density-Water-Constant-over-Volume" assumpDom

assumpS5 = 
  (foldlSent [S "The", phrase htCap_W, S "has no spatial variation; that", 
  S "is, it is constant over its entire", phrase vol])

newA6NoPCM :: AssumpChunk
newA6NoPCM = assump "assumpSHECoW" assumpS5 ("Specific-Heat-Energy-Constant-over-Volume")

assumpSHECoW = cic "assumpSHECoW" assumpS5
  "Specific-Heat-Energy-Constant-over-Volume" assumpDom

assumpS9_npcm = 
  (foldlSent [S "The", phrase model, S "only accounts for charging",
  S "of the tank" `sC` S "not discharging. The", phrase temp_W, S "can only",
  S "increase, or remain constant; it cannot decrease. This implies that the",
  phrase temp_init, S "is less than (or equal to) the", phrase temp_C])

newA9NoPCM :: AssumpChunk
newA9NoPCM = assump "assumpCTNTD" assumpS9_npcm ("Charging-Tank-No-Temp-Discharge")

assumpCTNTD = cic "assumpCTNTD" assumpS9_npcm
  "Charging-Tank-No-Temp-Discharge" assumpDom

assumpS12 = 
  (S "No internal" +:+ phrase heat +:+ S "is generated by the water; therefore, the"
  +:+ phrase vol_ht_gen +:+. S "is zero")

newA16 :: AssumpChunk
newA16 = assump "assumpNIHGBW" assumpS12 ("No-Internal-Heat-Generation-By-Water")

assumpNIHGBW = cic "assumpNIHGBW" assumpS12
  "No-Internal-Heat-Generation-By-Water" assumpDom

assumpS13 = 
  (S "The pressure in the" +:+ phrase tank +:+ S "is atmospheric, so the" +:+
  phrase melt_pt `sAnd` phrase boil_pt +:+ S "of water are" +:+ S (show (0 :: Integer))
  :+: Sy (unit_symb QT.temp) `sAnd` S (show (100 :: Integer)) :+:
  Sy (unit_symb QT.temp) `sC` S "respectively")

newA19 :: AssumpChunk
newA19 = assump "assumpAPT" assumpS13 ("Atmospheric-Pressure-Tank")

assumpAPT = cic "assumpAPT" assumpS13
  "Atmospheric-Pressure-Tank" assumpDom
