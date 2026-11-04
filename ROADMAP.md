# Roadmap

## Done (32-bit MVP)

- 32-bit agent loads a vendor J2534 DLL.
- 32-bit proxy DLL exports J2534-1 calls and forwards over TCP.
- Push-based RX: agent read pump, local proxy queue; `PassThruReadMsgs` does not add a WAN round
  trip.
- `READ_VBATT` at 1 Hz, cached with age.
- Registry auto-discovery from both J2534 views.
- Filters, programming voltage, periodic messages, version/error.
- Optional shared-token handshake.
- Proxy config via `xnetik.ini` / `%ProgramData%\Xnetik\agent.ini`.
- HTTP `/status` JSON.
- Qt 6 link console: RTT/jitter/loss, Vbatt, state, device, RX/TX, sparklines.
- Loopback tests pass; real Autel V200 opens and reports version.

## Next

1. **Real-vehicle validation** — V200/VCM3 on a car; `READ_VBATT`, CAN/ISO15765, VIN.
2. **WireGuard deployment** — home-lab hub, agent bound to the tunnel IP, loopback across the
   tunnel, latency measurements.
3. **OEM app compatibility** — register the proxy in a 32-bit OEM app/VM; read, coding, bench flash.
4. **Windows service + installer** — agent as a service, signed package, RustDesk setup, updates.
5. **VIN/ECU identity** — UDS `22 F190` / OBD Mode 09 PID 02 and ECU fingerprint, only when idle.
6. **Per-call latency** — measure queue/network/vendor time, not just status-poll RTT.
7. **64-bit exceptions** — proxy/agent builds for 64-bit OEM apps or vendor DLLs.
8. **Fail-safe tests** — link loss, low voltage, VCI unplug, agent crash, recovery.

## Not planned

- Flash algorithms, seed/key, firmware files, or tuning file formats.
- Bundling vendor J2534 DLLs or OEM software.
- Public listening ports on the remote PC.
- Flashing over an unsafe link.

## Safety gate

No customer-vehicle flashing until:

- Bench ECU tests pass.
- Fault-injection and recovery tests pass.
- Voltage/link pre-flight is enforced.
- Supported app/interface combinations are documented.
