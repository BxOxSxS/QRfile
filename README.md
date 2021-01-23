# QRfile - Any file to QR
Bash script that can convert any file to splitted QR codes and vice versa

## How it works
* Encode:
     1. Converts file to ascii85 or base64 text file
     2. Splits text file to many files with the maximum size of QR code (2953 bytes)
     3. Creates QR code from each file
     4. Creates QR code with info about file
* Decode
     1. Converts QR to splitted text files
     2. Connects files into one
     3. Decodes file using ascii85 or base64

## Requirement
* bash
* ascii85 and/or base64
* [GNU Coreutils](https://www.gnu.org/software/coreutils/)
* [GNU Sed](https://www.gnu.org/software/sed/)
* [qrencode](https://github.com/fukuchi/libqrencode) (for encode QR)
* [zbar](https://github.com/mchehab/zbar) (also know as zbar-tools) (for decode QR)
* sha512sum and/or sha256sum for checking hash sum (optional)

## How to use
Script always have two required parametrs
* `create [options] [file]` it will create QR codes into qr_[filename] add

  Options:
  * `-a`, `--ascii` or `--ascii85` before file to use ascii85 (default)
  * `-b`, `--base` or `--base64` before file to use base64
  * `-256`, `--sha256` before file to attach sha256 sum to QR
  * `-512`, `--sha512` before file to attach sha512 sum to QR
  * `-t`, `--test` before file to test dir after creating QR codes


* `convert [qr codes dir]` it will convert file from QR codes in the given dir to `[file]_converted`

  **Warning! Script will try to convert all `.png` files from that dir so make sure it only has appropriate files**

Example of usage: `bash qrfile create file.zip`, `bash qrfile create -b -512 file.zip`,`bash qrfile convert file.zip_qr`

**Warning!** script creates info QR png with required info (such as name, cipher and hash) and it need to have name`*info.png` to property decode QR files and check hash sum

## Instalation
QRfile is bash script so you can just download it and run but I have created `makefile` so you can easily install and uninstall it and run in every path

```
git clone https://github.com/BxOxSxS/QRfile
cd QRfile
sudo make install
```
To uninstall:
```
sudo make uninstall
```

## But Why?
I really don't know. The process takes an unprofitable amount of memory and time:
1 Mib encode to 3,6Mib (base64: 3.8) in 450 (480) png files in about 5 seconds and decodes in about 1 minute but I have done it. You can now convert your favorite song into QR codes and hang it on the wall
