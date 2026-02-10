
# SSDTMaintenance – SSDT Maintenance & Generator for macOS

SSDTMaintenance is a macOS application designed to generate, manage, and maintain SSDTs for Hackintosh and advanced macOS system configurations.

The goal of SSDTMaintenance is to simplify SSDT creation for components such as:
- CPU (PLUG, power management)
- Audio (HDEF)
- GPU
- USB (XHCI / RHUB)
- Storage (NVMe / SATA)
- LAN / Wi-Fi
- Thunderbolt
- EC / USBX
- DTGP and device properties

This project focuses on **clean ACPI output**, **automation**, and **compatibility across modern Intel platforms**.

---

## ✨ Features

- Automatic SSDT generation
- Proper `DefinitionBlock` handling
- DTGP auto-injection when required
- IASL compilation to `.aml`
- Clean output folder structure
- macOS-native SwiftUI interface
- Designed for OpenCore-based systems

---

## 🛠 Requirements

- macOS 13 or newer
- Xcode 15+
- Command Line Tools installed
- `iasl` (Intel ACPI compiler)

---

## 🚀 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/nmano0006/SSDTMaintenance.git
