# Suite-Of-Tools

A suite of network diagnostic and testing tools for Linux systems.

## Tools

### Network Tester (`wifitester.sh`)

A comprehensive network diagnostics tool that works with both WiFi and Ethernet interfaces. Tests include:
- Packet loss
- Latency
- Download/upload speeds
- Gateway connectivity
- IPv4 and IPv6 connectivity
- DNS resolution

#### Usage

```bash
./wifitester.sh [-v|--verbose] [-h|--help]
```

**Options:**
- `-v, --verbose` - Enable verbose output to see detailed test information
- `-h, --help` - Show help message

**Examples:**
```bash
# Run with default output
./wifitester.sh

# Run with verbose output to see detailed test results
./wifitester.sh -v
```

## Requirements

- Linux system
- `bash`
- `curl`
- `ping` and `ping6`
- `ip` command (from iproute2 package)

## How It Works

The scripts are designed to work even when piped through curl by redirecting stdin from `/dev/tty`, allowing interactive prompts to function correctly in piped environments.
