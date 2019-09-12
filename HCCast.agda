module HCCast (Label : Set) where
open import Types
open import Relation.Nullary using (Dec; yes; no)
open import Data.Empty using (⊥-elim)

data Head (P : PreType) : Type → Set where
  ⁇ : (l : Label) → Head P ⋆
  ε : Head P (` P)

data Last (P : PreType) : Type → Set where
  ‼ : Last P ⋆
  ε : Last P (` P)

data Tail (P : PreType) : Type → Set where
  fail : ∀ {T}
    → (l : Label)
    → Tail P T
  last : ∀ {T}
    → (t : Last P T)
    → Tail P T

mutual
  data Cast : Type → Type → Set where
    id⋆ : Cast ⋆ ⋆
    ↷ : ∀ {A P B}
      → (h : Head P A)
      → (r : Rest P B)
      → Cast A B

  data Rest : PreType → Type → Set where
    rest : ∀ {P Q B}
      → (b : Body P Q)
      → (t : Tail Q B)
      → Rest P B
    
  data Body : PreType → PreType → Set where
    U : Body U U
    _⇒_ : ∀ {S1 S2 T1 T2} →
      (c₁ : Cast S2 S1) →
      (c₂ : Cast T1 T2) →
      Body (S1 ⇒ T1) (S2 ⇒ T2)
    _⊗_ : ∀ {S1 S2 T1 T2} →
      (c₁ : Cast S1 S2) →
      (c₂ : Cast T1 T2) →
      Body (S1 ⊗ T1) (S2 ⊗ T2)
    _⊕_ : ∀ {S1 S2 T1 T2} →
      (c₁ : Cast S1 S2) →
      (c₂ : Cast T1 T2) →
      Body (S1 ⊕ T1) (S2 ⊕ T2)
