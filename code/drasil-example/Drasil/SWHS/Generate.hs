module Drasil.SWHS.Generate (generate) where

-- import Language.Drasil.Code (Choices(..), CodeSpec, codeSpec, Comments(..), 
--   ConstraintBehaviour(..), ImplementationType(..), Lang(..), Logging(..), 
--   Structure(..))
import Language.Drasil.Generate (gen)
import Language.Drasil.Printers (DocType(SRS, Website), DocSpec(DocSpec))

import Drasil.SWHS.Body (srs', printSetting) -- si

-- code :: CodeSpec
-- code = codeSpec si choices []

-- choices :: Choices
-- choices = Choices {
--   lang = [Python, Cpp, CSharp, Java],
--   impType = Program,
--   logFile = "log.txt",
--   logging = LogNone,         -- LogNone, LogFunc
--   comments = CommentNone,    -- CommentNone, CommentFunc
--   onSfwrConstraint = Warning,  -- Warning, Exception
--   onPhysConstraint = Warning,  -- Warning, Exception
--   inputStructure = Unbundled    -- Unbundled, Bundled
-- }

generate :: IO ()
generate = do
  gen (DocSpec SRS "SWHS_SRS")     srs' printSetting
  gen (DocSpec Website "SWHS_SRS") srs' printSetting
  -- When ready to generate code from SWHS, uncomment this file
  -- genCode choices code
       
