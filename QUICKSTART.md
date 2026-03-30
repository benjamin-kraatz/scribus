# Scribus Project Quickstart Guide

**Scribus 1.7.3.svn** - Open Source Desktop Publishing Application

> Complex text layout features: RTL languages (Arabic, Persian, Urdu, Hebrew), bi-directional text, Indic scripts, 500+ language support, OpenType font features, and more.

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Dev Container Setup (Recommended)](#dev-container-setup-recommended)
3. [Directory Structure](#directory-structure)
4. [Component Locations](#component-locations)
5. [Build Prerequisites](#build-prerequisites)
6. [Build Instructions](#build-instructions)
7. [Running Scribus](#running-scribus)
8. [Resources & Support](#resources--support)

---

## 🎯 Project Overview

Scribus is a sophisticated, feature-rich desktop publishing application written in C++ with a Qt5/Qt6 UI. It provides professional-grade tools for creating layouts, managing complex text, precise color management, and extensive import/export capabilities.

**Key Features:**
- Advanced text layout engine (with RTL, bi-directional, and complex script support)
- Comprehensive page layout and design tools
- ICC color profile-based color management
- 30+ import filters (AI, PDF, SVG, XPS, CDR, Pages, Visio, ODF, IDML, and more)
- PDF, SVG, and XPS export
- Powerful plugin architecture for extensibility
- Python scripting API
- CUPS-based printing system

---

## � Dev Container Setup (Recommended)

### Why Use a Dev Container?

A development container is the **recommended approach** for Scribus development because:

✅ **Isolated Environment** – Keep your host machine clean without 20+ dependencies  
✅ **Consistency** – Same build environment for all developers  
✅ **Reproducibility** – No "works on my machine" problems  
✅ **Easy Setup** – One command to fully set up the dev environment  
✅ **Quick Teardown** – Remove entire environment without affecting your system  
✅ **Multiple Configurations** – Run Qt5 and Qt6 builds simultaneously  
✅ **Integrated with VS Code** – Seamless remote development experience  

### Quick Start with Dev Container

**1. Install Requirements**

- Docker Desktop: https://www.docker.com/products/docker-desktop
- VS Code with "Dev Containers" extension (ms-vscode-remote.remote-containers)

**2. Open in Container**

```bash
# From VS Code: Press Cmd+Shift+P and select "Dev Containers: Open Folder in Container"
# Or from terminal:
cd /path/to/scribus
code .
# Then use command palette > "Dev Containers: Reopen in Container"
```

### Docker Setup

#### Option 1: Using Dockerfile (Recommended)

Create `.devcontainer/Dockerfile`:

```dockerfile
FROM ubuntu:22.04

# Set environment
ENV DEBIAN_FRONTEND=noninteractive
ENV QT_QPA_PLATFORM=offscreen

# Install build essentials
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    curl \
    pkg-config \
    # Qt5 dependencies
    qt5-qmake \
    qt5-default \
    qtbase5-dev \
    libqt5core5a \
    libqt5gui5 \
    libqt5widgets5 \
    # Scribus dependencies
    libfreetype6-dev \
    libcairo2-dev \
    libharfbuzz-dev \
    libharfbuzz-icu0 \
    libicu-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libxml2-dev \
    liblcms2-dev \
    libpoppler-cpp-dev \
    libcups2-dev \
    libfontconfig1-dev \
    ghostscript \
    # Optional but recommended
    python3-dev \
    hunspell-dev \
    libboost-dev \
    graphicsmagick++ \
    librevenge-dev \
    libcdr-dev \
    libfreehand-dev \
    libmspub-dev \
    libpagemaker-dev \
    libqxp-dev \
    libvisio-dev \
    sudo \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user for development
RUN useradd -m -s /bin/bash -G sudo developer && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER developer
WORKDIR /workspace

# Set up shell environment
RUN echo 'export PATH="/usr/lib/ccache:$PATH"' >> ~/.bashrc

CMD ["/bin/bash"]
```

Create `.devcontainer/devcontainer.json`:

```json
{
  "name": "Scribus Development",
  "build": {
    "dockerfile": "Dockerfile"
  },
  "remoteUser": "developer",
  "workspaceFolder": "/workspace",
  "mounts": [
    "source=${localEnv:HOME}/.ccache,target=/home/developer/.ccache,type=bind,consistency=cached"
  ],
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-vscode.cpptools",
        "ms-vscode.cmake-tools",
        "twxs.cmake",
        "llvm-vs-code-extensions.vscode-clangd"
      ],
      "settings": {
        "C_Cpp.default.configurationProvider": "ms-vscode.cmake-tools"
      }
    }
  },
  "postCreateCommand": "bash .devcontainer/postCreate.sh",
  "forwardPorts": [
    8080
  ]
}
```

Create `.devcontainer/postCreate.sh`:

```bash
#!/bin/bash
set -e

echo "Setting up Scribus development environment..."

# Create build directory
mkdir -p build
cd build

# Configure CMake
cmake -DCMAKE_BUILD_TYPE=Debug \
      -DWANT_CAIRO=1 \
      -DWANT_PYTHON=ON \
      -DWANT_HUNSPELL=ON \
      ..

echo "✅ Dev container ready!"
echo "Run: cd build && make -j4"
```

**2. Start Dev Container**

```bash
# From VS Code command palette: "Dev Containers: Reopen in Container"
# Or if already in container, the environment is ready to build

# First build
cd build
make -j4

# Subsequent builds (after edits)
make -j4
```

#### Option 2: Using Docker Compose

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  scribus-dev:
    build: .
    image: scribus-dev:latest
    volumes:
      - .:/workspace
      - scribus-build:/workspace/build
      - ~/.ccache:/home/developer/.ccache
    environment:
      - QT_QPA_PLATFORM=offscreen
      - DISPLAY=host.docker.internal:0  # macOS X11 forwarding (if needed)
    working_dir: /workspace
    stdin_open: true
    tty: true
    command: /bin/bash

volumes:
  scribus-build:
```

**Start with Docker Compose:**

```bash
# Build the image
docker-compose build

# Enter the container
docker-compose run --rm scribus-dev bash

# Inside container
cd build && make -j4
```

### Building in Container

**From VS Code (Recommended):**

```bash
# Terminal in VS Code (automatically in container)
cd build
make -j4 -v

# For specific target
make pixmapexport

# For parallel build on 8 cores
make -j8
```

**From Host Machine:**

```bash
# Build via docker
docker-compose run --rm scribus-dev bash -c "cd /workspace/build && make -j4"

# Or with Docker directly
docker run --rm -v $(pwd):/workspace scribus-dev:latest \
  bash -c "cd /workspace/build && make -j4"
```

### Running Scribus from Container

**With X11 Forwarding (Linux/macOS with XQuartz):**

```bash
# In container
cd build
./scribus

# Or full path
/usr/bin/scribus
```

**Headless/Server Development:**

```bash
# Build without GUI
./build/scribus --no-gui

# Run tests
cd build && ctest
```

### Advanced Container Tips

**Use ccache for Faster Rebuilds:**

The devcontainer config above includes ccache mounting. First build will be normal speed, subsequent builds after code changes will be significantly faster.

**Mount source for Live Editing:**

The container automatically mounts your source directory as `/workspace`, so edit files on your host and they appear immediately in the container.

**Multiple Qt Versions:**

Create multiple devcontainer configs:
- `.devcontainer/qt5/Dockerfile` – Qt5 build
- `.devcontainer/qt6/Dockerfile` – Qt6 build

**Debugging in Container:**

```bash
# Install gdb (optional, add to Dockerfile)
sudo apt-get install gdb

# Build with debug symbols
cmake -DCMAKE_BUILD_TYPE=Debug ..
make

# Run under debugger
gdb ./build/scribus
```

### Container Workflow Summary

```bash
# 1. One-time setup
cd /path/to/scribus
code .                    # Opens VS Code
# Command Palette: "Dev Containers: Reopen in Container"

# 2. Inside container (automatic after setup)
cd build
cmake ..
make -j4

# 3. Make code changes (use host editor)
# Changes are visible in container via mounted volume

# 4. Rebuild
make -j4

# 5. Test/run
./scribus

# 6. Done - container persists until you remove it
```

### Troubleshooting Dev Container

| Issue | Solution |
|-------|----------|
| **Build fails with "Qt not found"** | Ensure Qt5 packages are installed in Dockerfile |
| **Slow first build** | Normal (includes full Qt linking). Use ccache for future builds. |
| **"Permission denied" when running scribus** | Run with `xhost +local:` on host if using X11 forwarding |
| **Changes not visible after edit** | Verify volume mount in devcontainer.json is correct |
| **Container takes up disk space** | Run `docker system prune` to clean up unused images/volumes |

---

## �📁 Directory Structure

### Top-Level Directories

```
scribus/                          # Main application source code (~150+ files)
├── scribus/                      # Core application logic
├── plugins/                      # Import/export filters and tools
├── resources/                    # Assets (icons, fonts, profiles, templates, translations)
├── doc/                          # User documentation (7 languages: en, de, fr, it, cs, pl, ru)
├── devel-doc/                    # Doxygen developer documentation
├── cmake/                        # CMake build configuration modules
├── codegen/                      # Code generation utilities (Cheetah, RELAXNG)
├── dtd/                          # XML DTD schema files
├── OSX-package/                  # macOS app bundle configuration
├── AppImage-package/             # AppImage packaging scripts
├── win32/                        # Windows-specific build configuration
└── Scribus.app/                  # macOS app bundle (generated during build)
```

---

## 🗂️ Component Locations

### Core Application `/scribus/`

**Application Framework:**
- `scribus.cpp/h` – Main application class, entry point
- `scribuscore.cpp/h` – Core application logic
- `scribuswin.cpp/h` – Main window
- `actionmanager.cpp/h` – Command/action system
- `pluginmanager.cpp/h` – Plugin loading and management
- `prefsmanager.cpp/h` – Preferences and configuration

**Document Model:**
- `scribusdoc.cpp/h` – Document container and root object
- `scpage.cpp/h` – Page representation
- `pageitem*.cpp/h` – Page items (15+ object types):
  - TextFrame for text content
  - ImageFrame for images
  - PolyLine for paths
  - Table for tabular data
  - Multiple shape types (rectangle, circle, polygon, arc, etc.)
- `selection.cpp/h` – Selection management

**Canvas & Rendering** (`canvas*` and `scpainter*` files):
- `canvas.cpp/h` – Main document canvas
- `canvasmode_*.cpp/h` – **20+ editing modes**:
  - `canvasmode_draw*.cpp/h` – Drawing tools (bezier, calligraphic, node editing)
  - `canvasmode_create.cpp/h` – Object creation
  - `canvasmode_rotate.cpp/h` – Rotation tool
  - `canvasmode_zoom.cpp/h` – Zoom tool
  - `canvasmode_edit*.cpp/h` – Text and path editing
  - `canvasmode_*table*.cpp/h` – Table editing
- `canvasgesture_*.cpp/h` – Mouse gesture handlers (pan, resize, cell select, etc.)
- `scpainter*.cpp/h` – Graphics rendering engines (Cairo, PostScript backends)
- `scprintengine*.cpp/h` – Print system integration

**Text System** (`/scribus/text/` – ~30 files):
- `textlayout.cpp/h` – Main text layout engine
- `textshaper.cpp/h` – OpenType text shaping with HarfBuzz
- `storytext.cpp/h` – Text content storage
- `glyphcluster.cpp/h` – Character/glyph handling
- `shapedtext*.cpp/h` – Shaped text rendering pipeline
- Complex script and RTL text support

**Styling** (`/scribus/styles/` – ~8 files):
- `characterstyle.cpp/h` – Character-level text properties
- `paragraphstyle.cpp/h` – Paragraph formatting
- `linestyle.cpp/h` – Stroke properties
- `tablestyle.cpp/h`, `cellstyle.cpp/h` – Table styling

**Color Management** (`/scribus/colormgmt/` – ~30 files):
- ICC profile handling
- Color space management (RGB, CMYK, Lab, Grayscale)
- LittleCMS2 color transformation backend
- Color caching and management

**UI Components** (`/scribus/ui/` – ~250+ files):
- **Dialogs**: Print dialog, PDF export, font selection, guides, alignment, etc.
- **Property Palettes**: Multi-tab dock widgets for object/document properties
- **Rulers**: Horizontal/vertical rulers with guides
- **Toolbars**: Tool selection and quick access
- **Preferences**: Settings and configuration UI
- **Story Editor**: Text editing interface

**Undo/Redo System:**
- `undomanager.cpp/h` – Undo/redo command management

**File I/O & Utils:**
- `fileloader.cpp/h` – File loading and parsing
- `util_*.cpp/h` – Utility functions (math, file operations, GUI, colors, text)
- `iconmanager.cpp/h` – Icon and resource management

### Plugin System `/scribus/plugins/`

**Export Plugins:**
- `pixmapexport/` – Raster image export (PNG, JPEG, etc.)
- `svgexplugin/` – SVG (Scalable Vector Graphics) export
- `pdfexport/` – PDF export (advanced, with features like forms)
- `xpsexport/` – XPS (XML Paper Specification) export

**Import Plugins (25+ formats):**
- **Vector formats**: `ai/`, `eps/`, `pdf/`, `svg/`, `xps/`, `cdr/`, `vsd/`, `wmf/`, etc.
- **Document formats**: `pages/` (Apple Pages), `pub/` (Publisher), `idml/` (InDesign)
- **Drawing formats**: `cdr/` (CorelDRAW), `cdx/`, `vsd/` (Visio), `freehand/`, etc.
- **Advanced support**: librevenge, libcdr, libfreehand, libmspub, libqxp, libvisio, libzmf

**Tools & Utilities:**
- `shapes/` – Shape manipulation tools
- `barcodegenerator/` – Barcode generation
- `colorwheel/` – Color picker utility
- `fontpreview/` – Font preview tool
- `scripter/` – Python scripting interface

### Resources `/resources/`

- `iconsets/` – UI icons and graphics
- `fonts/` – Default fonts
- `profiles/` – ICC color profiles
- `templates/` – Document templates
- `translations/` – Localization files (~500+ languages)
- `dicts/` – Spell check dictionaries
- `docs/` – Additional documentation
- `swatches/` – Color swatches
- `keysets/` – Keyboard shortcut presets

### Documentation

**User Documentation** `/doc/`:
- `en/` – English documentation (most complete)
- `de/`, `fr/`, `it/`, `cs/`, `pl/`, `ru/` – Localized versions
- Built with `scridoc.py` script

**Developer Documentation** `/devel-doc/`:
- Doxygen configuration and generated docs
- Run `make` in this directory to generate HTML documentation
- Online at: http://scribus.sourceforge.net/devel-docs

---

## 🛠️ Build Prerequisites

### Minimum Requirements

| Component           | Version                                   | Purpose                |
| ------------------- | ----------------------------------------- | ---------------------- |
| **CMake**           | 3.16+                                     | Build system           |
| **Qt**              | 5.14+ (Scribus 1.5/1.6) or 6.2+ (1.7/1.8) | UI framework & widgets |
| **Freetype**        | 2.1.7+ (2.3+ recommended)                 | Font rendering         |
| **Cairo**           | 1.14+                                     | Graphics rendering     |
| **HarfBuzz**        | 1.0.5+                                    | Text shaping           |
| **HarfBuzz-subset** | 2.4.0+                                    | Subset fonts           |
| **libicu**          | Latest                                    | Unicode text handling  |
| **libjpeg**         | Latest                                    | JPEG support           |
| **libpng**          | 1.6.0+                                    | PNG support            |
| **libtiff**         | 3.6.0+                                    | TIFF support           |
| **libxml2**         | 2.6.0+                                    | XML parsing            |
| **LittleCMS**       | 2.0+ (2.1+ recommended)                   | Color management       |
| **Poppler**         | 0.62.0+                                   | PDF handling           |
| **Poppler-cpp**     | 0.62.0+                                   | PDF C++ bindings       |

> **Note**: If poppler >= 22.01.0, C++17 standard will be required.

### Recommended (Optional but Strongly Suggested)

| Component            | Purpose                                     |
| -------------------- | ------------------------------------------- |
| **CUPS**             | Printing support & CUPS development headers |
| **Fontconfig**       | 2.0+ – Font discovery                       |
| **GhostScript**      | 8.0+ (9.0+ preferred) – PostScript handling |
| **Python**           | 3.6+ – Scripting API                        |
| **Hunspell**         | Spell checking                              |
| **Boost**            | C++ libraries                               |
| **GraphicsMagick++** | Image manipulation                          |
| **pkgconfig**        | Library package discovery                   |

### Import Format Support Libraries (Optional)

For enhanced import capabilities, install:
- `podofo` (0.7.0+) – AI/EPS import
- `librevenge` – Document filters
- `libfreehand` (0.1+) – Freehand import
- `libcdr` (0.1+) – CorelDRAW import
- `libpagemaker` (0.0+) – PageMaker import
- `libmspub` (0.1+) – Microsoft Publisher import
- `libqxp` (0.0+) – QuarkXPress import
- `libvisio` (0.1+) – Visio import
- `libzmf` (0.0+) – Zoner import

---

## 🔨 Build Instructions

### macOS Build

**1. Install Xcode and MacPorts**

```bash
# Install Xcode from App Store (or download from developer.apple.com)
# Download MacPorts from www.macports.org

# Update MacPorts
sudo port selfupdate
sudo port upgrade installed
```

**2. Install Dependencies via MacPorts**

```bash
# Install all required and recommended packages
sudo port install cmake qt5 harfbuzz-icu hunspell hunspell-en_GB_ise \
    hunspell-en_US libcdr-0.1 libetonyek libfreehand libmspub libpagemaker \
    libqxp libvisio-0.1 libzmf podofo poppler boost ghostscript graphicsmagick
```

**3. Configure and Build**

```bash
# Navigate to project directory
cd ./scribus

# Create build directory
mkdir -p build
cd build

# Run CMake with macOS-specific options
cmake -DBUILD_OSX_BUNDLE=1 \
    -DWANT_CAIRO=1 \
    -DCMAKE_PREFIX_PATH=/opt/local/libexec/qt5 \
    -DCMAKE_INSTALL_PREFIX=/Applications/Scribus \
    ..

# Build (adjust -j based on your CPU cores)
make -j4

# Install
make install
```

**macOS Build Options:**
- `-DBUILD_OSX_BUNDLE=1` – Create macOS .app bundle
- `-DCMAKE_INSTALL_PREFIX=/path` – Installation destination
- `-DCMAKE_PREFIX_PATH=/opt/local/libexec/qt5` – Qt5 location from MacPorts

### Linux/BSD/Unix Build

**1. Install Dependencies**

**Fedora/RHEL:**
```bash
sudo dnf install cmake qt5-qtbase-devel freetype-devel cairo-devel \
    harfbuzz-devel libicu-devel libjpeg-turbo-devel libpng-devel \
    libtiff-devel libxml2-devel lcms2-devel poppler-cpp-devel cups-devel \
    fontconfig-devel ghostscript-devel python3-devel hunspell-devel
```

**Debian/Ubuntu:**
```bash
sudo apt-get install cmake qtbase5-dev libfreetype6-dev libcairo2-dev \
    libharfbuzz-dev libharfbuzz-icu0 libicu-dev libjpeg-dev libpng-dev \
    libtiff-dev libxml2-dev liblcms2-dev libpoppler-cpp-dev libcups2-dev \
    libfontconfig1-dev ghostscript libpython3-dev hunspell-dev
```

**2. Configure and Build**

```bash
# Navigate to project directory
cd /path/to/scribus

# Create build directory
mkdir -p build
cd build

# Configure
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..

# Build (adjust -j based on your CPU cores)
make -j4

# Install (requires sudo if installing to /usr/local)
sudo make install
```

### Common CMake Options

```bash
# Optional flags to pass to cmake command:

# Build configuration
-DCMAKE_BUILD_TYPE=Release        # Release or Debug
-DCMAKE_INSTALL_PREFIX=/usr/local # Installation path

# Platform-specific
-DBUILD_OSX_BUNDLE=1              # macOS app bundle (macOS only)
-DWANT_CAIRO=1                    # Use Cairo graphics (recommended)
-DWANT_NORPATH=1                  # Don't embed library paths (distro builds)

# Optional features
-DWANT_PYTHON=ON                  # Python scripting support
-DWANT_HUNSPELL=ON                # Spell checking
-DWANT_DISTROBUILD=1              # Build for distribution

# Non-standard library locations
-DCMAKE_INCLUDE_PATH=/custom/include
-DCMAKE_LIBRARY_PATH=/custom/lib
```

---

## ▶️ Running Scribus

### After Building

**macOS:**
```bash
# If built with -DBUILD_OSX_BUNDLE=1
open /Applications/Scribus/Scribus.app

# Or run binary directly
/Applications/Scribus/Scribus.app/Contents/MacOS/scribus
```

**Linux/Unix:**
```bash
# If installed to /usr/local
/usr/local/bin/scribus

# Or from build directory before installation
./build/scribus
```

### Command-Line Options

```bash
scribus [OPTIONS] [document.sla]

# Useful options:
scribus --help              # Show help message
scribus --version           # Show version
scribus document.sla        # Open document
scribus -g                  # Run in GUI mode (default)
scribus --no-splash         # Skip splash screen
```

### First Time Setup

When running for the first time, Scribus will:
1. Create profile directory (`~/.config/scribus/` on Linux/Unix, `~/Library/Preferences/Scribus/` on macOS)
2. Initialize preferences and color profiles
3. Display the welcome dialog or recent documents

---

## 📚 Resources & Support

### Official Resources

| Resource          | URL                           |
| ----------------- | ----------------------------- |
| **Website**       | http://www.scribus.net        |
| **Wiki**          | http://wiki.scribus.net       |
| **Forums**        | http://forums.scribus.net     |
| **Mailing Lists** | http://lists.scribus.net      |
| **Bug Tracker**   | http://bugs.scribus.net       |
| **WebSVN**        | http://scribus.net/websvn     |
| **IRC**           | irc://scribus@irc.libera.chat |

### SVN Repository

The official Scribus repository uses Subversion (not Git):

```bash
# Check out latest development version
svn co svn://scribus.net/trunk/Scribus ~/scribus-svn

# Update existing checkout
svn update

# View commit history
svn log
```

> **Note**: This GitHub repository is a manual mirror and not actively maintained by the Scribus team. For official development, use SVN.

### Developer Documentation

**Build Doxygen Documentation:**

```bash
cd ./scribus/devel-doc
make
# Browse: open html/index.html
```

**Online Developer Docs:** http://scribus.sourceforge.net/devel-docs

### Contributing

- **Bug Reports & Patches**: Submit to [Scribus Bugtracker](http://bugs.scribus.net)
- **Pull Requests**: PRs on GitHub will be directed to the bug tracker
- **Development**: Use official SVN repository for active development

---

## 🔍 Key Files for Different Tasks

### Want to modify...

| Task                          | Location                                                     |
| ----------------------------- | ------------------------------------------------------------ |
| **Main application behavior** | `scribus/scribus.cpp`, `scribus/scribuscore.cpp`             |
| **Canvas/drawing modes**      | `scribus/canvasmode_*.cpp`, `scribus/canvasgesture_*.cpp`    |
| **Text layout/rendering**     | `scribus/text/textlayout.cpp`, `scribus/text/textshaper.cpp` |
| **Page items (objects)**      | `scribus/pageitem*.cpp`                                      |
| **UI dialogs/panels**         | `scribus/ui/dialogs/`, `scribus/ui/`                         |
| **Color management**          | `scribus/colormgmt/`                                         |
| **Import/Export**             | `scribus/plugins/import/`, `scribus/plugins/export/`         |
| **Styling system**            | `scribus/styles/`                                            |
| **Preferences**               | `scribus/prefsmanager.cpp`, `scribus/ui/prefs/`              |
| **Undo/Redo**                 | `scribus/undomanager.cpp`                                    |
| **Python scripting API**      | `scribus/api/`                                               |

---

## 💡 Build Troubleshooting

### Library Not Found

If CMake can't find a library you've installed:

```bash
# Option 1: Specify library paths
cmake -DCMAKE_INCLUDE_PATH=/path/to/include \
      -DCMAKE_LIBRARY_PATH=/path/to/lib \
      ..

# Option 2: Use pkg-config
export PKG_CONFIG_PATH=/path/to/lib/pkgconfig:$PKG_CONFIG_PATH
cmake ..
```

### Rebuilding After Dependency Changes

```bash
cd build
# Try with verbose output
make VERBOSE=1

# Or completely rebuild CMake configuration
rm CMakeCache.txt
cmake ..
make -j4
```

### macOS-Specific Issues

If building on macOS with mixed package managers (MacPorts + Homebrew), ensure consistent Qt versions:

```bash
# Check Qt location
which qmake
# Should point to MacPorts or Homebrew, not both

# Use explicit cmake flag if needed
-DCMAKE_PREFIX_PATH=/opt/local/libexec/qt5
```

---

## 📝 Project Statistics & Timeline

- **Current Version**: 1.7.3.svn
- **Language**: C++ (Core), Python (Scripting API)
- **Core Files**: ~150+ in main scribus/ directory
- **Total Plugins**: 25+ import/export filters
- **UI Components**: 250+ files in ui/ directory
- **Supported Languages**: 500+
- **Active Development**: Ongoing via SVN repository

---

**Happy coding! 🚀**

For detailed building instructions, see [BUILDING](BUILDING) and [README.MacOSX](README.MacOSX).
