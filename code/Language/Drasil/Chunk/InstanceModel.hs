{-# LANGUAGE TemplateHaskell, TypeFamilies #-}
module Language.Drasil.Chunk.InstanceModel 
  ( InstanceModel
  , inCons, outCons, imOutput, imInputs, im, imQD
  )where

import Language.Drasil.Classes (HasUID(uid), NamedIdea(term), Idea(getA),
  Definition(defn),ConceptDomain(cdom,DOM),Concept, HasAttributes(attributes),
  ExprRelat(relat))
import Language.Drasil.Chunk.Attribute.Core (Attributes)
import Language.Drasil.Chunk.Concept
import Language.Drasil.Chunk.Constrained.Core (TheoryConstraint)
import Language.Drasil.Chunk.Eq
import Language.Drasil.Chunk.Relation
import Language.Drasil.Chunk.Quantity
import Language.Drasil.ChunkDB
import Language.Drasil.Expr
import Language.Drasil.Expr.Math (sy)
import Language.Drasil.Expr.Extract (vars)
import Language.Drasil.Spec (Sentence)

import Control.Lens (makeLenses, (^.))

type Inputs = [QuantityDict]
type Output = QuantityDict

type InputConstraints  = [TheoryConstraint]
type OutputConstraints = [TheoryConstraint]

-- | An Instance Model is a RelationConcept that may have specific input/output
-- constraints. It also has attributes (like Derivation, source, etc.)
data InstanceModel = IM { _rc :: RelationConcept
                        , _imInputs :: Inputs
                        , _inCons :: InputConstraints
                        , _imOutput :: Output
                        , _outCons :: OutputConstraints
                        , _attribs :: Attributes 
                        }
makeLenses ''InstanceModel
  
instance HasUID InstanceModel        where uid = rc . uid
instance NamedIdea InstanceModel     where term = rc . term
instance Idea InstanceModel          where getA (IM a _ _ _ _ _) = getA a
instance Concept InstanceModel
instance Definition InstanceModel    where defn = rc . defn
instance ConceptDomain InstanceModel where
  type DOM InstanceModel = ConceptChunk
  cdom = rc . cdom
instance ExprRelat InstanceModel     where relat = rc . relat
instance HasAttributes InstanceModel where attributes = attribs

-- | Smart constructor for instance models
im :: RelationConcept -> Inputs -> InputConstraints -> Output -> 
  OutputConstraints -> Attributes -> InstanceModel
im = IM

-- | Smart constructor for instance model from qdefinition 
-- (Sentence is the "concept" definition for the relation concept)
imQD :: HasSymbolTable ctx => ctx -> QDefinition -> Sentence -> InputConstraints -> OutputConstraints -> Attributes -> InstanceModel
imQD ctx qd dfn incon ocon att = IM (makeRC (qd ^. uid) (qd ^. term) dfn 
  (sy qd $= qd ^. equat)) (vars (qd^.equat) ctx) incon (qw qd) ocon att
