# OpeOpe Toolkit - Master Development Plan

> **Project:** OpeOpe Toolkit
>
> **Language:** PowerShell
>
> **Platform:** Windows 10 / Windows 11
>
> **Status:** Active Development

---

# 1. Project Vision

The OpeOpe Toolkit is a professional Windows Troubleshooting, Diagnostics and Maintenance Toolkit.

The objective is to create a modular, reliable and maintainable tool capable of inspecting, diagnosing and repairing Windows systems while demonstrating professional software engineering practices.

This project also serves as a portfolio project and a learning project.

---

# 2. Development Goals

The toolkit should eventually be capable of:

* Collecting detailed system information.
* Collecting network information.
* Collecting security information.
* Detecting common configuration issues.
* Performing safe maintenance tasks.
* Performing safe cleanup tasks.
* Generating professional reports.
* Providing troubleshooting recommendations.

---

# 3. Development Methodology

Every feature must follow the exact same workflow.

## Step 1

Understand what information is required.

Never write code first.

---

## Step 2

Discover available cmdlets.

Example

```powershell
Get-Command *BitLocker*
```

---

## Step 3

Study the cmdlet.

```powershell
Get-Help
```

---

## Step 4

Inspect the returned object.

```powershell
Get-Member
```

---

## Step 5

Choose only useful properties.

Avoid collecting unnecessary information.

---

## Step 6

Implement the feature.

Follow project coding standards.

---

## Step 7

Test

* Administrator
* Standard User

Whenever possible.

---

## Step 8

Refactor

Improve readability if necessary.

---

## Step 9

Commit

Every logical improvement deserves its own commit.

---

## Step 10

Push

Synchronize with GitHub.

---

# 4. Coding Standards

## Function Naming

Verb-Noun

Examples

Get-SystemInformation

Get-NetworkInformation

Get-SecurityInformation

---

## Variables

PascalCase

Example

$ComputerInformation

$NetworkAdapters

---

## Comments

Every function begins with a short description.

Every logical block must have a section comment.

Example

Collect Information

Validation

Network

Storage

Security

---

## Error Handling

Every cmdlet capable of failing must use:

try

catch

ErrorAction Stop

The toolkit must never stop because one command failed.

---

## Logging

Modules never use Write-Host.

Modules always use:

Write-Log

---

## Module Structure

Every module should follow this order.

Collect Information

↓

Validate Information

↓

Process Information

↓

Write Output

Consistency is more important than complexity.

---

# 5. Project Architecture

Core

* Logger
* Helpers
* Admin Check
* Menu

Modules

* System
* Network
* Security

Future Modules

* Storage
* Services
* Processes
* Maintenance
* Cleanup
* Reports
* Diagnostics

---

# 6. Development Roadmap

## Phase 1

Information Gathering

Goal

Inspect the computer.

Do NOT modify the system.

---

### System Information

Status

In Progress

Completed

* Operating System
* Computer Name
* CPU
* RAM

Planned

* BIOS Manufacturer
* BIOS Version
* BIOS Release Date
* Motherboard
* Manufacturer
* Model
* Serial Number
* Architecture
* Boot Mode
* GPU
* Storage Devices
* Disk Capacity
* Disk Free Space
* Disk Type

---

### Network Information

Status

In Progress

Completed

* Network Adapters
* IPv4

Planned

* IPv6
* Gateway
* DNS Servers
* DHCP
* MAC Address
* Network Profile
* Adapter Speed
* Adapter Type
* Public IP
* Gateway Test
* DNS Test
* Internet Connectivity Test

---

### Security Information

Status

In Progress

Completed

* Antivirus
* Firewall
* BitLocker
* TPM
* Secure Boot

Planned

* Microsoft Defender
* Defender Signatures
* Defender Engine
* Real-Time Protection
* Windows Update Status
* Pending Reboot
* SmartScreen
* UAC
* Credential Guard
* Device Guard
* Memory Integrity
* VBS

---

### Storage Information

Status

Planned

Features

* Physical Disks
* Logical Volumes
* SMART
* Health Status
* Capacity
* Free Space
* Disk Type

---

### Service Information

Status

Planned

Features

* Windows Update
* Defender
* Event Log
* WinRM
* Print Spooler
* Remote Registry

---

### Process Information

Status

Planned

Features

* Running Processes
* CPU Usage
* RAM Usage
* Top Processes

---

# 7. Health Check

The toolkit begins analysing collected information.

Instead of only displaying data, it provides recommendations.

Examples

Firewall Disabled

↓

Recommendation
Enable Windows Firewall.
BitLocker Disabled

↓

Recommendation
Encrypt the operating system drive.
Low Disk Space

↓

Recommendation
Free disk space.
Old Defender Signatures

↓

Recommendation
Update Defender.

---

# 8. Maintenance

The toolkit begins modifying the system.
Every operation must ask for user confirmation.

Planned

* Flush DNS
* Clear Temporary Files
* Empty Recycle Bin
* Restart Network
* Restart Explorer
* Restart Windows Update
* Restart Print Spooler
* SFC
* DISM RestoreHealth
* CheckDisk
* Defender Signature Update
* Windows Update Repair
* Reset Network Stack

---

# 9. Cleanup

Safe cleanup operations.

* Windows Temp
* User Temp
* DNS Cache
* Thumbnail Cache
* Recycle Bin
* Windows Update Cache

---

# 10. Reports

Generate reports.

TXT
HTML
JSON
Future
PDF

---

# 11. Diagnostics

Automated troubleshooting.
Examples
Internet Problems
Windows Update Problems
Firewall Problems
Security Problems
Storage Problems
The toolkit should identify issues and provide recommendations.

---

# 12. Future Improvements

* Better console formatting
* Health Score
* Configuration file
* Themes
* Export options
* Remote execution
* Inventory mode
* Plugin architecture

---

# 13. Current Project Status

## Completed

Core

* Logger
* Menu
* Admin Check

Modules

* Basic System Information
* Basic Network Information
* Security Information

  * Antivirus
  * Firewall
  * BitLocker
  * TPM
  * Secure Boot

---

## Next Priority

Complete the Information Gathering phase before implementing Maintenance.

Order

1. Finish Security module.
2. Improve System module.
3. Improve Network module.
4. Implement Storage module.
5. Implement Service module.
6. Implement Process module.

Only after the Information phase is complete should Maintenance and Cleanup begin.

---

# 14. Session Rules

At the beginning of every development session:

1. Read this PLAN.md.
2. Verify current project status.
3. Decide the next task according to the roadmap.
4. Follow the Development Methodology.
5. Never skip steps.
6. Keep commits small and meaningful.

This document is the official reference for the entire project and should always be kept up to date as the toolkit evolves.
