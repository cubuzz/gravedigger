#!/bin/bash

banner -f 2 Gravedigger | lolcat

__usage="Gravedigger - A simple script to quickly symetrically encrypt files.
====================================================================

This script was inspired by the TOMB project - check them out too!


Usage:

gravedigger -e file password_size # => Encrypts file, generating file.gpg and file.key in its directory.
gravedigger -d file.gpg file.key  # => Decrypts file.gpg using file.key"


if [[ $1 == "" ]];
  then
        echo "$__usage" | lolcat;
elif [[ $1 == "-e" ]];
  then
        if [ -r $2 ];
        then
                echo "Found $2... running cautionary checks on whether file was already encrypted..." | lolcat;
                if [[ ! -f "$2.gpg" && ! -f "$2.key" ]];
                then
                        if [ $3 -ge 8 ];
                        then
                                echo "We're good! Starting encryption process now..." | lolcat
                                gpg --gen-random --armor 1 $3 > $2.key
                                echo "Generated $2.key..." | lolcat
                                gpg --batch -c --passphrase-file $2.key --output $2.gpg $2
                                echo "Done! Encrypted $2 into $2.key and $2.gpg" | lolcat;
                        else
                                echo "Refusing to generate a password less than 8 bits long :(";
                        fi;
                else echo "$2.gpg or $2.key (or both) already exist. Refusing to continue.";
                fi
        else echo "Gravedigger could not access $2, aborting...";
        fi
elif [[ $1 == "-d" ]];
  then
        if [ -r $2 ];
        then
                if [ -r $3 ];
                then
                        if [ ! -f ${2%.gpg} ]
                        then
                                echo "Decrypting $2 using $3 to ${2%.gpg}..." | lolcat
                                gpg --batch -d --passphrase-file $3 --output ${2%.gpg} $2 | lolcat;
                                echo "Hooray! ${2%.gpg} has been decrypted!"
                        else
                                echo "${2%.gpg} already exists! Refusing to continue.";
                        fi;
                else
                        echo "Gravedigger could not access $3, aborting...";
                fi
        else
                echo "Gravedigger could not access $2, aborting...";
        fi
else echo "No valid arguments passed :(";
fi