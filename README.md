# CI3815 Project II: Pac-Man in MIPS Assembly

Implementation of the arcade game Pac-Man in Mips Assembly.

## How to get it to work

+ Download the modified version of MARS and open it (it Linux this can be done opening the terminal in the folder containing the .jar file and typing
```
> java -jar MarsFork.jar
```

+ Go to File/Open and click `Main.s`.
+ Go to Settings/Exception Handler, mark "Include this exception handler file in all assemble operation", then click "Browse" and select `myexception.s`.
+ Go to Tools/Bitmap Display and click "Connect to MIPS", repeat the procedure with Keyboard and Display MMIO Simulator.
+ Assemble and run, and click on the text rectangle on the Keyboard MMIO Simulator.
+ Enjoy :).

## Game configuration 🔧

You can configure some parameters in `Main.s` to make the game work as you want, you can find the on the first line of the `.data` segment:

+ ***MAT***: The base address of the memory for the Bitmap Display. Make sure is the same as the one displayed on the tool. Be careful, you can mess things up with some bad address in MAT.
+ ***S***: Integer with the amount of "seconds" that'll take the Bitmap Display to refresh.
+ ***C***: Integer, base for the conversion of the clock ticks. See this as a number related to the speed your processor is running, the faster the processor is, the more we recommend set it to higher numbers (2000-3000). Every time an internal variable reaches C, a "second" is counted, so this number is directly related with S. E/g: setting C as 600 and S to 2 would be the same as setting C to 1200 and S to 1, as the Bitmap Display will refresh every 1200 tics. We recomend not to set C as less than 1000 as it may cause errors with the procedure that handles the interruptions and make the game fall in and infinite loop.
+ ***D***: Current direction that Pac-Man is moving to. Modify it to modify the direction that the Pac-Man will move as the game begins, it can be either 'W', 'A', 'S' or 'D'.
+ ***V***: Number of lives. Pretty self explanatory.

## Game commands 👾

+ ***To move the main character***:
  - Up: W/w.
  - Left: A/a.
  - Down: S/s.
  - Right: D/d.
+ ***Game menu***:
  - Play/pause: Spacebar.
  - Quit: Enter.

## Rules 📏

Avoid to be eaten and eat every food on the display. You will lose a live every time a ghost eats you or when you eat all the food (sorry 🙁 ). The game is over when you lose all the lives.

The ghosts take a random direction on every intersection.

When you finish (either by quitting or losing all the lives) a message will be displayed on the console with your remaining lives, the progress you made and the time you played.

Enjoy our beautiful implementation! Feel free to contact us if you wanna know something about it or if you see some sort of bug.

---

Made with ❤ by [chrischriscris](https://github.com/chrischriscris/) and [fungikami](https://github.com/fungikami/).
