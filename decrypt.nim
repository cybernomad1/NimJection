#[
    Adampted From:
    Author: Marcello Salvati, Twitter: @byt3bl33d3r
    License: BSD 3-Clause

    AES256-CTR Encryption/Decryption
]#

import nimcrypto
import nimcrypto/sysrand
import strutils

func toByteSeq*(str: string): seq[byte] {.inline.} =
  ## Converts a string to the corresponding byte sequence.
  @(str.toOpenArrayByte(0, str.high))

proc decrypt*(envkey = "", payload = ""): array[43132,byte] =

    var
        dctx: CTR[aes256]
        key: array[aes256.sizeKey, byte]
        dectext: array[43132,byte]
        iv = nimcrypto.fromHex(splitLines(payload)[0])
        enctext = nimcrypto.fromHex(splitLines(payload)[1])
    

    var expandedkey = sha256.digest(envkey)
    copyMem(addr key[0], addr expandedkey.data[0], len(expandedkey.data))


    dctx.init(key, iv)
    dctx.decrypt(enctext, dectext)
    dctx.clear()
    
    return dectext

#echo "ENCRYPTED TEXT: ", toHex(enctext)
#echo "DECRYPTED TEXT: ", toHex(dectext)
