#!/bin/bash

if hash zenity 2>/dev/null; then
  :
else
  sudo apt-get update
  sudo apt-get install zenity
fi
if hash yad 2>/dev/null; then
  :
else 
  echo "deb http://pkg.bunsenlabs.org/debian bunsen-hydrogen  main" | sudo tee -a /etc/apt/sources.list
  wget https://pkg.bunsenlabs.org/debian/pool/main/b/bunsen-keyring/bunsen-keyring_2016.7.2-1_all.deb
  sudo dpkg -i bunsen-keyring_2016.7.2-1_all.deb
  echo "#key added" | sudo tee -a /etc/apt/sources.list
  sudo apt-get update
  sudo apt-get install yad
fi
if grep -Fxq "deb http://pkg.bunsenlabs.org/debian bunsen-hydrogen  main" /etc/apt/sources.list && grep -Fxq "#key added" /etc/apt/sources.list; then
  :
else
  wget https://pkg.bunsenlabs.org/debian/pool/main/b/bunsen-keyring/bunsen-keyring_2016.7.2-1_all.deb
  sudo dpkg -i bunsen-keyring_2016.7.2-1_all.deb
  sudo apt-get update
  echo "#key added" | sudo tee -a /etc/apt/sources.list
fi

if hash mednafen 2>/dev/null; then
  :
else
  P1="Mednafen(GB,GBA,NES,SNES,NPC)|/home/chip/PocketInstaller/Installers/mednafen.sh"
fi
if hash vice 2>/dev/null; then
  :
else
  P2="Vice(C64,C128)|/home/chip/PocketInstaller/Installers/vice.sh"
fi
if hash prboom  2>/dev/null; then
  :
else
  P3="Doom|/home/chip/PocketInstaller/Installers/doom.sh"
fi
if hash openttd 2>/dev/null; then
  :
else 
  P4="OpenTTD|/home/chip/PocketInstaller/Installers/openttd.sh"
fi
if hash dosbox 2>/dev/null; then
  :
else 
  P5="DOSBox|/home/chip/PocketInstaller/Installers/dosbox.sh"
fi
if hash scummvm 2>/dev/null; then
  :
else
  P6="ScummVM|/home/chip/PocketInstaller/Installers/scummvm.sh"
fi

menu=($P1 $P2 $P3 $P4 $P5 $P6)
  
yad_opts=(--form
--scroll
--text="Install Software"
--image="/home/chip/PocketInstaller/icon.png"
--button="Install" --button="Exit")

for m in "${menu[@]}"
do
yad_opts+=( --field="${m%|*}:CHK" )
done

IFS='|' read -ra ans < <( yad "${yad_opts[@]}" )

for i in "${!ans[@]}"
do
if [[ ${ans[$i]} == TRUE ]]
then
m=${menu[$i]}
name=${m%|*}
cmd=${m#*|}
echo "selected: $name ($cmd)"
$cmd
fi
done

echo "Closing PocketInstaller, see you soon!"
sleep 3
kill -9 $PPID

