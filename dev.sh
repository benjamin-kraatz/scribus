#!/bin/bash

# Quick development helper script for Scribus
# Usage: ./dev.sh [command]

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR="${SCRIPT_DIR}/build"

case "${1:-help}" in
    build-debug)
        echo "Building Scribus in Debug mode..."
        mkdir -p "$BUILD_DIR"
        cd "$BUILD_DIR"
        cmake .. -DCMAKE_BUILD_TYPE=Debug -DWANT_CCACHE=ON
        make -j$(nproc)
        ;;
    
    build-release)
        echo "Building Scribus in Release mode..."
        mkdir -p "$BUILD_DIR"
        cd "$BUILD_DIR"
        cmake .. -DCMAKE_BUILD_TYPE=Release -DWANT_CCACHE=ON
        make -j$(nproc)
        ;;
    
    rebuild)
        echo "Rebuilding Scribus..."
        mkdir -p "$BUILD_DIR"
        cd "$BUILD_DIR"
        cmake .. -DCMAKE_BUILD_TYPE=Debug -DWANT_CCACHE=ON
        make clean
        make -j$(nproc)
        ;;
    
    clean)
        echo "Cleaning build directory..."
        rm -rf "$BUILD_DIR"
        ;;
    
    run)
        if [ ! -f "$BUILD_DIR/scribus/scribus" ]; then
            echo "Scribus not built. Building first..."
            $0 build-debug
        fi
        echo "Running Scribus..."
        "$BUILD_DIR/scribus/scribus"
        ;;
    
    install)
        echo "Installing Scribus..."
        cd "$BUILD_DIR"
        make install
        ;;
    
    cmake-configure)
        echo "Configuring CMake..."
        mkdir -p "$BUILD_DIR"
        cd "$BUILD_DIR"
        cmake .. -DCMAKE_BUILD_TYPE=Debug -DWANT_CCACHE=ON "${@:2}"
        ;;
    
    cmake-clean)
        echo "Cleaning CMake build..."
        cd "$BUILD_DIR"
        make clean
        ;;
    
    cmake-reconfigure)
        echo "Reconfiguring CMake..."
        rm -rf "$BUILD_DIR"
        mkdir -p "$BUILD_DIR"
        cd "$BUILD_DIR"
        cmake .. -DCMAKE_BUILD_TYPE=Debug -DWANT_CCACHE=ON "${@:2}"
        ;;
    
    test)
        echo "Running tests..."
        cd "$BUILD_DIR"
        ctest --verbose
        ;;
    
    format)
        echo "Formatting code with clang-format..."
        find "${SCRIPT_DIR}/scribus" -type f \( -name "*.cpp" -o -name "*.h" \) -exec clang-format -i {} \;
        echo "Code formatting complete"
        ;;
    
    static-check)
        echo "Running static analysis..."
        cppcheck --enable=all --suppress=missingIncludeSystem "${SCRIPT_DIR}/scribus"
        ;;
    
    ccache-info)
        echo "CCache statistics:"
        ccache -s
        ;;
    
    ccache-clear)
        echo "Clearing CCache..."
        ccache -C
        echo "CCache cleared"
        ;;
    
    help|*)
        cat << EOF
Scribus Development Helper

Usage: ./dev.sh [command] [options]

Build Commands:
  build-debug      Build Scribus in Debug mode (default configuration)
  build-release    Build Scribus in Release mode (optimized)
  rebuild          Clean and rebuild Scribus
  clean            Remove build directory completely
  
Run Commands:
  run              Build (if needed) and run Scribus
  
Installation:
  install          Install Scribus after building
  
CMake Commands:
  cmake-configure  Run CMake configure
  cmake-clean      Clean CMake build
  cmake-reconfigure Reconfigure CMake from scratch
  
Development Tools:
  test             Run project tests
  format           Format source code with clang-format
  static-check     Run static analysis with cppcheck
  ccache-info      Show cppcheck statistics
  ccache-clear     Clear ccache
  
Help:
  help             Show this help message

Examples:
  ./dev.sh build-debug
  ./dev.sh rebuild
  ./dev.sh run
  ./dev.sh cmake-reconfigure -DWANT_PCH=ON

EOF
        ;;
esac
