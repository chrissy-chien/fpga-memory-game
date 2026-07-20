# FPGA-Based Memory Game

A hardware implementation of a "Simon Says" style memory recall game, built entirely in Verilog and run on a Digilent Basys3 FPGA board.

## What it does

The game generates a random sequence of inputs and displays it to the player one step at a time. The player must repeat the sequence back correctly using the board's keypad. The current score is shown live on the board's 7-segment display, and the game ends when the player enters an incorrect step in the sequence.

## Tech stack

- **Verilog** for all game logic, written and simulated as a set of modular hardware components
- **Basys3 FPGA** (Xilinx Artix-7) as the target hardware
- **Xilinx Vivado** for synthesis, implementation, and bitstream generation

## Design

The game is broken into individual Verilog modules, each handling one piece of the hardware pipeline:

- `clock_divider.v` — divides the board's system clock down to a usable game-tick rate
- `debouncer.v` — cleans up noisy mechanical input signals from the keypad
- `keypad.v` / `keypad_decoder.v` — reads raw keypad input and decodes it into discrete key presses
- `sequence_generator.v` — generates the pseudo-random sequence for each round
- `sequence_checker.v` — compares player input against the generated sequence
- `score_tracker.v` — tracks and updates the player's current score
- `seven_segment_display.v` / `keypad_display.v` — drive the board's 7-segment display output
- `memory_game.v` — top-level module that wires the above pieces together and manages the game's state machine

## How to run it

1. Install [Xilinx Vivado](https://www.xilinx.com/support/download.html).
2. Clone this repo.
3. Open Vivado, create a new project (or open `lab_4.xpr`), and add all `.v` files as design sources.
4. Add `lab_4.xdc` as your constraints file; it maps each Verilog signal to the correct physical pin on the Basys3 board.
5. Run Synthesis, then Implementation, then Generate Bitstream.
6. Connect your Basys3 board via USB, open Hardware Manager in Vivado, and program the device with the generated bitstream.
7. Play using the board's keypad and watch your score on the 7-segment display.
