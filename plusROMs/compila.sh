#!/bin/bash
sjasmplus plus3en40.asm
split -b 16384 -d plus3en40.rom plus3en40_rom_
split -b 32768 -d plus3en40.rom plus3en40_eprom_
mmv plus3en40_rom_\* plus3en40_rom_\#1.rom
mmv plus3en40_eprom_\* plus3en40_eprom_\#1.rom

sjasmplus plus3es40.asm
split -b 16384 -d plus3es40.rom plus3es40_rom_
split -b 32768 -d plus3es40.rom plus3es40_eprom_
mmv plus3es40_rom_\* plus3es40_rom_\#1.rom
mmv plus3es40_eprom_\* plus3es40_eprom_\#1.rom

sjasmplus plus3en41.asm
split -b 16384 -d plus3en41.rom plus3en41_rom_
split -b 32768 -d plus3en41.rom plus3en41_eprom_
mmv plus3en41_rom_\* plus3en41_rom_\#1.rom
mmv plus3en41_eprom_\* plus3en41_eprom_\#1.rom

sjasmplus plus3es41.asm
split -b 16384 -d plus3es41.rom plus3es41_rom_
split -b 32768 -d plus3es41.rom plus3es41_eprom_
mmv plus3es41_rom_\* plus3es41_rom_\#1.rom
mmv plus3es41_eprom_\* plus3es41_eprom_\#1.rom

sjasmplus plus3en40divmmc.asm
split -b 16384 -d plus3en40divmmc.rom plus3en40divmmc_rom_
split -b 32768 -d plus3en40divmmc.rom plus3en40divmmc_eprom_
mmv plus3en40divmmc_rom_\* plus3en40divmmc_rom_\#1.rom
mmv plus3en40divmmc_eprom_\* plus3en40divmmc_eprom_\#1.rom

sjasmplus plus3es40divmmc.asm
split -b 16384 -d plus3es40divmmc.rom plus3es40divmmc_rom_
split -b 32768 -d plus3es40divmmc.rom plus3es40divmmc_eprom_
mmv plus3es40divmmc_rom_\* plus3es40divmmc_rom_\#1.rom
mmv plus3es40divmmc_eprom_\* plus3es40divmmc_eprom_\#1.rom

sjasmplus plus3en40mmc.asm
split -b 16384 -d plus3en40mmc.rom plus3en40mmc_rom_
split -b 32768 -d plus3en40mmc.rom plus3en40mmc_eprom_
mmv plus3en40mmc_rom_\* plus3en40mmc_rom_\#1.rom
mmv plus3en40mmc_eprom_\* plus3en40mmc_eprom_\#1.rom

sjasmplus plus3es40mmc.asm
split -b 16384 -d plus3es40mmc.rom plus3es40mmc_rom_
split -b 32768 -d plus3es40mmc.rom plus3es40mmc_eprom_
mmv plus3es40mmc_rom_\* plus3es40mmc_rom_\#1.rom
mmv plus3es40mmc_eprom_\* plus3es40mmc_eprom_\#1.rom

sjasmplus plus3en40divmmcpoke.asm
split -b 16384 -d plus3en40divmmcpoke.rom plus3en40divmmcpoke_rom_
split -b 32768 -d plus3en40divmmcpoke.rom plus3en40divmmcpoke_eprom_
mmv plus3en40divmmcpoke_rom_\* plus3en40divmmcpoke_rom_\#1.rom
mmv plus3en40divmmcpoke_eprom_\* plus3en40divmmcpoke_eprom_\#1.rom

sjasmplus plus3es40divmmcpoke.asm
split -b 16384 -d plus3es40divmmcpoke.rom plus3es40divmmcpoke_rom_
split -b 32768 -d plus3es40divmmcpoke.rom plus3es40divmmcpoke_eprom_
mmv plus3es40divmmcpoke_rom_\* plus3es40divmmcpoke_rom_\#1.rom
mmv plus3es40divmmcpoke_eprom_\* plus3es40divmmcpoke_eprom_\#1.rom


# En las que vienen a continuación se necesita
# reemplazar la rom 2 con la de la distribución oficial
sjasmplus plus3en40divide.asm
split -b 16384 -d plus3en40divide.rom plus3en40divide_rom_
# split -b 32768 -d plus3en40divide.rom plus3en40divide_eprom_
mmv plus3en40divide_rom_\* plus3en40divide_rom_\#1.rom
echo utilizar diven3e2.rom del Spectrum +3e v1.43 en lugar de plus3en40divide_rom_02.rom

sjasmplus plus3es40divide.asm
split -b 16384 -d plus3es40divide.rom plus3es40divide_rom_
# split -b 32768 -d plus3es40divide.rom plus3es40divide_eprom_
mmv plus3es40divide_rom_\* plus3es40divide_rom_\#1.rom
echo utilizar dives3e2.rom del Spectrum +3e v1.43 en lugar de plus3es40divide_rom_02.rom

sjasmplus plus3en40ide8.asm
split -b 16384 -d plus3en40ide8.rom plus3en40ide8_rom_
# split -b 32768 -d plus3en40ide8.rom plus3en40ide8_eprom_
mmv plus3en40ide8_rom_\* plus3en40ide8_rom_\#1.rom
echo utilizar sm8en3e2.rom del Spectrum +3e v1.43 en lugar de plus3en40ide8_rom_02.rom

sjasmplus plus3es40ide8.asm
split -b 16384 -d plus3es40ide8.rom plus3es40ide8_rom_
# split -b 32768 -d plus3es40ide8.rom plus3es40ide8_eprom_
mmv plus3es40ide8_rom_\* plus3es40ide8_rom_\#1.rom
echo utilizar sm8es3e2.rom del Spectrum +3e v1.43 en lugar de plus3es40ide8_rom_02.rom

