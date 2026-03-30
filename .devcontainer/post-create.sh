#!/bin/bash
set -e

echo "==========================================="
echo "Scribus Development Container Setup"
echo "==========================================="

# Create build directory if it doesn't exist
if [ ! -d "/workspace/build" ]; then
    echo "Creating build directory..."
    mkdir -p /workspace/build
fi

# Print useful information
echo ""
echo "✓ Development environment initialized"
echo ""
echo "Quick start guide:"
echo "  1. Build Scribus:"
echo "     cd /workspace"
echo "     mkdir -p build && cd build"
echo "     cmake .. -DCMAKE_BUILD_TYPE=Debug"
echo "     make -j\$(nproc)"
echo ""
echo "  2. Run Scribus:"
echo "     ./scribus/scribus"
echo ""
echo "  3. CMake Build Types:"
echo "     Release:     -DCMAKE_BUILD_TYPE=Release"
echo "     Debug:       -DCMAKE_BUILD_TYPE=Debug (default)"
echo "     RelWithDbgInfo: -DCMAKE_BUILD_TYPE=RelWithDebInfo"
echo ""
echo "  4. Available tools:"
echo "     - ccache (caching compiler)"
echo "     - clang-format (code formatting)"
echo "     - cppcheck (static analysis)"
echo "     - gdb/lldb (debugging)"
echo ""
echo "  5. CMake options:"
echo "     -DWANT_CCACHE=ON     Enable ccache for faster compilation"
echo "     -DCMAKE_INSTALL_PREFIX=/usr/local  Set install location"
echo ""
echo "Environment details:"
echo "  Compiler: g++ $(g++ --version | head -1)"
echo "  CMake: $(cmake --version | head -1)"
echo "  Qt: $(qmake --version 2>/dev/null | head -1 || echo 'Qt5 installed')"
echo ""
echo "==========================================="
