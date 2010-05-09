(* *********************************************************************)
(*                                                                     *)
(*              The Compcert verified compiler                         *)
(*                                                                     *)
(*          Xavier Leroy, INRIA Paris-Rocquencourt                     *)
(*                                                                     *)
(*  Copyright Institut National de Recherche en Informatique et en     *)
(*  Automatique.  All rights reserved.  This file is distributed       *)
(*  under the terms of the GNU General Public License as published by  *)
(*  the Free Software Foundation, either version 2 of the License, or  *)
(*  (at your option) any later version.  This file is also distributed *)
(*  under the terms of the INRIA Non-Commercial License Agreement.     *)
(*                                                                     *)
(* *********************************************************************)

(** Axiomatization of floating-point numbers. *)

(** In contrast with what we do with machine integers, we do not bother
  to formalize precisely IEEE floating-point arithmetic.  Instead, we
  simply axiomatize a type [float] for IEEE double-precision floats
  and the associated operations.  *)

Require Import Coqlib.
Require Import Integers.

Parameter float: Type.

Module Float.

Parameter zero: float.
Parameter one: float.

Parameter neg: float -> float.
Parameter abs: float -> float.
Parameter singleoffloat: float -> float.
Parameter intoffloat: float -> int.
Parameter intuoffloat: float -> int.
Parameter floatofint: int -> float.
Parameter floatofintu: int -> float.

Parameter add: float -> float -> float.
Parameter sub: float -> float -> float.
Parameter mul: float -> float -> float.
Parameter div: float -> float -> float.

Parameter cmp: comparison -> float -> float -> bool.

Axiom eq_dec: forall (f1 f2: float), {f1 = f2} + {f1 <> f2}.

Parameter bits_of_double: float -> int64.
Parameter double_of_bits: int64 -> float.

Parameter bits_of_single: float -> int.
Parameter single_of_bits: int -> float.

(** Below are the only properties of floating-point arithmetic that we
  rely on in the compiler proof. *)

Axiom addf_commut: forall f1 f2, add f1 f2 = add f2 f1.

Axiom subf_addf_opp: forall f1 f2, sub f1 f2 = add f1 (neg f2).

Axiom singleoffloat_idem:
  forall f, singleoffloat (singleoffloat f) = singleoffloat f.

Axiom cmp_ne_eq:
  forall f1 f2, cmp Cne f1 f2 = negb (cmp Ceq f1 f2).
Axiom cmp_le_lt_eq:
  forall f1 f2, cmp Cle f1 f2 = cmp Clt f1 f2 || cmp Ceq f1 f2.
Axiom cmp_ge_gt_eq:
  forall f1 f2, cmp Cge f1 f2 = cmp Cgt f1 f2 || cmp Ceq f1 f2.

Axiom double_of_bits_of_double:
  forall f, double_of_bits (bits_of_double f) = f.
Axiom single_of_bits_of_single:
  forall f, single_of_bits (bits_of_single f) = singleoffloat f.

Axiom bits_of_singleoffloat:
  forall f, bits_of_single (singleoffloat f) = bits_of_single f.
Axiom singleoffloat_of_bits:
  forall b, singleoffloat (single_of_bits b) = single_of_bits b.

End Float.
