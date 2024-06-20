; backup party mon low bytes
MACRO swap_info_struct
\1Species::    db
\1HP::         dw
\1BoxLevel::   db
\1Status::     db
\1Type1::      db
\1Type2::      db
\1CatchRate::  db
\1Moves::      ds NUM_MOVES
ENDM

; backup party mon high bytes
MACRO swap_stats_struct
\1PP::         ds NUM_MOVES
\1Level::      db
\1MaxHP::      dw
\1Attack::     dw
\1Defense::    dw
\1Speed::      dw
\1Special::    dw
ENDM
