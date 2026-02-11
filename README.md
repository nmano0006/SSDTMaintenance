
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

**[Donate via PayPal](https://www.paypal.com/donate/?business=H3PV9HX92AVMJ&no_recurring=0&item_name=Support+SYSM+development.+Donations+fund+testing+devices+%26+server+costs+for+this+open-source+tool.&currency_code=CAD)**

### **Why Support?**
- 📱 Funds continued development and feature updates
- 🧪 Helps acquire testing devices for compatibility
- 🌐 Covers server costs for update distribution
- 💡 Supports free, open-source software development
- 🔧 Enables faster bug fixes and improvements

### **Support Tiers:**

- 💻 **$15** - Developer supporter (helps fund new features)
- 🚀 **$30** - Premium supporter (supports device testing)
- 🏆 **$50+** - Gold supporter (major feature sponsorship)

*Every donation helps keep SYSM updated and improves the tool for the entire Hackintosh community!*
## 📸 Screenshots

| Interface | Description |
|-----------|------------|
| ![Main Interface](https://raw.githubusercontent.com/nmano0006/SSDTMaintenance/main/screenshots/1.png) | SSDTMaintenance main window |
| ![Generator Panel](https://raw.githubusercontent.com/nmano0006/SSDTMaintenance/main/screenshots/2.png) | SSDT generator options |
| ![LAN & Wi-Fi](https://raw.githubusercontent.com/nmano0006/SSDTMaintenance/main/screenshots/3.png) | LAN and Wi-Fi configuration |
| ![SATA & NVMe](https://raw.githubusercontent.com/nmano0006/SSDTMaintenance/main/screenshots/4.png) | Storage device settings |
| ![Thunderbolt](https://raw.githubusercontent.com/nmano0006/SSDTMaintenance/main/screenshots/5.png) | Thunderbolt controller setup |
| ![XHCI & USB](https://raw.githubusercontent.com/nmano0006/SSDTMaintenance/main/screenshots/6.png) | USB port configuration |
| ![Graphics](https://raw.githubusercontent.com/nmano0006/SSDTMaintenance/main/screenshots/7.png) | GPU settings (iGPU/dGPU) |
