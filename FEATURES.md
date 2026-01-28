# BlobeVM New Features Guide

## 🍷 Wine - Windows Application Support

Wine allows you to run Windows applications (.exe files) directly in the Linux desktop environment.

### Basic Usage

```bash
# Run a Windows executable
wine program.exe

# Install a Windows application
wine installer.exe

# Configure Wine settings
winecfg

# Open Wine control panel
wine control
```

### Installing Windows Applications

1. Download the .exe file to your Linux desktop
2. Right-click and select "Open with Wine Windows Program Loader"
3. Or run from terminal: `wine your-app.exe`

### Wine Configuration

```bash
# Open Wine configuration dialog
winecfg

# Common settings:
# - Windows version (Windows 7, 10, etc.)
# - Display settings
# - Audio drivers
# - Library overrides
```

### Common Wine Commands

```bash
# Open File Explorer equivalent
wine explorer

# Open Command Prompt
wine cmd

# Open Notepad
wine notepad

# Open Registry Editor
wine regedit

# View Wine version
wine --version
```

### Tips for Using Wine

- Most simple applications work well
- Complex games may require additional configuration
- Wine's C: drive is located at `~/.wine/drive_c`
- You can copy files to your Wine C: drive if needed
- Some applications may need specific Windows versions set in winecfg

---

## 🌐 Google Chrome

Google Chrome is pre-installed for web browsing.

### Opening Chrome

```bash
# From terminal
google-chrome

# From Applications menu
# Internet -> Google Chrome
```

### Chrome Flags and Options

```bash
# Open in Incognito mode
google-chrome --incognito

# Open with specific URL
google-chrome https://example.com

# Open with multiple tabs
google-chrome https://site1.com https://site2.com

# Disable GPU acceleration (if needed)
google-chrome --disable-gpu

# Open in debug mode
google-chrome --debug
```

### Chrome Profile Location

Chrome profiles are stored at:
```
/home/kasm-user/.config/google-chrome/
```

---

## 📦 Installing Linux Software

You have multiple ways to install Linux applications and packages.

### Method 1: GDebi (Recommended for .deb files)

GDebi provides an easy way to install downloaded .deb packages.

```bash
# Install a .deb package with prompts
gdebi package.deb

# Install a .deb package automatically (no prompts)
gdebi -n package.deb

# View package information
gdebi -p package.deb

# Show dependencies
gdebi -c package.deb
```

**GDebi Advantages:**
- Simple and user-friendly
- Automatically handles dependencies
- Shows package information before installation
- Easy to use from file manager

### Method 2: Synaptic Package Manager (GUI)

Synaptic provides a graphical interface for package management.

```bash
# Open Synaptic
synaptic

# Requires root/sudo privileges
sudo synaptic
```

**Using Synaptic:**
1. Search for packages using the search bar
2. Mark packages for installation
3. Click "Apply" to install selected packages
4. Dependencies are automatically resolved

**Synaptic Features:**
- Browse all available packages
- Search by name, description, or section
- Filter by status (installed, not installed, etc.)
- View package details and dependencies
- Mark multiple packages for installation at once

### Method 3: APT Command Line (Advanced)

```bash
# Update package lists
apt-get update

# Search for packages
apt-cache search package-name

# Show package information
apt-cache show package-name

# Install a package
apt-get install package-name

# Remove a package
apt-get remove package-name

# Remove package and configuration files
apt-get purge package-name

# Fix broken dependencies
apt-get install -f
```

### Method 4: dpkg (For .deb files)

```bash
# Install a .deb file
dpkg -i package.deb

# List contents of a .deb file
dpkg -c package.deb

# Get package information
dpkg -I package.deb

# Remove an installed package
dpkg -r package-name

# Remove package and config files
dpkg -P package-name
```

---

## 🎯 Common Workflows

### Installing a Windows Application

1. Download the .exe file
2. Open terminal and run:
   ```bash
   wine setup.exe
   ```
3. Follow the installation prompts
4. Run the application:
   ```bash
   wine "C:/Program Files/YourApp/app.exe"
   ```

### Installing a Linux .deb Package

1. Download the .deb file
2. Right-click and select "Open with GDebi Package Installer"
3. Click "Install Package"
4. Or from terminal:
   ```bash
   gdebi package.deb
   ```

### Finding and Installing Software

**Using Synaptic:**
1. Open Synaptic: `sudo synaptic`
2. Search for software name
3. Mark for installation
4. Click Apply

**Using APT:**
```bash
# Search for software
apt-cache search description

# Install found software
apt-get install package-name
```

---

## 📋 Troubleshooting

### Wine Issues

**Application won't start:**
```bash
# Try running from terminal to see errors
wine app.exe

# Check Wine configuration
winecfg
```

**Missing dependencies:**
```bash
# Install common Wine dependencies
apt-get install winetricks
winetricks vcrun2019 directx9
```

### Chrome Issues

**Chrome won't start:**
```bash
# Try disabling GPU acceleration
google-chrome --disable-gpu
```

**Chrome crashes:**
```bash
# Reset Chrome (careful - this clears data)
rm -rf ~/.config/google-chrome/
```

### Package Installation Issues

**Dependency errors:**
```bash
# Fix broken packages
apt-get install -f
```

**Permission denied:**
```bash
# Use sudo for package installation
sudo apt-get install package-name
sudo dpkg -i package.deb
```

---

## 🔧 Additional Resources

### Wine Resources
- [Wine Official Website](https://www.winehq.org/)
- [Wine AppDB - Application Compatibility Database](https://appdb.winehq.org/)
- [Wine Documentation](https://wiki.winehq.org/Documentation)

### Chrome Resources
- [Chrome Help Center](https://support.google.com/chrome/)
- [Chrome Flags](chrome://flags/)

### Linux Package Management
- [Ubuntu Package Management Guide](https://ubuntu.com/server/docs/package-management)
- [Debian Package Management](https://www.debian.org/doc/manuals/debian-reference/ch02.en.html)

---

## 💡 Tips

1. **Always check Wine AppDB** before installing Windows software to see compatibility
2. **Use GDebi for .deb files** - it's the simplest method
3. **Keep packages updated** with `apt-get update && apt-get upgrade`
4. **Back up important Wine prefixes** if you have complex Windows software setups
5. **Check Chrome flags** for experimental features that might improve performance
6. **Use Synaptic** to explore available packages when you're not sure what to install
