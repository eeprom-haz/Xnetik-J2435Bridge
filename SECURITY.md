# Security Policy

This is an early MVP. Do not use it on a customer vehicle or expose it to the public internet.

## Reporting

Report vulnerabilities privately to the project owner. Do not open a public issue with exploit
details, credentials, customer data, or vehicle identifiers.

## Scope

- The agent is intended to bind to a WireGuard tunnel IP or `127.0.0.1`.
- The `/status` endpoint is read-only and unauthenticated; bind it to the tunnel/localhost only.
- The app token is optional defense-in-depth; WireGuard is the primary network boundary.
- No vendor J2534 DLLs, VCI drivers, or OEM software are included.

See [docs/SECURITY.md](docs/SECURITY.md) for the threat model, key handling, update chain, and
remote-desktop guidance.

## Safety

Remote flashing can permanently damage a module. Link quality and battery voltage must be treated as
hard interlocks. Use a bench ECU and a dedicated test vehicle first.
