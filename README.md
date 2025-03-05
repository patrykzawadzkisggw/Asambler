# Projects Overview

## Project 1: Common Divisors Finder (`proc.asm`) [Download proc.com](https://github.com/patrykzawadzkisggw/Asambler/releases/latest/download/proc.com)

This project creates a `.com` file that allows you to find all common divisors of two specified numbers. It operates on systems that support `.com` files, such as Windows 7 and older. For newer systems, it can only be run on DOSBox.

![image](img/1.png)

### Features

- Prompts the user to enter two numbers.
- Calculates and displays all common divisors of the entered numbers.
- Supports interactive continuation or termination of the program.

### How to compile

```bash
nasm -f bin -o proc.com proc.asm
```

## Project 2: Square Root Finder (`pierwiastek_interface.c` and `pierwiastek_procedure.asm`)

This project finds the square root of a selected number with a specified precision using Heron's algorithm. The project can be run on computers with Windows and operates in 32-bit mode.

![image](img/2.png)

### Features

- Prompts the user to enter a floating-point number.
- Prompts the user to enter the number of decimal places for precision (0-10).
- Calculates and displays the square root of the entered number using Heron's algorithm.

### How to compile

```bash
nasm -o pierwiastek_procedure.o -f coff pierwiastek_procedure.asm
gcc -m32 pierwiastek_procedure.o pierwiastek_interface.c -o pierwiastek.exe
```
