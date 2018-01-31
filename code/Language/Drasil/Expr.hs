{-# LANGUAGE GADTs #-}
-- | The Drasil Expression language
module Language.Drasil.Expr where

import Data.Ratio (numerator,denominator)
import Prelude hiding (id, sqrt)
import Language.Drasil.Chunk (Chunk(..))
import Language.Drasil.Symbol
import Language.Drasil.Space (Space(..))

import Control.Lens ((^.))

--FIXME: Haddock open issue #43 seems to make it so GADT constructors cannot
-- be documented properly

type Relation = Expr

infixr 8 $^
infixl 7 $/
infixr 4 $=
infixr 9 $&&
infixr 9 $||

data Oper = Add | Mul | And | Or
  deriving (Eq)

-- | Drasil Expressions
data Expr where
  V        :: Variable -> Expr
  Dbl      :: Double -> Expr
  Int      :: Integer -> Expr
  Assoc    :: Oper -> [Expr] -> Expr
  Deriv    :: Chunk c => DerivType -> Expr -> c -> Expr -- Derivative, syntax is:
  -- Type (Partial or total) -> principal part of change -> with respect to
  -- For example: Deriv Part y x1 would be (dy/dx1)
  C        :: (Chunk c) => c -> Expr -- Chunk (must have a symbol)
  FCall    :: Expr -> [Expr] -> Expr -- F(x) is (FCall F [x]) or similar
                                  -- FCall accepts a list of params
                                  -- F(x,y) would be (FCall F [x,y]) or sim.
  Case     :: [(Expr,Relation)] -> Expr -- For multi-case expressions,
                                     -- each pair represents one case
  Matrix   :: [[Expr]] -> Expr
  Index    :: Expr -> Expr -> Expr  -- for accessing elements of sequence/list/vect etc.
                                    -- arr[i] is (Index arr i)
  Grouping :: Expr -> Expr
  UnaryOp  :: UFunc -> Expr
  BinaryOp :: BiFunc -> Expr
  EOp      :: EOperator -> Expr

  IsIn  :: Expr -> Space -> Expr --	element of

($=), ($!=), ($<), ($>), ($<=), ($>=), ($=>), ($<=>), ($.), ($-), 
  ($/) :: Expr -> Expr -> Expr
($=)  a b = BinaryOp $ EEquals a b
($!=) a b = BinaryOp $ ENEquals a b
($<)  a b = BinaryOp $ ELess a b
($>)  a b = BinaryOp $ EGreater a b
($<=) a b = BinaryOp $ ELessEq a b
($>=) a b = BinaryOp $ EGreaterEq a b
a $=> b = BinaryOp $ Implies a b
a $<=> b = BinaryOp $ IFF a b
a $. b   = BinaryOp $ DotProduct a b
a $- b = BinaryOp $ Subtract a b
a $/ b = BinaryOp $ Divide a b

($^), ($&&), ($||) :: Expr -> Expr -> Expr
($^) a b = BinaryOp (Power a b)
a $&& b = Assoc And [a,b]
a $|| b = Assoc Or  [a,b]

type Variable = String

data DerivType = Part
               | Total
  deriving Eq

-- TODO: have $+ flatten nest Adds
instance Num Expr where
  a + b = Assoc Add [a, b]
  a * b = Assoc Mul [a, b]
  a - b = BinaryOp $ Subtract a b
  fromInteger a = Int a
  abs = UnaryOp . Abs
  negate = UnaryOp . Neg

  -- this is a Num wart
  signum _ = error "should not use signum in expressions"


instance Eq Expr where
  V a == V b                   =  a == b
  Dbl a == Dbl b               =  a == b
  Int a == Int b               =  a == b
  Assoc o1 l1 == Assoc o2 l2   =  o1 == o2 && l1 == l2
  Deriv t1 a b == Deriv t2 c d =  t1 == t2 && a == c && (b ^. id) == (d ^. id)
  C a == C b                   =  (a ^. id) == (b ^. id)
  FCall a b == FCall c d       =  a == c && b == d
  Case a == Case b             =  a == b
  IsIn  a b  == IsIn  c d      =  a == c && b == d
  BinaryOp a == BinaryOp b     =  a == b
  _ == _                       =  False

instance Fractional Expr where
  a / b = BinaryOp $ Divide a b
  fromRational r = BinaryOp $ Divide (fromInteger $ numerator   r)
                                     (fromInteger $ denominator r)


--Known math functions.
-- TODO: Move the below to a separate file somehow. How to go about it?

-- | Binary Functions
data BiFunc =
    Cross Expr Expr -- Cross Product: HTML &#10799;
  | Power Expr Expr -- Power operator
  | EEquals Expr Expr
  | ENEquals Expr Expr
  | ELess Expr Expr
  | EGreater Expr Expr
  | ELessEq Expr Expr
  | EGreaterEq Expr Expr
  | Implies Expr Expr  -- implies, &rArr; \implies
  | IFF Expr Expr  -- if and only if, &hArr; \iff
  | DotProduct Expr Expr
  | Subtract Expr Expr
  | Divide Expr Expr
  deriving Eq

-- | Operators
-- All operators take a |DomainDesc| and a variable
-- FIXME: the Variable should not be an |Expr|
data EOperator where
  Summation :: DomainDesc -> Expr -> EOperator
  Product :: DomainDesc -> Expr -> EOperator
  Integral :: DomainDesc -> Expr -> EOperator

-- | Unary functions
data UFunc where
  Norm   :: Expr -> UFunc -- Norm
  Abs    :: Expr -> UFunc -- Absolute value
  Log    :: Expr -> UFunc
  Sin    :: Expr -> UFunc
  Cos    :: Expr -> UFunc
  Tan    :: Expr -> UFunc
  Sec    :: Expr -> UFunc
  Csc    :: Expr -> UFunc
  Cot    :: Expr -> UFunc
  Exp    :: Expr -> UFunc
  Sqrt   :: Expr -> UFunc
  Not    :: Expr -> UFunc
  Neg    :: Expr -> UFunc
  Dim    :: Expr -> UFunc -- dimension (mostly of a vector)

-- | Domain Description. A 'Domain' is the extent of a variable that
-- ranges over a particular Space. So a |DomainDesc| contains
-- a variable, a Space and a "description of a subspace".
-- Except that the kinds of descriptions we want for different kinds of
-- spaces really are quite different. So we will internalize the |Space|
-- into the description. Which means that only some |Space|s will be
-- represented, as needed.
-- [Later when we move to GADTs, some of this can be unified]
-- We use a phantom type in |RealRange| as a proxy for now
data DomainDesc where
  RealDD :: Symbol -> RealRange Double -> DomainDesc
  IntegerDD :: Symbol -> RealRange Integer -> DomainDesc
  All :: Symbol -> DomainDesc

data Inclusive a where
  Inc :: a -> Inclusive a
  Exc :: a -> Inclusive a

-- | RealInterval. A |RealInterval| is a subset of |Real| (as a |Space|).
-- These come in different flavours.
-- For now, embed |Expr| for the bounds, but that will change as well.
data RealInterval where
  Bounded :: Inclusive Expr -> Inclusive Expr -> RealInterval  -- (x .. y)
  UpTo :: Inclusive Expr -> RealInterval -- (-infinity .. x)
  UpFrom :: Inclusive Expr -> RealInterval -- (x .. infinity)

-- | RealRange is a specialized version of |RealInterval| to simplify
-- integration, summation, etc, where the |Inclusive| would just be noise.
data RealRange a = BoundedR Expr Expr
