include(vcpkg_common_functions)

SET(INSTALL_PATH ${_VCPKG_INSTALLED_DIR}/${TARGET_TRIPLET})

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO DCMTK/dcmtk
    REF 8eda253d9b7526498c2f6badb3acc695da808b49 # DCMTK-3.6.5+_20191213
    SHA512 d0b716bb40a10872d3e4bc0e42c8ff8800038b2f11b169fd15e23a621f70433e9e70ec98879ebfcbfc01c6daf7a033f4b6b80ed7ada0357559594dce66742481
    HEAD_REF master
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/dcmtk.patch
)



vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DDCMTK_WITH_DOXYGEN=OFF
        -DDCMTK_WITH_ZLIB=ON
		-DWITH_ZLIBINC=${INSTALL_PATH}
        -DDCMTK_WITH_OPENSSL=OFF
		#-DWITH_OPENSSLINC=${INSTALL_PATH}
        -DDCMTK_WITH_PNG=ON
		-DWITH_LIBPNGINC=${INSTALL_PATH}
        -DDCMTK_WITH_TIFF=ON
		-DWITH_LIBTIFFINC=${INSTALL_PATH}
        -DDCMTK_WITH_XML=ON
		-DWITH_LIBXMLINC=${INSTALL_PATH}
        -DDCMTK_WITH_ICONV=OFF
		#-DWITH_LIBICONVINC=${INSTALL_PATH}
		-DDCMTK_WITH_OPENJPEG=ON
		-DWITH_OPENJPEGINC=${INSTALL_PATH}
        -DDCMTK_FORCE_FPIC_ON_UNIX=ON
        -DDCMTK_OVERWRITE_WIN32_COMPILER_FLAGS=OFF
        -DDCMTK_ENABLE_BUILTIN_DICTIONARY=ON
        -DDCMTK_ENABLE_PRIVATE_TAGS=ON
        -DBUILD_APPS=OFF
        -DDCMTK_ENABLE_CXX11=ON
        -DDCMTK_WIDE_CHAR_FILE_IO_FUNCTIONS=ON
        -DDCMTK_WIDE_CHAR_MAIN_FUNCTION=ON
        -DCMAKE_DEBUG_POSTFIX=d
    OPTIONS_DEBUG
        -DINSTALL_HEADERS=OFF
        -DINSTALL_OTHER=OFF
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

vcpkg_fixup_cmake_targets()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/COPYRIGHT DESTINATION ${CURRENT_PACKAGES_DIR}/share/dcmtk RENAME copyright)
