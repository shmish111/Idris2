||| Until Idris2 starts supporting the 'syntax' keyword, here's a
||| poor-man's equational reasoning
module Syntax.PreorderReasoning

infixl 0  ~~
prefix 1  |~
infix  1  ...

|||Slightly nicer syntax for justifying equations:
|||```
||| |~ a
||| ~~ b ...( justification )
|||```
|||and we can think of the `...( justification )` as ASCII art for a thought bubble.
public export
(...) : (x : a) -> (y ~=~ x) -> (z : a ** y ~=~ z)
(...) x pf = (x ** pf)

public export
data FastDerivation : (x : a) -> (y : b) -> Type where
  (|~) : (x : a) -> FastDerivation x x
  (~~) : FastDerivation x y -> (step : (z : c ** y ~=~ z)) -> FastDerivation x z
  
public export 
Calc : {x : a} -> {y : b} -> FastDerivation x y -> x ~=~ y
Calc (|~ x) = Refl
Calc {y} ((~~) {z=y} {y=y} der (y ** Refl)) = Calc der

{- -- requires import Data.Nat
0
example : (x : Nat) -> (x + 1) + 0 = 1 + x
example x = 
  Calc $ 
   |~ (x + 1) + 0
   ~~ x+1  ...( plusZeroRightNeutral $ x + 1 )
   ~~ 1+x  ...( plusCommutative x 1          )
-}
