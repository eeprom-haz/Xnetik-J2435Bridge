<div align="center">

# Xnetik Bridge

### Remote J2534 over WireGuard .

![Platform](https://img.shields.io/badge/platform-Windows%2010%2F11-0078D4?style=flat-square)
![SAE](https://img.shields.io/badge/SAE-J2534-0B5FFF?style=flat-square)
![C++](https://img.shields.io/badge/C%2B%2B-17-00599C?style=flat-square)
![Qt](https://img.shields.io/badge/Qt-6-41CD52?style=flat-square)
![Status](https://img.shields.io/badge/status-32--bit%20MVP-orange?style=flat-square)

[Build](BUILD.md) · [Architecture](docs/ARCHITECTURE.md) · [Protocol](docs/PROTOCOL.md) · [Diagnostics](docs/DIAGNOSTICS.md) · [Roadmap](ROADMAP.md)

</div>

---  *** THIS WORK IN PROGRESS****

## What it is

A **32-bit J2534 proxy** and remote agent for Windows.

- The OEM diagnostic/flashing application runs local
- The vehicle interface (VCI) on remote
- `XnetikBridgeJ2534.dll` forwards `PassThru*` calls through a WireGuard tunnel.
- `XnetikBridgeAgent.exe` loads the vendor's J2534 DLL next to the vehicle.
- A Qt link console shows **ping, loss, battery voltage, VCI state, and errors**.

No public inbound port on the car PC. No port forwarding at the customer site. Works behind CGNAT.


---

## Features



| Feature | Status |
|---|---|
| 32-bit J2534 proxy DLL | ✅ |
| 32-bit agent / vendor DLL host | ✅ |
| Push-based RX (local `PassThruReadMsgs`) | ✅ |
| CAN / ISO15765 via vendor DLL | ✅ |
| Filters, programming voltage, periodic messages | ✅ |
| Reads DLC voltage  | ✅ |
| J2534 registry auto-discovery (both views) | ✅ |
| Optional shared-token handshake | ✅ |
| Proxy config via  | ✅ |
| HTTP `/status` JSON | ✅ |
| Qt 6 link console | ✅ |
| VIN / ECU identity  NOT YET
| Windows service + installer NOT YET



---

## Current status

- 32-bit agent, proxy DLL, probe, and console.
- Virtual and Bench test passes: open, connect, write, read, version, filter, programming
  voltage, periodic messages, close.
- Real VCI connects opens and reports:
  - firmware `V1.44`
  - DLL `V2.02.14`
  - API `04.04`

```
PASS: Open
PASS: Connect CAN 500k
PASS: Write 1 CAN frame
PASS: Read echo
PASS: READ_VBATT 13.42 V
PASS: Version
PASS: Start filter
PASS: SetProgrammingVoltage
PASS: Start periodic
PASS: Close
ALL PASS
```

---

## What it is not

- Not a replacement for the VCI vendor's driver or J2534 DLL.
- Not a flashing application or firmware database.
- Not a public relay or a port-forwarding service.
- Not validated on a customer vehicle yet.

The remote site must install requires j2435 compliant VCI and driver. 

---

## Safety

Remote flashing can permanently damage a module or leave a vehicle immobile.

- Use a bench ECU first.
- Use a charger and watch battery voltage.
- Never flash over a link that fails pre-flight checks

---

## Repository layout

```
src/
  common/      J2534 types, wire protocol, registry discovery
  agent/       XnetikBridgeAgent.exe (32-bit vendor host + status)
  proxy/       XnetikBridgeJ2534.dll (32-bit J2534 proxy)
  probe/       XnetikBridgeProbe.exe
tests/         fakej2534.dll + loopback client
console/       XnetikBridgeConsole.exe (Qt 6, 64-bit)
docs/          architecture, protocol, diagnostics, package, test plan, security
```

---

## Documentation

| Page | Contents |
|---|---|
| [BUILD.md](BUILD.md) | Build and loopback test |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Components, modes, topologies, latency, bitness |
| [docs/PROTOCOL.md](docs/PROTOCOL.md) | Wire protocol draft |
| [docs/DIAGNOSTICS.md](docs/DIAGNOSTICS.md) | Metrics, IP/WireGuard troubleshooting, support bundle |
| [docs/PACKAGE.md](docs/PACKAGE.md) | Remote package/install plan |
| [docs/TEST-PLAN.md](docs/TEST-PLAN.md) | Test matrix, fault injection, safety |
| [docs/SECURITY.md](docs/SECURITY.md) | Threat model and controls |
| [docs/GLOSSARY.md](docs/GLOSSARY.md) | J2534/networking terms |
| [ROADMAP.md](ROADMAP.md) | Done and next |

---

## Legal

- No vendor J2534 DLLs, VCI drivers, OEM software, or firmware files are included.
- J2534 is an SAE standard. This project is not affiliated with SAE, any vehicle manufacturer, or
  any VCI vendor.
- **License:** all rights reserved until a final license is chosen. See [LICENSE](LICENSE).
