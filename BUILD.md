# Build

## Toolchain

- Windows 10/11 x64
- CMake 3.19+
- MinGW-w64 **32-bit** (verified with MinGW 8.1) for agent/proxy/probe
- MinGW-w64 **64-bit** + Qt 6 (Widgets, Network) for the console
- Optional: MSVC x86 BuildTools; the J2534 ABI is C, but build flags differ
- No vendor J2534 DLL is required to build; it is loaded at runtime

`<mingw32>`, `<mingw64>`, `<Qt6>` below are your install paths.

## Agent / proxy / probe (32-bit)

```powershell
$env:Path = "<mingw32>\bin;" + $env:Path

cmake -S . -B build-x86 -G "MinGW Makefiles" `
  -DCMAKE_C_COMPILER=<mingw32>/bin/gcc.exe `
  -DCMAKE_CXX_COMPILER=<mingw32>/bin/g++.exe `
  -DCMAKE_MAKE_PROGRAM=<mingw32>/bin/mingw32-make.exe

cmake --build build-x86 -j4
```

Outputs in `build-x86/`:

| File | Purpose |
|---|---|
| `XnetikBridgeAgent.exe` | 32-bit agent / vendor DLL host |
| `XnetikBridgeJ2534.dll` | 32-bit J2534 proxy |
| `XnetikBridgeProbe.exe` | device list / DLL probe / voltage |
| `fakej2534.dll` | fake vendor DLL |
| `xn_test_proxy.exe` | loopback client |

The proxy DLL is built with `--add-stdcall-alias`, so both decorated and undecorated J2534 exports
are present. Verify with `objdump -p build-x86\XnetikBridgeJ2534.dll`.

## Console (64-bit, Qt 6)

```powershell
$env:Path = "<Qt6>\bin;<mingw64>\bin;" + $env:Path

cmake -S console -B build-console -G "MinGW Makefiles" `
  -DCMAKE_PREFIX_PATH=<Qt6> `
  -DCMAKE_C_COMPILER=<mingw64>/bin/gcc.exe `
  -DCMAKE_CXX_COMPILER=<mingw64>/bin/g++.exe `
  -DCMAKE_MAKE_PROGRAM=<mingw64>/bin/mingw32-make.exe

cmake --build build-console -j4
```

Deploy Qt DLLs once:

```powershell
windeployqt --no-translations build-console\XnetikBridgeConsole.exe
```

## Loopback test (no hardware)

Terminal 1:

```powershell
.\build-x86\XnetikBridgeAgent.exe --dll .\build-x86\fakej2534.dll --once
```

Terminal 2:

```powershell
$env:XNETIK_AGENT = "127.0.0.1:7534"
.\build-x86\xn_test_proxy.exe
```

Expected:

```
PASS: Open
PASS: Connect CAN 500k
PASS: Write 1 CAN frame
PASS: Read echo
PASS: READ_VBATT 13.42 V
PASS: Version ...
PASS: Start filter
PASS: SetProgrammingVoltage
PASS: Start periodic
PASS: Close
ALL PASS
```

## Status endpoint

The agent exposes read-only JSON on `--status-port` (default **7536**):

```
http://127.0.0.1:7536/status
```

Disable with `--no-status`. Bind it to the WireGuard IP for remote use; never expose it publicly.

## Proxy configuration

The DLL reads, in order:

1. `xnetik.ini` next to `XnetikBridgeJ2534.dll`
2. `%ProgramData%\Xnetik\agent.ini`
3. `%ProgramData%\Xnetik\agent.txt`

```ini
agent=10.66.0.2:7534
token=optional-shared-token
```

`XNETIK_AGENT` and `XNETIK_TOKEN` override the files.

## Probe a real VCI

```powershell
.\build-x86\XnetikBridgeProbe.exe --list
.\build-x86\XnetikBridgeProbe.exe --dll "C:\Windows\SysWOW64\VCIV200432.dll"
```

The probe opens the device and reads version/`READ_VBATT`; it does not connect a channel. Voltage may
be unavailable with no vehicle power.

## Run the agent for a real session

```powershell
.\build-x86\XnetikBridgeAgent.exe --dll "C:\Path\To\VendorJ2534.dll" --bind 10.66.0.2
```

Defaults: data `7534`, status `7536`, bind `127.0.0.1` (safe lab default).

## Notes

- 32-bit is deliberate: most J2534 OEM apps and vendor DLLs are 32-bit.
- The console is 64-bit and separate; it never loads the 32-bit DLL.
- If MinGW 8.1 cannot link `std::thread`, use a newer MinGW-w64 or MSVC x86.
