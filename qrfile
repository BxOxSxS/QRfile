#!/bin/bash
if [[ $1 == "create" ]]; then
     if [ $2 == -b ]; then
          cipher=base64
          path="$3"
     else
          cipher=ascii85
          path="$2"
     fi
     if [ ! -f "$path" ]; then
          echo File \"$path\" does not exists!
          exit 1
     fi

     file="$(basename "$path")"
     cp -f "$path" "${file}_work"

     if [ -d "${file}_qr" ]; then
          while true; do
               read -p "Dir \"${file}_qr\" already exist remove it? Y/N " yn
               case $yn in
                    [Yy]* ) rm -rf "${file}_qr"; break;;
                    [Nn]* ) exit 130;;
                    * ) echo "Please answer Y or N.";;
               esac
          done
     fi
     echo Creating ${cipher}...
     mkdir "${file}_${cipher}"
     ${cipher} "${file}_work" > "${file}_${cipher}"/"$file"
     echo Creating split...
     cd "${file}_${cipher}"
     split -b 2953 -d "$file" "$file."
     rm -rf "$file"
     files=$(ls | wc -l)
     echo Created $files files
     echo Creating QR...
     n=1
     for a in "$file".*
     do
          qrencode  -8 -d 10 -m 1 -o $a.png < $a
          rm -rf "$a"
          printf "\r$n/$files"
          ((n++))
     done
     echo > ${cipher}
     cd ..
     mv "${file}_${cipher}" "${file}_qr"
     rm "${file}_work"
elif [[ $1 == "convert" ]]; then
     if [ ! -d $2 ]; then
          echo Dir \"$2\" does not exists!
          exit 1
     fi
     dir="$(basename "$2")"
     cp -Rf "$2" "${dir}_work"
     if [ -d "${dir}_cqr" ]; then
          while true; do
               read -p "Dir \"${dir}_cqr\" already exist remove it? Y/N " yn
               case $yn in
                    [Yy]* ) rm -rf "${dir}_cqr"; break;;
                    [Nn]* ) exit 130;;
                    * ) echo "Please answer Y or N.";;
               esac
          done
     fi
     echo Converting QR...
     mkdir "${dir}_cqr"
     cd "${dir}_work"
     if [ -f "ascii85" ]; then
          cipher=ascii85
     elif [ -f base64 ]; then
          cipher=base64
     else
          echo "Cannot figure out what cipher is! Create a file in the dir with the name of a supported cipher"
          cd ..
          rm -rf "${dir}_cqr"
          rm -rf "${dir}_work"
          exit 1
     fi

     files=$(ls *.png | wc -l)
     echo Finded $files files
     n=1
     for a in ${a}*.png
     do
          zbarimg  -q $a > "../${dir}_cqr/${a}.txt"
          printf "\r$n/$files"
          ((n++))
     done
     echo Connetcing files...
     cd "../${dir}_cqr"
     cat * > "../${dir}_${cipher}.txt"
     sed -r 's/^QR-Code://' "../${dir}_${cipher}.txt" > "../${dir}_s${cipher}.txt"
     cd ..
     echo Decoding ${cipher}...
     ${cipher} -d "${dir}_s${cipher}.txt" > "${dir}_converted"
     echo Removing working dir and files...
     rm -rf "${dir}_cqr"
     rm -rf "${dir}_${cipher}.txt"
     rm -rf "${dir}_s${cipher}.txt"
     rm -rf "${dir}_work"

else
     echo Unkown  parametr
fi
