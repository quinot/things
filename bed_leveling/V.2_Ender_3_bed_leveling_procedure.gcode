;Bed leveling Ender 3 by ingenioso3D
;Licence: Attribution-NonCommercial-ShareAlike
;V 2.0

G90;
M117 Bed leveling started;
G28 ; Home all axis
G04 P500;
M117 Moving to point 1;
G1 Z5 ; Lift Z axis
G1 X32 Y36 ; Move to Position 1
G1 Z0
G04 P300;
M0 Press to continue ; Pause print

M117 Moving to point 2;
G1 Z10 ; Lift Z axis
G1 X32 Y206 ; Move to Position 2
G1 Z0
G04 P300;
M0 Press to continue ; Pause print

M117 Moving to point 3;
G1 Z5 ; Lift Z axis
G1 X202 Y206 ; Move to Position 3
G1 Z0
G04 P300;
M0 Press to continue ; Pause print

M117 Moving to point 4;
G1 Z5 ; Lift Z axis
G1 X202 Y36 ; Move to Position 4
G1 Z0
G04 P300;
M0 Press to continue ; Pause print

M117 Moving to point 5;
G1 Z5 ; Lift Z axis
G1 X117 Y121 ; Move to Position 5
G1 Z0
G04 P300;
M0 Press to continue ; Pause print

M117 Moving to point 2;
G1 Z5 ; Lift Z axis
G1 X32 Y206 ; Move to Position 2
G1 Z0
G04 P300;
M0 Press to continue ; Pause print

M117 Moving to point 3;
G1 Z5 ; Lift Z axis
G1 X202 Y206 ; Move to Position 3
G1 Z0
G04 P300;
M0 Press to continue ; Pause print

M117 Moving to point 5;
G1 Z5 ; Lift Z axis
G1 X117 Y121 ; Move to Position 5
G1 Z0
G04 P300;
M0 Press to continue ; Pause print

M117 Moving to point 1;
G1 Z5 ; Lift Z axis
G1 X32 Y36 ; Move to Position 1
G1 Z0
G04 P300;
M0 Press to continue ; Pause print

M117 Leveling done;
G04 P2000;
M117 By ingenioso 3D;
G04 P800;
G28;
M84 ; disable motors



