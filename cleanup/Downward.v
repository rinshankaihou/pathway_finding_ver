From mathcomp Require Import all_ssreflect.
Require Import Coq.Strings.String Coq.Bool.Bool Coq.Lists.List.
Import ListNotations.
From Coq.Arith Require Import Arith EqNat.
Open Scope string_scope.
Open Scope list_scope.
Require Import Coq.Program.Equality.
Require Import Arith.
Require Import Coq.Program.Tactics.
From Taxiway Require Import To_naive.
From Taxiway Require Import Find_path.
From Taxiway Require Import Correctness.

From Hammer Require Import Hammer.

(* This file have five theorems indicating the theorem of complete graph preserve downward*)

(* start correct *)

Definition naive_path_starts_with_vertex (path : list Edge_type) (start_v : Vertex) : Prop := 
    exists taxiway_name, exists l, path = ((start_v, input), taxiway_name) :: l.


Theorem naive_start_correct:
    forall start_v end_v ATC D (path : list Arc_type) (paths : list (list Arc_type)),
    Some paths = (find_path (start_v : Vertex) (end_v : Vertex) (ATC : list string) (D : C_Graph_type)) ->
    In path paths ->
    naive_path_starts_with_vertex (to_N_path path) start_v.
Proof. Admitted.



(* end correct*)

Definition naive_ends_with_vertex (path : list Edge_type) (end_v : Vertex) : Prop :=
    exists end_Edge,
    ((hd_error (rev path)) = Some end_Edge) /\ end_Edge.1.1 = end_v.


Theorem output_path_end_correct:
    forall start_v end_v ATC D (path : list Arc_type) (paths : list (list Arc_type)),
    Some paths = (find_path (start_v : Vertex) (end_v : Vertex) (ATC : list string) (D : C_Graph_type)) ->
    In path paths ->
    naive_ends_with_vertex (to_N_path path) end_v.
Proof. Admitted.


(* in graph *)



Definition naive_path_in_graph (path : list Edge_type) (G : list Edge_type) : Prop :=
    forall a, In a (tl (path)) -> In a G.


Theorem naive_in_graph : 
    forall start_v end_v ATC D (path : list Arc_type) (paths : list (list Arc_type)),
    Some paths = (find_path (start_v : Vertex) (end_v : Vertex) (ATC : list string) (D : C_Graph_type)) ->
    In path paths ->
    naive_path_in_graph (to_N_path path) (to_N D).
Proof. Admitted.


(* connected *)

Definition Edge_conn (e1 : Edge_type) (e2 : Edge_type) : Prop :=
    e1.1.1 = e2.1.2.

Fixpoint naive_path_conn (path : list Edge_type): Prop :=
    match path with
    | path_f::path_r => match path_r with
        | path_s::path_r_r => (Edge_conn path_f path_s) /\ (naive_path_conn path_r)
        | [] => True
        end
    | [] => True
    end.

Theorem naive_conn:
    forall start_v end_v ATC D (path : list Arc_type) (paths : list (list Arc_type)),
    Some paths = (find_path (start_v : Vertex) (end_v : Vertex) (ATC : list string) (D : C_Graph_type)) ->
    In path paths ->
    naive_path_conn (rev (to_N_path path)).
Proof. Admitted.


(* follow ATC *)

Fixpoint naive_path_coresp_atc (path : list Edge_type) : list string :=
    match path with
    | [] => []
    | a::b => match b with
        | []   => [a.2]
        | c::l => if (a.2 =? c.2) 
        then (naive_path_coresp_atc b)
        else a.2::(naive_path_coresp_atc b)
        end 
    end.


Definition naive_path_follow_atc (path : list Edge_type) (atc : list string) : Prop :=
    atc = naive_path_coresp_atc path.


Theorem naive_follow_atc:
    forall start_v end_v ATC D (path : list Arc_type) (paths : list (list Arc_type)),
    Some paths = (find_path (start_v : Vertex) (end_v : Vertex) (ATC : list string) (D : C_Graph_type)) ->
    In path paths ->
    naive_path_follow_atc (to_N_path path) ATC.
Proof. Admitted.