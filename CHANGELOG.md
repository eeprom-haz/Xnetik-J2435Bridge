# Changelog

## 0.1.0-mvp — 2026-11-04

### Added

- 32-bit `XnetikBridgeAgent.exe` — loads a vendor J2534 DLL, TCP session, read pump, 1 Hz
  `READ_VBATT`, HTTP status.
- 32-bit `XnetikBridgeJ2534.dll` — J2534-1 proxy, local RX queue, filters, programming voltage,
  periodic messages, version/error.
- Registry auto-discovery from native and WOW6432Node J2534 views.
- Optional shared-token handshake.
- Proxy configuration via `xnetik.ini` / `%ProgramData%\Xnetik\agent.ini`.
- `GET /status` JSON endpoint (read-only, default port 7536).
- Qt 6 `XnetikBridgeConsole.exe` — RTT/jitter/loss, Vbatt/age, VCI/channel state, RX/TX, errors,
  sparklines.
- `XnetikBridgeProbe.exe` — device list, DLL probe, version/voltage.
- `fakej2534.dll` + `xn_test_proxy.exe` loopback harness.
- Documentation: architecture, protocol, diagnostics, package, test plan, security, glossary,
  roadmap.

### Verified

- Loopback: open, connect CAN 500k, write, read echo, `READ_VBATT`, version, filter, programming
  voltage, periodic, close.
- Token handshake and config-file auth.
- Autel V200: device opens and reports version. `READ_VBATT` unavailable on the bench (no vehicle
  power); retest on the car.

### Known limitations

- No real-vehicle flashing validation yet.
- No Windows service/installer yet.
- No VIN/ECU identity yet.
- 32-bit first; 64-bit only for exceptions.
- OEM application compatibility is not guaranteed; running the OEM software at the car is the
  fallback.
