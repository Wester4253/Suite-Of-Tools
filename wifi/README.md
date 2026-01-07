# Suite-Of-Tools

A suite of network diagnostic and testing tools for Linux systems.

## Tools

### WiFi Tester (`wifitester.sh`)

A comprehensive network diagnostics tool that tests:
- Packet loss
- Latency
- Download/upload speeds
- Gateway connectivity
- IPv4 and IPv6 connectivity
- DNS resolution
- 
## Requirements

- Linux system
- `bash`
- `curl`
- `ping` and `ping6`
- `ip` command (from iproute2 package)

## How It Works

The scripts are designed to work even when piped through curl by redirecting stdin from `/dev/tty`, allowing interactive prompts to function correctly in piped environments.
