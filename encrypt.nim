#[
    Adampted From:
    Author: Marcello Salvati, Twitter: @byt3bl33d3r
    License: BSD 3-Clause

    AES256-CTR Encryption/Decryption
]#

import nimcrypto
import nimcrypto/sysrand
#import winim/lean


func toByteSeq*(str: string): seq[byte] {.inline.} =
  ## Converts a string to the corresponding byte sequence.
  @(str.toOpenArrayByte(0, str.high))

proc encrypt*(plaintext: seq[byte], envkey = ""): void =
    var
        ectx: CTR[aes256]
        key: array[aes256.sizeKey, byte]
        iv: array[aes256.sizeBlock, byte]
        enctext = newSeq[byte](len(plaintext))

    # Create Random IV
    discard randomBytes(addr iv[0], 16)

    # Expand key to 32 bytes using SHA256 as the KDF
    var expandedkey = sha256.digest(envkey)
    copyMem(addr key[0], addr expandedkey.data[0], len(expandedkey.data))

    ectx.init(key, iv)
    ectx.encrypt(plaintext, enctext)
    ectx.clear()

    echo "IV: ", toHex(iv)
    echo "ENKEY: ", envkey
   # echo "PLAINTEXT: ", toHex(plaintext)
   # echo "ENCRYPTED TEXT: ", toHex(enctext)

    var lines = [toHex(iv) ,toHex(enctext)]
    let f = open("encrypt.txt", fmWrite)

    for line in lines:
        f.writeLine(line)

    f.close()
    echo "ENCRYPTED PAYLOAD: ./encrypt.txt"
    echo "PAYLOAD SIZE = " & $(len(plaintext)) & " - Check decrypt.nim dectext and return array size matches"

