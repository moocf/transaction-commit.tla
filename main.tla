-------------------------------- MODULE main --------------------------------

CONSTANT RM

VARIABLE rmState

TCTypeOK == rmState \in [RM -> {"working", "prepared", "committed", "aborted"}]

TCInit == rmState = [r \in RM |-> "working"]

Prepare(r) == /\ rmState[r] = "working"
              /\ rmState' = [s \in RM |-> IF s = r THEN "prepared" ELSE rmState[s]]
                          (*[rmState EXCEPT ![r] = "prepared"]*)

DecideCommit(r) == /\ rmState[r] = "prepared"
                   /\ \A s \in RM : rmState[s] \in {"prepared", "committed"} 
                   /\ rmState' = [s \in RM |-> IF s = r THEN "committed" ELSE rmState[s]]

DecideAbort(r)  == /\ rmState[r] = "working" \/ rmState[r] = "prepared"
                   /\ \A s \in RM : rmState[s] # "committed"
                   /\ rmState' = [s \in RM |-> IF s = r THEN "aborted" ELSE rmState[s]]

TCNext == \E r \in RM : Prepare(r) \/ DecideCommit(r) \/ DecideAbort(r)

=============================================================================
\* Modification History
\* Last modified Sat Dec 27 13:11:26 IST 2025 by wolfr
\* Created Sat Dec 27 12:49:07 IST 2025 by wolfr
