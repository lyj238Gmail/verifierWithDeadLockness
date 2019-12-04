open Utils
open Core.Std

open Paramecium
open ToStr



val allSubFormofRules : Paramecium.protocol-> formula list
val  extract : Paramecium.protocol-> formula list
val extractSubFormsByRule:  Paramecium.protocol-> (string * (formula list)) list


