# GitHub repository setup

## Repository name

`xnetik-bridge`

Alternatives: `xnetik-j2534-tcp`, `xnetik-bridge-j2534`.

## Description (GitHub "About")

> 32-bit J2534-over-TCP proxy and remote agent for OEM diagnostics/flashing over WireGuard. Auto-discovers vendor J2534 DLLs, streams CAN frames, reports link/voltage, and pairs with a Qt link console.

Shorter version:

> Remote J2534 over WireGuard: 32-bit proxy DLL + agent + link console.

## Topics

```
j2534
obd2
obd-ii
automotive
diagnostics
can-bus
iso15765
uds
windows
cpp
qt
wireguard
remote-diagnostics
vehicle-diagnostics
```

## About this project (long)

Xnetik Bridge lets a Windows OEM diagnostic application use a J2534 vehicle interface that is
physically on another PC — typically at the car — without exposing a public port on that PC.

The operator runs the OEM software locally. A 32-bit J2534 proxy DLL forwards `PassThru*` calls over
a WireGuard tunnel to a 32-bit agent next to the vehicle. The agent loads the vendor's J2534 DLL, so
ISO-TP, filters, and programming voltage are handled by the vendor's own code. A Qt link console shows
RTT/jitter/loss, battery voltage, VCI/channel state, and errors.

It is not a flasher. It does not implement flash algorithms, seed/key, or firmware files. It proxies
existing J2534 software.

## Recommended repository settings

- **Visibility:** private until licensing, OEM-app compatibility, and safety testing are sorted.
- **License:** currently "all rights reserved" in `LICENSE`; replace when a final license is chosen.
- **Default branch:** `main`.
- **Issues:** enabled for bugs/compatibility reports.
- **Discussions:** optional.
- **Releases:** tag the first build as `v0.1.0-mvp` when source and binaries are ready.
- **Security:** enable private vulnerability reporting.

## First commit

```bash
git init
git add .
git commit -m "Initial 32-bit J2534-over-TCP MVP"
git branch -M main
git remote add origin https://github.com/<you>/xnetik-bridge.git
git push -u origin main
```

This workspace did not have `git` installed, so the folder is prepared but not initialized.

## First release notes (template)

```
v0.1.0-mvp — 32-bit J2534-over-TCP

- 32-bit agent loads a vendor J2534 DLL; read pump; READ_VBATT at 1 Hz.
- 32-bit proxy DLL exports J2534-1 calls over TCP.
- Registry auto-discovery from both J2534 views.
- Filters, programming voltage, periodic messages, version/error.
- Optional shared-token handshake.
- Proxy config via xnetik.ini / %ProgramData%\Xnetik\agent.ini.
- HTTP /status JSON.
- Qt 6 link console: RTT/jitter/loss, Vbatt, state, device, errors.
- Loopback tests pass; Autel V200 opens and reports version.

Known limitations:
- Real-vehicle flashing not yet validated.
- No Windows service/installer yet.
- No VIN/ECU identity yet.
- 32-bit first; 64-bit only for exceptions.
```

## Social preview text

> Xnetik Bridge — remote J2534 over WireGuard. 32-bit proxy DLL + agent + link console. No public
> port on the car PC. Built for OEM diagnostics, not as a flasher.
