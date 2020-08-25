#!/bin/bash
if [[ $1 == "create" ]]; then
     if [ ! -f $2 ]; then
          echo File \"$2\" does not exists!
          exit 1
     fi

     if [ -d $2_qr ]; then
          while true; do
               read -p "Dir \"$2_qr\" already exist remove it? Y/N " yn
               case $yn in
                    [Yy]* ) rm -rf $2_qr; break;;
                    [Nn]* ) exit 130;;
                    * ) echo "Please answer Y or N.";;
               esac
          done
     fi
     echo Creating ascii85...
     mkdir $2_ascii85
     ascii85 $2 > $2_ascii85/$2
     echo Creating split...
     cd $2_ascii85
     split -b 2953 -d $2 $2.
     rm -rf $2
     files=$(ls | wc -l)
     echo Created $files files
     echo Creating QR...
     n=1
     for a in $2.*
     do
          qrencode  -8 -d 10 -m 1 -o $a.png < $a
          rm -rf "$a"
          printf "\r$n/$files"
          ((n++))
     done
     cd ..
     mv $2_ascii85 $2_qr
elif [[ $1 == "convert" ]]; then
     if [ ! -d $2 ]; then
          echo Dir \"$2\" does not exists!
          exit 1
     fi

     if [ -d $2_cqr ]; then
          while true; do
               read -p "Dir \"$2_cqr\" already exist remove it? Y/N " yn
               case $yn in
                    [Yy]* ) rm -rf $2_cqr; break;;
                    [Nn]* ) exit 130;;
                    * ) echo "Please answer Y or N.";;
               esac
          done
     fi
     echo Converting QR...
     mkdir ${2}_cqr
     cd $2
     files=$(ls *.png | wc -l)
     echo Finded $files files
     n=1
     for a in ${a}*.png
     do
          zbarimg  -q $a > ../${2}_cqr/${a}.txt
          printf "\r$n/$files"
          ((n++))
     done
     echo Connetcing files...
     cd ../${2}_cqr
     cat * > ../${2}_ascii85.txt
     sed -r 's/^QR-Code://' ../${2}_ascii85.txt > ../${2}_sascii85.txt
     cd ..
     echo Decoding ascii85...
     ascii85 -d ${2}_sascii85.txt > $2_converted
     echo Removing working dir and files...
     rm -rf ${2}_cqr
     rm -rf ${2}_ascii85.txt
     rm -rf ${2}_sascii85.txt

else
     echo Unkown  parametr
fi
