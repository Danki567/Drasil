{-# OPTIONS -Wall #-} 
module ASTInternal where
import qualified Data.Map.Strict as Map
import Config
import Data.List


type Chunk = Map.Map
type FName = Field
type FDesc = Spec
type Dependency = [Chunk FName FDesc]

data Expr = Chnk Variable
          | Dbl Double
          | Int Integer
          | Expr :* Expr
          | Expr :+ Expr
          | Expr :/ Expr
          | Div Expr Expr -- used internally (ONLY)
  deriving (Eq, Ord)

type Variable = Chunk FName FDesc

--For writing chunks in a specification language that can be converted to TeX
data Spec = E Expr          -- Expressions
            | S String      -- Strings, used for Descriptions/Symbols in Chunks
            | Spec :- Spec  -- Subscripting (Spec :- Spec -> Spec_{Spec} in TeX)
            | Spec :^ Spec  -- Superscript (Spec :^ Spec -> Spec^{Spec} in TeX)
            | Empty         -- Blank
            | U Unicode   -- Greek Character
  deriving (Eq, Ord)
  
data Unicode = Tau_L
               | Tau_U
               | Alpha_L
               | Alpha_U
  deriving (Eq,Ord)
               -- ... Greek letters, lower and uppercase.
data Context = Pg | Eqn | Code -- paragraph, equation, or code
----------------------------------------------------------------
-- Make things prettier
v :: Variable -> Expr
v = Chnk


--Get dependency from equation  
get_dep :: Expr -> Dependency
get_dep (a :/ b) = nub (get_dep a ++ get_dep b)
get_dep (a :* b) = nub (get_dep a ++ get_dep b)
get_dep (a :+ b) = nub (get_dep a ++ get_dep b)
get_dep (Chnk c) = [c]
get_dep (Int _) = []
get_dep _ = error "Unexpected use of get_dep"