#!/bin/bash

# Script to create XCFrameworks for FMPFeedbackForm for macOS
# This builds the framework from the Package.swift file and includes resources
#
# Produces two release assets:
#   FMPFeedbackForm.xcframework.zip        — universal (arm64 + x86_64), for apps that still run on Intel Macs
#   FMPFeedbackForm-arm64.xcframework.zip  — Apple silicon only, for apps that dropped Intel support.
#     Xcode embeds a dynamic xcframework slice as-is, so an arm64-only app would otherwise ship
#     an x86_64 slice it can never load.

set -Eeo pipefail # Exit immediately if a command exits with a non-zero status

# Define paths and names
PROJECT_DIR="$(dirname "$(dirname "$0")")" # Go one level up from scripts folder
FRAMEWORK_NAME="FMPFeedbackForm"
BUILD_DIR="${PROJECT_DIR}/build"

echo "🚀 Building XCFrameworks for ${FRAMEWORK_NAME}"
echo "Project directory: ${PROJECT_DIR}"

# Clean previous build artifacts
echo "🧹 Cleaning previous build artifacts"
rm -rf "${BUILD_DIR}"

# Usage: build_xcframework <variant> <archs> <zip name>
build_xcframework() {
    local variant="$1"
    local archs="$2"
    local zip_name="$3"

    local archives_dir="${BUILD_DIR}/${variant}/archives"
    local xcframework_dir="${BUILD_DIR}/${variant}/xcframework"
    local archive_path="${archives_dir}/macos.xcarchive"
    local derived_data_path="${BUILD_DIR}/${variant}/DerivedData"

    mkdir -p "${archives_dir}" "${xcframework_dir}" "${derived_data_path}"

    echo "🔨 Building ${FRAMEWORK_NAME} for macOS (${archs})..."
    xcodebuild archive \
        -scheme "${FRAMEWORK_NAME}" \
        -destination "generic/platform=macOS" \
        -archivePath "${archive_path}" \
        -derivedDataPath "${derived_data_path}" \
        -project "${PROJECT_DIR}/${FRAMEWORK_NAME}.xcodeproj" \
        ARCHS="${archs}" \
        ONLY_ACTIVE_ARCH=NO | \
        xcbeautify

    local framework_path dsyms_path
    framework_path="$(readlink -f "${archive_path}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework")"
    dsyms_path="$(readlink -f "${archive_path}/dSYMs/${FRAMEWORK_NAME}.framework.dSYM")"

    echo "Slices: $(lipo -archs "${framework_path}/${FRAMEWORK_NAME}")"

    echo "📦 Creating XCFramework..."
    xcodebuild -create-xcframework \
        -framework "${framework_path}" \
        -debug-symbols "${dsyms_path}" \
        -output "${xcframework_dir}/${FRAMEWORK_NAME}.xcframework"

    echo "✅ XCFramework successfully created at: ${xcframework_dir}/${FRAMEWORK_NAME}.xcframework"
    echo "xcframework size: $(du -sh "${xcframework_dir}/${FRAMEWORK_NAME}.xcframework" | cut -f1)"

    local zip_path="${BUILD_DIR}/${zip_name}"
    echo "📎 Creating zip archive at: ${zip_path}"
    ditto -c -k --sequesterRsrc --keepParent \
        "${xcframework_dir}/${FRAMEWORK_NAME}.xcframework" "${zip_path}"

    echo "zip size: $(du -sh "${zip_path}" | cut -f1)"
    echo "SwiftPM checksum: $(swift package compute-checksum "${zip_path}")"
}

build_xcframework "universal" "arm64 x86_64" "${FRAMEWORK_NAME}.xcframework.zip"
build_xcframework "arm64" "arm64" "${FRAMEWORK_NAME}-arm64.xcframework.zip"

echo "🎉 All done! Upload both zips from ${BUILD_DIR} to the GitHub release."
