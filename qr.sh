#!/bin/bash
if [[ $1 == "create" ]]; then
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
     echo Creating base64...
     mkdir $2_base64
     base64 $2 > $2_base64/$2_base64.txt
     echo Creating split...
     cd $2_base64
     split -b 2953 -d $2_base64.txt $2_base64.txt.
     rm -rf $2_base64.txt
     echo Creating QR...
     for a in $2_base64.txt.*
     do
          qrencode  -8 -d 10 -m 1 -o $a.png < $a
          rm -rf "$a"
     done
     cd ..
     mv $2_base64 $2_qr
elif [[ $1 == "convert" ]]; then
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
     for a in ${a}*.png
     do
          zbarimg  -q $a | sed -r 's/^QR-Code://' > ../${2}_cqr/${a}.txt
     done
     echo Connetcing files...
     cd ../${2}_cqr
     cat * > ../${2}_base64.txt
     cd ..
     echo Decoding base64...
     base64 -d ${2}_base64.txt > $2_converted
     echo Removing working dir and files...
     rm -rf ${2}_cqr
     rm -rf ${2}_base64.txt

else
     echo Unkown  parametr
fi
