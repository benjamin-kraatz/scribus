# Scribus Development Container

This directory contains the devcontainer configuration for Scribus development. It provides a fully configured Ubuntu-based development environment with all required dependencies for building and developing Scribus.

## Quick Start

### Using VS Code

1. **Install the Remote Containers extension** (if not already installed):
   - Open Extensions in VS Code (`Cmd+Shift+X`)
   - Search for "Dev Containers" by Microsoft
   - Click Install

2. **Open the project in a container**:
   - Press `Cmd+Shift+P` and run `Dev Containers: Reopen in Container`
   - Or click the remote indicator (green button) in the bottom left corner
   - VS Code will build and launch the development container

3. **Build Scribus**:
   ```bash
   cd /workspace
   mkdir -p build
   cd build
   cmake .. -DCMAKE_BUILD_TYPE=Debug
   make -j$(nproc)
   ```

4. **Run Scribus**:
   ```bash
   ./scribus/scribus
   ```

## What's Included

### Core Tools
- CMake 3.16+
- GCC/G++ compiler
- Git, curl, wget
- pkg-config
- Ninja build system
- ccache (compiler caching)

### Development Tools
- gdb and lldb debuggers
- clang-format (code formatting)
- cppcheck (static analysis)

### Libraries (Required)
- Qt5 (GUI framework)
- Freetype (font rendering)
- Cairo (2D graphics)
- Harfbuzz (text shaping)
- libicu (Unicode support)
- libjpeg, libpng, libtiff (image formats)
- libxml2 (XML parsing)
- LittleCMS (color management)
- Poppler (PDF support)

### Libraries (Optional/Recommended)
- CUPS (printing)
- Fontconfig (font management)
- GhostScript (PostScript/PDF)
- Python 3 (scripting support)
- Hunspell (spell checking)
- Boost libraries
- GraphicsMagick++ (image processing)
- librevenge, libfreehand, libcdr, etc. (various format support)

### VS Code Extensions
- C/C++ IntelliSense and debugging
- CMake support
- Git integration (GitLens)
- GitHub Copilot
- Clang-format integration
- Makefile tools

## Common Build Workflows

### Debug Build (Faster compilation, easier debugging)
```bash
mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug
make -j$(nproc)
```

### Release Build (Optimized)
```bash
mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
```

### Build with ccache (Recommended for better cache hits)
```bash
mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug -DWANT_CCACHE=ON
make -j$(nproc)
```

### Install Scribus
```bash
cd build
make install
```

## Customization

### Modifying Dependencies
Edit `Dockerfile` to add or remove packages. After changes, rebuild the container:
- Press `Cmd+Shift+P`
- Run `Dev Containers: Rebuild Container`

### Adding VS Code Extensions
Edit the `extensions` list in `devcontainer.json` under `customizations.vscode.extensions`

### CMake Configuration
Edit the `cmake.options` in `devcontainer.json` to change default CMake options

## Build Options

Common CMake options for Scribus:

- `-DCMAKE_BUILD_TYPE=Debug|Release` - Build type
- `-DWANT_CCACHE=ON` - Enable compiler caching
- `-DCMAKE_INSTALL_PREFIX=/usr/local` - Installation prefix
- `-DWANT_PCH=ON` - Enable precompiled headers (faster for large changes)

For more options, see the main [BUILDING](../BUILDING) file in the project root.

## Troubleshooting

### Container won't build
- Ensure Docker Desktop is running
- Check your internet connection for downloading dependencies
- Try clearing the Docker cache: `docker system prune -a`

### CMake configuration fails
- Ensure all required libraries were installed (check Dockerfile)
- Check for missing development headers
- Run `cmake ..` from the build directory

### Performance issues
- Use `ccache` to cache compilation results
- Increase Docker's memory allocation in Docker Desktop settings
- Use Release builds for performance testing (`-DCMAKE_BUILD_TYPE=Release`)

### Debugging
- Use VS Code's debug launch configurations
- Set breakpoints in the editor
- Use the Debug panel to inspect variables

## Additional Resources

- [Scribus Official Documentation](http://docs.scribus.net)
- [CMake Documentation](https://cmake.org/documentation)
- [Qt5 Documentation](https://doc.qt.io/qt-5/)
- [VS Code Remote Containers Guide](https://code.visualstudio.com/docs/remote/containers)

## Mac-Specific Notes

Since you're developing on macOS using the container:
- Your workspace is mounted from your Mac into the container
- File changes made on your Mac are immediately visible in the container
- The container runs Linux inside Docker Desktop
- Build artifacts are stored in the container (use `make install` to deploy)
