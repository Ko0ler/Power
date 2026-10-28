# Power

Personal PowerShell module for quickly setting up a productive Windows workspace.

## Features

- Centralized workspace paths
- Quick access to study and project folders
- Application shortcuts and management
- Development environment setup
- Easy customization

## Requirements

- Windows 10/11
- PowerShell 5.1+ or PowerShell 7+

## Installation

```powershell
git clone https://github.com/Ko0ler/Power.git
Import-Module .\SetupModule.psm1
```

## Configuration

Update the paths in `SetupModule.psm1` to match your environment:

```powershell
$user = "C:\Users\YourUsername"
```

## Usage

```powershell
Import-Module .\SetupModule.psm1
```
For a smoother setup, you can use the batch script [myscript.bat](myscript.bat) to launch the module and specific functions. And for automatic loading, add it to your PowerShell profile:

```powershell
notepad $PROFILE
```

```powershell
Import-Module "C:\Path\To\SetupModule.psm1"
```
