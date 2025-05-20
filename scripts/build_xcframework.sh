#!/bin/bash

# Script to create XCFramework for FMPFeedbackForm for macOS
# This builds the framework from the Package.swift file and includes resources

set -Eeo pipefail # Exit immediately if a command exits with a non-zero status

# Define paths and names
PROJECT_DIR="$(dirname "$(dirname "$0")")" # Go one level up from scripts folder
FRAMEWORK_NAME="FMPFeedbackForm"
BUILD_DIR="${PROJECT_DIR}/build"
ARCHIVES_DIR="${BUILD_DIR}/archives"
XCFRAMEWORK_DIR="${BUILD_DIR}/xcframework"
MACOS_ARCHIVE_PATH="${ARCHIVES_DIR}/macos.xcarchive"
DERIVED_DATA_PATH="${BUILD_DIR}/DerivedData"

echo "🚀 Building XCFramework for ${FRAMEWORK_NAME}"
echo "Project directory: ${PROJECT_DIR}"

# Clean previous build artifacts
echo "🧹 Cleaning previous build artifacts"
rm -rf "${BUILD_DIR}"

# Create necessary directories
mkdir -p "${BUILD_DIR}"
mkdir -p "${ARCHIVES_DIR}"
mkdir -p "${XCFRAMEWORK_DIR}"
mkdir -p "${DERIVED_DATA_PATH}"

# Build for macOS
echo "🔨 Building ${FRAMEWORK_NAME} for macOS..."
xcodebuild archive \
    -scheme "${FRAMEWORK_NAME}" \
    -destination "platform=macOS" \
    -archivePath "${MACOS_ARCHIVE_PATH}" \
    -derivedDataPath "${DERIVED_DATA_PATH}" \
    -project "${PROJECT_DIR}/${FRAMEWORK_NAME}.xcodeproj" | \
    xcbeautify

# Create XCFramework
echo "📦 Creating XCFramework..."
xcodebuild -create-xcframework \
    -framework "${MACOS_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
    -output "${XCFRAMEWORK_DIR}/${FRAMEWORK_NAME}.xcframework"

echo "✅ XCFramework successfully created at: ${XCFRAMEWORK_DIR}/${FRAMEWORK_NAME}.xcframework"
echo "Total size: $(du -sh "${XCFRAMEWORK_DIR}/${FRAMEWORK_NAME}.xcframework" | cut -f1)"

# Optionally create a zip file for distribution
ZIP_PATH="${BUILD_DIR}/${FRAMEWORK_NAME}.xcframework.zip"
echo "📎 Creating zip archive at: ${ZIP_PATH}"
ditto -c -k --sequesterRsrc --keepParent --sequesterRsrc \
    "${XCFRAMEWORK_DIR}/${FRAMEWORK_NAME}.xcframework" "${ZIP_PATH}"

echo "🎉 All done!"
