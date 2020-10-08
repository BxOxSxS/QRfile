#!/bin/bash
if [[ $1 == "create" ]]; then
     if [ ! -f "$2" ]; then
          echo File \"$2\" does not exists!
          exit 1
     fi
     file="$(basename "$2")"
     cp -f "$2" "${file}_work"

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
     echo Creating ascii85...
     mkdir "${file}_ascii85"
     ascii85 "${file}_work" > "${file}_ascii85"/"$file"
     echo Creating split...
     cd "${file}_ascii85"
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
     cd ..
     mv "${file}_ascii85" "${file}_qr"
     rm "${file}_work"
elif [[ $1 == "convert" ]]; then
     if [ ! -d $file ]; then
          echo Dir \"$file\" does not exists!
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
     cat * > "../${dir}_ascii85.txt"
     sed -r 's/^QR-Code://' "../${dir}_ascii85.txt" > "../${dir}_sascii85.txt"
     cd ..
     echo Decoding ascii85...
     ascii85 -d "${dir}_sascii85.txt" > "${dir}_converted"
     echo Removing working dir and files...
     rm -rf "${dir}_cqr"
     rm -rf "${dir}_ascii85.txt"
     rm -rf "${dir}_sascii85.txt"
     rm -rf "${dir}_work"

else
     echo Unkown  parametr
fi
