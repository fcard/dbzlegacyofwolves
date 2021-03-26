# Dragon Ball Z: The Legacy of Not Dying to Wolves

This is a hack of Dragon Ball Z: The Legacy of Goku that aims to balance the game's difficulty, fix bugs, and fix its flow.

Changes:
  * Enemies only do a fraction of the damage they normally would, depending on how strong they are.
  * Flight now regenerates when you're not flying.
  * Stats changed on all levels, for a more gradual increase in strength.
  * Attacks no longer have a chance of causing no damage.
  * Fixed bug where attacks would heal, potentially overflowing the target's health and instantly killing them (targets including Goku himself!)
  * Boosted health of Raditz, Vegeta and Ginyu.
  * Changed bankrobber's health from 7000 to 800.
  * The last few levels are much easier to acquire.

# Building

Building requires devkitpro, python 3, and a Legacy of Goku rom. Here's an example building on Linux:
```sh
$ cd dbzlegacyofwolves
$ arm-none-eabi-gcc -mthumb-interwork -mthumb -specs=gba.specs src/main.s
$ arm-none-eabi-objcopy -O binary a.out a.gba
$ cp path/to/dbzrom.gba DBZL.gba
$ python3 patch.py
```
This will create a `final.gba` in the repository directory, which is the patched rom.
