#!/usr/bin/env sh
arm-none-eabi-gcc -mthumb-interwork -mthumb -specs=gba.specs src/main.s
arm-none-eabi-objcopy -O binary a.out a.gba
mkdir -p mode7
mkdir -p normal
cp a.gba mode7/a.gba
cp a.gba normal/a.gba
(cd normal; python3 ../patch.py)
(cd mode7;  python3 ../patch.py)
cp normal/final.gba ./final.gba
flips --create normal/DBZL.gba normal/final.gba DragonBallZ_LegacyOfNotDyingToWolves.ips
flips --create mode7/DBZL.gba  mode7/final.gba  DragonBallZ_LegacyOfNotDyingToWolves_MODE7.ips

