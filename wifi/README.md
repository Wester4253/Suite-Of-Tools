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

## Usage

### Quick Start (via curl)

You can run the WiFi tester directly from GitHub without cloning:

```bash
curl -fsSL https://raw.githubusercontent.com/Wester4253/Suite-Of-Tools/main/wifitester.sh | bash
```

This will prompt you to select a network interface and run comprehensive diagnostics.

### Local Usage

Clone the repository and run scripts directly:

```bash
git clone https://github.com/Wester4253/Suite-Of-Tools.git
cd Suite-Of-Tools
chmod +x wifitester.sh
./wifitester.sh
```

### Individual Components

Each component can be run or sourced independently:

- `interfaces.sh` - Network interface selection utility
- `tests.sh` - Network testing functions
- `output.sh` - Output formatting utilities

## Requirements

- Linux system
- `bash`
- `curl`
- `ping` and `ping6`
- `ip` command (from iproute2 package)

## How It Works

The scripts are designed to work even when piped through curl by redirecting stdin from `/dev/tty`, allowing interactive prompts to function correctly in piped environments.
