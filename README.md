# ARM-Assembly-Fighting-Game
This project is meant to work as a fighting game between two DE1-SoC boards. Each code represent one board, either Avatar 1 or 2. 

Explanation of code and project:
Summary: This program connects two DE1-SoC boards and uses the switches, pushbuttons, JP2 for input and uses the LEDs, JP2, and
seven segment for output. 
Goal: This project seeks to display two avatars, each controlled by their own board and set of pushbuttons to create an interactive
fighting game, with a functioning attack and health system.
By using bitmasking techniques two avatars in the shape of "7" and "L" are able to move acorss a 1-dimensional plane and attack. Damage is
dealt when the distance is close enough. To properly display graphics a coordinate system is used to loacte where each avatar is at all times.
The coordinate registers will update accordingly when the user interacts with the pushbuttons to move. Since the board displays two avatars at time
the JP2 pins act as an input and a output for the program. The information of the current board is read in, while the information of the opposite board
(and avatar) is read out. This set up is explained in the Instructions section. The game also contains a menu when first opening up, the seven segments will be
blank until any switch is flipped. Indicating that it is at the menu the first LED will be high. Be sure to flip the switch back down when the game begins,
unless the user would like to auto-respawn.

How to Play:
When game compiles menu will be entered, flip switch to activate. 
Health bar will appear on LEDs. Inital healthpoints will be 5, indicated by 5 lights being high.
The avatars are interacted with through the pushbuttons, to control your boards respective avatar:
First pushbutton: Move right
Second pushbutton: Move left
Third pushbutton: Attack right
Fourth pushbutton: Attack left
After losing your avatar will be sent back to the menu and your character will reappear, once any switch is flipped.
After winning your avatar will remain how it was when it won, Even health will be not reset back to 5 HP (unfinished section).

Insructions to set up Circuit:
For the boards to properly connect a circuit must connect both boards. For this project we used the JP2 pins on the board.
Pins 0-3 on each board is for output, and pins 4-7 act as the input for the opposite boards character interactions. 
Pin 0 represents to move right
Pin 1 represents to move left
Pin 2 represents to attack right
Pin 3 represents to attack left
This holds true for both of the boards. Pins 4-7 for the input correspond to the same numerical order.
This format holds true for ALL pins. 
1. First place the output pin to a node
2. Connect a 5.7 KOhm resistor in that node into another
3. Place the input pin at the end node of the resistor
4. Place a LED in foward bias orientation at the same node and connect to ground
This set up holds true for all the factors. However be sure that both ground for each output to input corresponds to the ground of the board
reading the input. This will mean there are TWO different grounds. The power supply is not nessary for this build,
as the output pin will supply a voltage when high.

Unfinished Sections:
The code remains incomplete, the program should respond to the victor avatar after the opposite avatar loses.
This is currently not the case and should be fixed in the future. Our group ultimatley ran out of time and this section has gone
unfinished. 

Final Anylsis:
Ultimatley the project is very well put together and all of the inital goals were hit. There are just some final debugging
errors related to the menu and win conditons that must be sorted out. Also the timing must be fixed, as of now there is a delat between when an action occurs
between the avatars board to the other users board. The program should be adjusted such that each board recieves and displays the same data at similar increments.
