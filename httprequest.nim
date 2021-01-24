#[
    Reworked based on Marcello Salvati, Twitter: @byt3bl33d3r 's work - all credit goes it him
    License: BSD 3-Clause

    https://github.com/byt3bl33d3r/OffensiveNim/blob/master/src/http_request_bin.nim
]#

import httpclient

proc httpRequest*(URL = ""): string =

    echo "[*] Using httpclient"
    var client = newHttpClient()
    return client.getContent(URL)
