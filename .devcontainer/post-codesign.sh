APP="/Applications/Scribus.app"

sudo xattr -cr "$APP"

# Re-sign inner binaries/libs first (more reliable than only --deep)
find "$APP/Contents" -type f \( -name "*.dylib" -o -name "*.so" -o -perm -111 \) -print0 \
| xargs -0 -I{} codesign --force --sign - --timestamp=none "{}"

# Sign the app bundle itself
codesign --force --deep --sign - --timestamp=none "$APP"

# Verify
codesign --verify --deep --strict --verbose=2 "$APP"
spctl --assess --type execute -vv "$APP"