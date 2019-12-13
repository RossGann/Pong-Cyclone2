README

Description: 

This demonstration shows how to create a game of Sudden Death Pong with a Cyclone 2 FPGA board using VGA graphics.
__________________________________________________________________________________________________________________
Running program:

Connect a VGA cable to the output of the Cyclone II FPGA board to a VGA equipped monitor.
Launch Quartus software and navigate to the project folder and use the Pong-cyclone2.qpf file to start the program.
 Open the Programmer menu under the Tools menu.
Use the Pong-cyclone2.sof file shown, or if not shown, locate it in the project folder.
Ensure the USB-Blaster is configured and listed appropriately. 
Click the start button to begin the game.
___________________________________________________________________________________________________________________
User Inputs:

Key3 - left player down
Key2 - left player up

Key1 - right player down
Key0 - right player up

Sw9 - rst switch
Sw0 - start switch
____________________________________________________________________________________________________________________
Compiling:

Launch Quartus II.
Open the Pong-cyclone2 project in the installed folder.
Start compilation from the Processing tab, “Start Compilation”
After finishing compiling, you can run the program with the generated Pong-cyclone2.sof file
____________________________________________________________________________________________________________________
How to play:

1. Begin with the reset switch (SW[9]) in the ‘on’ position.
2. Switching the start switch (SW[0]) to ‘on’ with immediately start the game.
3. Use the FPGA’s buttons to control the movement of both paddles, player 1 receives KEY[3] and KEY[2] to move up and down. Player 2 receives KEY[1] and KEY[0] to move up and down as well.
4. Upon the collision of the ball and either left or right boundary, the game will end, presenting a Game Over screen.
5. Setting SW[0] ‘off’ and SW[9] ‘off’ then ‘on’ again will reset the program.
