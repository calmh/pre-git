#!/bin/sh
install_name_tool -id '@executable_path/../Frameworks/Nym.Foundation.framework/Nym.Foundation' $TARGET_BUILD_DIR/XDownloader.app/Contents/Frameworks/Nym.Foundation.framework/Nym.Foundation

install_name_tool -change '/Library/Frameworks/Nym.Foundation.framework/Versions/A/Nym.Foundation' '@executable_path/../Frameworks/Nym.Foundation.framework/Versions/A/Nym.Foundation' $TARGET_BUILD_DIR/XDownloader.app/Contents/MacOS/XDownloader
