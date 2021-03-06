module Main (main) where

import Language.Drasil.Code (Choices(..), CodeSpec, Comments(..), 
  Verbosity(..), ConstraintBehaviour(..), ImplementationType(..), Lang(..), 
  Logging(..), Modularity(..), Structure(..), ConstantStructure(..), 
  ConstantRepr(..), InputModule(..), CodeConcept(..), matchConcepts, 
  AuxFile(..), Visibility(..), codeSpec)
import Language.Drasil.Generate (gen, genCode)
import Language.Drasil.Printers (DocSpec(DocSpec), DocType(SRS, Website))

import Data.Drasil.Quantities.Math (piConst)

import Drasil.Projectile.Body (printSetting, si, srs)

code :: CodeSpec
code = codeSpec si choices []

choices :: Choices
choices = Choices {
  lang = [Python, Cpp, CSharp, Java],
  modularity = Modular Combined,
  impType = Program,
  logFile = "log.txt",
  logging = LogNone,
  comments = [CommentFunc, CommentClass, CommentMod],
  doxVerbosity = Quiet,
  dates = Hide,
  onSfwrConstraint = Warning,
  onPhysConstraint = Warning,
  inputStructure = Bundled,
  constStructure = Store Unbundled,
  constRepr = Var,
  conceptMatch = matchConcepts [piConst] [[Pi]],
  auxFiles = [SampleInput]
}

main :: IO()
main = do
  gen (DocSpec SRS     "Projectile_SRS") srs printSetting
  gen (DocSpec Website "Projectile_SRS") srs printSetting
  genCode choices code