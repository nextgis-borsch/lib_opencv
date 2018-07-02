################################################################################
# Project:  opencv
# Purpose:  CMake build scripts
# Author:   Dmitry Baryshnikov, dmitry.baryshnikov@nextgis.com
################################################################################
# Copyright (C) 2018, NextGIS <info@nextgis.com>
# Copyright (C) 2018 Dmitry Baryshnikov
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
################################################################################

cmake_minimum_required (VERSION 2.8.12 FATAL_ERROR)

project(OpenCV CXX C)

if(NOT DEFINED PACKAGE_VENDOR)
    set(PACKAGE_VENDOR NextGIS)
endif()

if(NOT DEFINED PACKAGE_BUGREPORT)
    set(PACKAGE_BUGREPORT info@nextgis.com)
endif()

# some init settings
set(CMAKE_COLOR_MAKEFILE ON)
# set path to additional CMake modules
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

set(PACKAGE_NAME "opencv")
set(PACKAGE_STRING "${PACKAGE_NAME} ${VERSION}")
set(PACKAGE_TARNAME ${PROJECT_NANE})
set(MIN_VER_CUDA 6.5)
set(MIN_VER_PYTHON2 2.6)
set(MIN_VER_PYTHON3 3.2)

# if(OSX_FRAMEWORK AND (BUILD_SHARED_LIBS OR BUILD_STATIC_LIBS))
#   message(FATAL_ERROR "Only OSX_FRAMEWORK key or any or both BUILD_SHARED_LIBS
#                        and BUILD_STATIC_LIBS keys are permitted")
# endif()

if(OSX_FRAMEWORK)
    set(BUILD_SHARED_LIBS ON CACHE INTERNAL "")
    set(INSTALL_BIN_DIR "bin" CACHE INTERNAL "Installation directory for executables" FORCE)
    set(INSTALL_LIB_DIR "Library/Frameworks" CACHE INTERNAL "Installation directory for libraries" FORCE)
    set(INSTALL_INC_DIR "${INSTALL_LIB_DIR}/${PACKAGE_NAME}.framework/Headers" CACHE INTERNAL "Installation directory for headers" FORCE)
    set(INSTALL_CMAKECONF_DIR ${INSTALL_LIB_DIR}/${PACKAGE_NAME}.framework/Resources/CMake CACHE INTERNAL "Installation directory for cmake config files" FORCE)

    set(SKIP_INSTALL_HEADERS ON)
    set(SKIP_INSTALL_EXECUTABLES OFF)
    set(SKIP_INSTALL_FILES ON)
    set(SKIP_INSTALL_EXPORT ON)

    set(CMAKE_MACOSX_RPATH ON)
else()
    include(GNUInstallDirs)

    set(INSTALL_BIN_DIR ${CMAKE_INSTALL_BINDIR} CACHE INTERNAL "Installation directory for executables" FORCE)
    set(INSTALL_LIB_DIR ${CMAKE_INSTALL_LIBDIR} CACHE INTERNAL "Installation directory for libraries" FORCE)
    set(INSTALL_INC_DIR ${CMAKE_INSTALL_INCLUDEDIR} CACHE INTERNAL "Installation directory for headers" FORCE)
    set(INSTALL_SHARE_DIR ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME} CACHE INTERNAL "Installation directory for share data" FORCE)
    set(INSTALL_CMAKECONF_DIR ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}/CMake CACHE INTERNAL "Installation directory for cmake config files" FORCE)
endif()

set(OPENCV_INCLUDE_INSTALL_PATH ${INSTALL_INC_DIR})
set(OPENCV_LIB_INSTALL_PATH ${INSTALL_LIB_DIR})
set(OPENCV_BIN_INSTALL_PATH ${INSTALL_BIN_DIR})
set(OPENCV_LIB_ARCHIVE_INSTALL_PATH ${OPENCV_LIB_INSTALL_PATH})
set(OPENCV_3P_LIB_INSTALL_PATH ${OPENCV_LIB_INSTALL_PATH})
set(BUILD_opencv_world ON CACHE INTERNAL "")

# setup package meta-data
include(util)

check_version(OPENCV_VERSION_MAJOR OPENCV_VERSION_MINOR OPENCV_VERSION_PATCH OPENCV_VERSION_STATUS)
set(VERSION ${OPENCV_VERSION_MAJOR}.${OPENCV_VERSION_MINOR}.${OPENCV_VERSION_PATCH})

report_version(${PROJECT_NAME} ${VERSION})

set(OPENCV_VERSION_PLAIN "${OPENCV_VERSION_MAJOR}.${OPENCV_VERSION_MINOR}.${OPENCV_VERSION_PATCH}")
set(OPENCV_VERSION "${OPENCV_VERSION_PLAIN}${OPENCV_VERSION_STATUS}")
set(OPENCV_SOVERSION "${OPENCV_VERSION_MAJOR}.${OPENCV_VERSION_MINOR}")
set(OPENCV_LIBVERSION "${OPENCV_VERSION_MAJOR}.${OPENCV_VERSION_MINOR}.${OPENCV_VERSION_PATCH}")

ocv_update(OPENCV_VS_VER_FILEVERSION_QUAD "${OPENCV_VERSION_MAJOR},${OPENCV_VERSION_MINOR},${OPENCV_VERSION_PATCH},0")
ocv_update(OPENCV_VS_VER_PRODUCTVERSION_QUAD "${OPENCV_VERSION_MAJOR},${OPENCV_VERSION_MINOR},${OPENCV_VERSION_PATCH},0")
ocv_update(OPENCV_VS_VER_FILEVERSION_STR "${OPENCV_VERSION}")
ocv_update(OPENCV_VS_VER_PRODUCTVERSION_STR "${OPENCV_VERSION}")
ocv_update(OPENCV_VS_VER_PRODUCTNAME_STR "OpenCV library")
ocv_update(OPENCV_VS_VER_COMMENTS_STR "http://opencv.org/")

if(OSX_FRAMEWORK)
    set(FRAMEWORK_VERSION "${OPENCV_VERSION_MAJOR}")
    set(OPENCV_INCLUDE_INSTALL_PATH ${INSTALL_LIB_DIR}/${PACKAGE_NAME}.framework/Versions/${FRAMEWORK_VERSION}/Headers)
    set(INSTALL_SHARE_DIR ${INSTALL_LIB_DIR}/${PACKAGE_NAME}.framework/Versions/${FRAMEWORK_VERSION}/Resources CACHE INTERNAL "Directory for data" FORCE)
endif()

if(WIN32)
  # Postfix of DLLs:
  set(OPENCV_DLLVERSION "${OPENCV_VERSION_MAJOR}")
  set(OPENCV_DEBUG_POSTFIX d)
else()
  # Postfix of so's:
  set(OPENCV_DLLVERSION "")
  set(OPENCV_DEBUG_POSTFIX "")
endif()

if(DEFINED CMAKE_DEBUG_POSTFIX)
  set(OPENCV_DEBUG_POSTFIX "${CMAKE_DEBUG_POSTFIX}")
endif()

if(POLICY CMP0026)
  cmake_policy(SET CMP0026 NEW)
endif()

if(POLICY CMP0042)
  cmake_policy(SET CMP0042 NEW)
endif()

if(POLICY CMP0046)
  cmake_policy(SET CMP0046 NEW)
endif()

if(POLICY CMP0051)
  cmake_policy(SET CMP0051 NEW)
endif()

if(POLICY CMP0056)
  cmake_policy(SET CMP0056 NEW)
endif()

if(POLICY CMP0067)
  cmake_policy(SET CMP0067 NEW)
endif()

option(ENABLE_PIC "Generate position independent code (necessary for shared libraries)" TRUE)
set(CMAKE_POSITION_INDEPENDENT_CODE ${ENABLE_PIC})

set(OPENCV_TEST_DATA_PATH ${CMAKE_CURRENT_SOURCE_DIR}/samples/data)
if (OPENCV_TEST_DATA_PATH)
  get_filename_component(OPENCV_TEST_DATA_PATH ${OPENCV_TEST_DATA_PATH} ABSOLUTE)
endif()

ocv_cmake_reset_hooks()
ocv_check_environment_variables(OPENCV_CMAKE_HOOKS_DIR)
if(DEFINED OPENCV_CMAKE_HOOKS_DIR)
  foreach(__dir ${OPENCV_CMAKE_HOOKS_DIR})
    get_filename_component(__dir "${__dir}" ABSOLUTE)
    ocv_cmake_hook_register_dir(${__dir})
  endforeach()
endif()

ocv_cmake_hook(CMAKE_INIT)

enable_testing()

ocv_cmake_eval(DEBUG_PRE ONCE)

ocv_clear_vars(OpenCVModules_TARGETS)

set(BUILD_LIST "" CACHE STRING "Build only listed modules (comma-separated, e.g. 'videoio,dnn,ts')")


# ----------------------------------------------------------------------------
# Break in case of popular CMake configuration mistakes
# ----------------------------------------------------------------------------
if(NOT CMAKE_SIZEOF_VOID_P GREATER 0)
  message(FATAL_ERROR "CMake fails to determine the bitness of the target platform.
  Please check your CMake and compiler installation. If you are cross-compiling then ensure that your CMake toolchain file correctly sets the compiler details.")
endif()

# ----------------------------------------------------------------------------
# Detect compiler and target platform architecture
# ----------------------------------------------------------------------------
OCV_OPTION(ENABLE_CXX11 "Enable C++11 compilation mode" ON)
include(cmake/OpenCVDetectCXXCompiler.cmake)
ocv_cmake_hook(POST_DETECT_COMPILER)

# ----------------------------------------------------------------------------
# OpenCV cmake options
# ----------------------------------------------------------------------------

OCV_OPTION(OPENCV_ENABLE_NONFREE "Enable non-free algorithms" OFF)

# Optional 3rd party components
# ===================================================
OCV_OPTION(WITH_1394           "Include IEEE1394 support"                    ON   IF (NOT ANDROID AND NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_AVFOUNDATION   "Use AVFoundation for Video I/O (iOS/Mac)"    ON   IF APPLE)
OCV_OPTION(WITH_CARBON         "Use Carbon for UI instead of Cocoa"          OFF  IF APPLE )
OCV_OPTION(WITH_CAROTENE       "Use NVidia carotene acceleration library for ARM platform"                   ON  IF (ARM OR AARCH64) AND NOT IOS AND NOT (CMAKE_VERSION VERSION_LESS "2.8.11"))
OCV_OPTION(WITH_CPUFEATURES    "Use cpufeatures Android library"             ON   IF ANDROID)
OCV_OPTION(WITH_VTK            "Include VTK library support (and build opencv_viz module eiher)"             ON  IF (NOT ANDROID AND NOT IOS AND NOT WINRT AND NOT CMAKE_CROSSCOMPILING) )
OCV_OPTION(WITH_CUDA           "Include NVidia Cuda Runtime support"                                         ON  IF (NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_CUFFT          "Include NVidia Cuda Fast Fourier Transform (FFT) library support"            ON  IF (NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_CUBLAS         "Include NVidia Cuda Basic Linear Algebra Subprograms (BLAS) library support" ON IF (NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_NVCUVID        "Include NVidia Video Decoding library support"                               ON IF (NOT IOS AND NOT APPLE) )
OCV_OPTION(WITH_EIGEN          "Include Eigen2/Eigen3 support"               (NOT CV_DISABLE_OPTIMIZATION)       IF (NOT WINRT AND NOT CMAKE_CROSSCOMPILING) )
OCV_OPTION(WITH_VFW            "Include Video for Windows support"           ON   IF WIN32 )
OCV_OPTION(WITH_FFMPEG         "Include FFMPEG support"                      ON   IF (NOT ANDROID AND NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_GSTREAMER      "Include Gstreamer support"                   ON   IF (NOT ANDROID AND NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_GSTREAMER_0_10 "Enable Gstreamer 0.10 support (instead of 1.x)"                              OFF )
OCV_OPTION(WITH_GTK            "Include GTK support"                         ON   IF (UNIX AND NOT APPLE AND NOT ANDROID) )
OCV_OPTION(WITH_GTK_2_X        "Use GTK version 2"                           OFF  IF (UNIX AND NOT APPLE AND NOT ANDROID) )
OCV_OPTION(WITH_IPP            "Include Intel IPP support"                   (NOT MINGW AND NOT CV_DISABLE_OPTIMIZATION)  IF (X86_64 OR X86) AND NOT WINRT AND NOT IOS )
OCV_OPTION(WITH_HALIDE         "Include Halide support"                      OFF)
OCV_OPTION(WITH_INF_ENGINE     "Include Intel Inference Engine support"      OFF)
OCV_OPTION(WITH_JASPER         "Include JPEG2K support"                      ON   IF (NOT IOS) )
OCV_OPTION(WITH_JPEG           "Include JPEG support"                        ON)
OCV_OPTION(WITH_WEBP           "Include WebP support"                        ON   IF (NOT WINRT) )
OCV_OPTION(WITH_OPENEXR        "Include ILM support via OpenEXR"             ON   IF (NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_OPENGL         "Include OpenGL support"                      OFF  IF (NOT ANDROID AND NOT WINRT) )
OCV_OPTION(WITH_OPENVX         "Include OpenVX support"                      OFF)
OCV_OPTION(WITH_OPENNI         "Include OpenNI support"                      OFF  IF (NOT ANDROID AND NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_OPENNI2        "Include OpenNI2 support"                     OFF  IF (NOT ANDROID AND NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_PNG            "Include PNG support"                         ON)
OCV_OPTION(WITH_GDCM           "Include DICOM support"                       OFF)
OCV_OPTION(WITH_PVAPI          "Include Prosilica GigE support"              OFF   IF (NOT ANDROID AND NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_GIGEAPI        "Include Smartek GigE support"                OFF   IF (NOT ANDROID AND NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_ARAVIS         "Include Aravis GigE support"                 OFF   IF (NOT ANDROID AND NOT IOS AND NOT WINRT AND NOT WIN32) )
OCV_OPTION(WITH_QT             "Build with Qt Backend support"               OFF  IF (NOT ANDROID AND NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_WIN32UI        "Build with Win32 UI Backend support"         ON   IF WIN32 AND NOT WINRT)
OCV_OPTION(WITH_QUICKTIME      "Use QuickTime for Video I/O"                 OFF  IF APPLE )
OCV_OPTION(WITH_QTKIT          "Use QTKit Video I/O backend"                 OFF  IF APPLE )
OCV_OPTION(WITH_TBB            "Include Intel TBB support"                   OFF  IF (NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_OPENMP         "Include OpenMP support"                      OFF)
OCV_OPTION(WITH_CSTRIPES       "Include C= support"                          OFF  IF (WIN32 AND NOT WINRT)  )
OCV_OPTION(WITH_PTHREADS_PF    "Use pthreads-based parallel_for"             ON   IF (NOT WIN32 OR MINGW) )
OCV_OPTION(WITH_TIFF           "Include TIFF support"                        ON   IF (NOT IOS) )
OCV_OPTION(WITH_UNICAP         "Include Unicap support (GPL)"                OFF  IF (UNIX AND NOT APPLE AND NOT ANDROID) )
OCV_OPTION(WITH_V4L            "Include Video 4 Linux support"               ON   IF (UNIX AND NOT ANDROID AND NOT APPLE) )
OCV_OPTION(WITH_LIBV4L         "Use libv4l for Video 4 Linux support"        OFF  IF (UNIX AND NOT ANDROID AND NOT APPLE) )
OCV_OPTION(WITH_DSHOW          "Build VideoIO with DirectShow support"       ON   IF (WIN32 AND NOT ARM AND NOT WINRT) )
OCV_OPTION(WITH_MSMF           "Build VideoIO with Media Foundation support" OFF  IF WIN32 )
OCV_OPTION(WITH_XIMEA          "Include XIMEA cameras support"               OFF  IF (NOT ANDROID AND NOT WINRT) )
OCV_OPTION(WITH_XINE           "Include Xine support (GPL)"                  OFF  IF (UNIX AND NOT APPLE AND NOT ANDROID) )
OCV_OPTION(WITH_CLP            "Include Clp support (EPL)"                   OFF)
OCV_OPTION(WITH_OPENCL         "Include OpenCL Runtime support"              (NOT ANDROID AND NOT CV_DISABLE_OPTIMIZATION)  IF (NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_OPENCL_SVM     "Include OpenCL Shared Virtual Memory support" OFF ) # experimental
OCV_OPTION(WITH_OPENCLAMDFFT   "Include AMD OpenCL FFT library support"      ON   IF (NOT ANDROID AND NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_OPENCLAMDBLAS  "Include AMD OpenCL BLAS library support"     ON   IF (NOT ANDROID AND NOT IOS AND NOT WINRT) )
OCV_OPTION(WITH_DIRECTX        "Include DirectX support"                     ON   IF (WIN32 AND NOT WINRT) )
OCV_OPTION(WITH_INTELPERC      "Include Intel Perceptual Computing support"  OFF  IF (WIN32 AND NOT WINRT) )
OCV_OPTION(WITH_MATLAB         "Include Matlab support"                      ON   IF (NOT ANDROID AND NOT IOS AND NOT WINRT))
OCV_OPTION(WITH_VA             "Include VA support"                          OFF  IF (UNIX AND NOT ANDROID) )
OCV_OPTION(WITH_VA_INTEL       "Include Intel VA-API/OpenCL support"         OFF  IF (UNIX AND NOT ANDROID) )
OCV_OPTION(WITH_MFX            "Include Intel Media SDK support"             OFF   IF ((UNIX AND NOT ANDROID) OR (WIN32 AND NOT WINRT AND NOT MINGW)) )
OCV_OPTION(WITH_GDAL           "Include GDAL Support"                        ON )
OCV_OPTION(WITH_GPHOTO2        "Include gPhoto2 library support"             ON   IF (UNIX AND NOT ANDROID AND NOT IOS) )
OCV_OPTION(WITH_LAPACK         "Include Lapack library support"              (NOT CV_DISABLE_OPTIMIZATION)  IF (NOT ANDROID AND NOT IOS) )
OCV_OPTION(WITH_ITT            "Include Intel ITT support"                   ON   IF (NOT OSX_FRAMEWORK) )

# OpenCV build components
# ===================================================
OCV_OPTION(BUILD_opencv_apps        "Build utility applications (used for example to train classifiers)" ON IF (NOT ANDROID))
OCV_OPTION(BUILD_opencv_js          "Build JavaScript bindings by Emscripten" OFF )
OCV_OPTION(BUILD_ANDROID_EXAMPLES   "Build examples for Android platform"         OFF )
OCV_OPTION(BUILD_DOCS               "Create build rules for OpenCV Documentation" OFF )
OCV_OPTION(BUILD_EXAMPLES           "Build all examples"                          OFF )
OCV_OPTION(BUILD_PACKAGE            "Enables 'make package_source' command"       ON )
OCV_OPTION(BUILD_PERF_TESTS         "Build performance tests"                     ON )
OCV_OPTION(BUILD_TESTS              "Build accuracy & regression tests"           ON )
OCV_OPTION(BUILD_WITH_DEBUG_INFO    "Include debug info into release binaries ('OFF' means default settings)" OFF )
OCV_OPTION(BUILD_WITH_STATIC_CRT    "Enables use of statically linked CRT for statically linked OpenCV" ON IF MSVC )
OCV_OPTION(BUILD_WITH_DYNAMIC_IPP   "Enables dynamic linking of IPP (only for standalone IPP)" OFF )
OCV_OPTION(BUILD_FAT_JAVA_LIB       "Create Java wrapper exporting all functions of OpenCV library (requires static build of OpenCV modules)" OFF )
OCV_OPTION(BUILD_ANDROID_SERVICE    "Build OpenCV Manager for Google Play" OFF IF ANDROID )
OCV_OPTION(BUILD_CUDA_STUBS         "Build CUDA modules stubs when no CUDA SDK" OFF  IF (NOT OSX_FRAMEWORK) )
OCV_OPTION(BUILD_JAVA               "Enable Java support"                       OFF )

# OpenCV build options
# ===================================================
OCV_OPTION(ENABLE_CCACHE              "Use ccache"                                               (UNIX AND NOT IOS AND (CMAKE_GENERATOR MATCHES "Makefile" OR CMAKE_GENERATOR MATCHES "Ninja")) )
OCV_OPTION(ENABLE_PRECOMPILED_HEADERS "Use precompiled headers"                                  ON IF (NOT IOS AND NOT CMAKE_CROSSCOMPILING) )
OCV_OPTION(ENABLE_SOLUTION_FOLDERS    "Solution folder in Visual Studio or in other IDEs"        (MSVC_IDE OR CMAKE_GENERATOR MATCHES Xcode) )
OCV_OPTION(ENABLE_PROFILING           "Enable profiling in the GCC compiler (Add flags: -g -pg)" OFF  IF CMAKE_COMPILER_IS_GNUCXX )
OCV_OPTION(ENABLE_COVERAGE            "Enable coverage collection with  GCov"                    OFF  IF CMAKE_COMPILER_IS_GNUCXX )
OCV_OPTION(ENABLE_OMIT_FRAME_POINTER  "Enable -fomit-frame-pointer for GCC"                      ON   IF CMAKE_COMPILER_IS_GNUCXX AND NOT (APPLE AND CMAKE_COMPILER_IS_CLANGCXX) )
OCV_OPTION(ENABLE_POWERPC             "Enable PowerPC for GCC"                                   ON   IF (CMAKE_COMPILER_IS_GNUCXX AND CMAKE_SYSTEM_PROCESSOR MATCHES powerpc.*) )
OCV_OPTION(ENABLE_VSX                 "Enable POWER8 and above VSX (64-bit little-endian)"       ON   IF (CMAKE_COMPILER_IS_GNUCXX AND PPC64LE) )
OCV_OPTION(ENABLE_FAST_MATH           "Enable -ffast-math (not recommended for GCC 4.6.x)"       OFF  IF (CMAKE_COMPILER_IS_GNUCXX AND (X86 OR X86_64)) )
OCV_OPTION(ENABLE_NEON                "Enable NEON instructions"                                 (NEON OR ANDROID_ARM_NEON OR AARCH64) IF CMAKE_COMPILER_IS_GNUCXX AND (ARM OR AARCH64 OR IOS) )
OCV_OPTION(ENABLE_VFPV3               "Enable VFPv3-D32 instructions"                            OFF  IF CMAKE_COMPILER_IS_GNUCXX AND (ARM OR AARCH64 OR IOS) )
OCV_OPTION(ENABLE_NOISY_WARNINGS      "Show all warnings even if they are too noisy"             OFF )
OCV_OPTION(OPENCV_WARNINGS_ARE_ERRORS "Treat warnings as errors"                                 OFF )
OCV_OPTION(ANDROID_EXAMPLES_WITH_LIBS "Build binaries of Android examples with native libraries" OFF  IF ANDROID )
OCV_OPTION(ENABLE_IMPL_COLLECTION     "Collect implementation data on function call"             OFF )
OCV_OPTION(ENABLE_INSTRUMENTATION     "Instrument functions to collect calls trace and performance" OFF )
OCV_OPTION(ENABLE_GNU_STL_DEBUG       "Enable GNU STL Debug mode (defines _GLIBCXX_DEBUG)"       OFF IF ((NOT CMAKE_VERSION VERSION_LESS "2.8.11") AND CMAKE_COMPILER_IS_GNUCXX) )
OCV_OPTION(ENABLE_BUILD_HARDENING     "Enable hardening of the resulting binaries (against security attacks, detects memory corruption, etc)" OFF)
OCV_OPTION(ENABLE_LTO                 "Enable Link Time Optimization" OFF IF CMAKE_COMPILER_IS_GNUCXX OR MSVC)
OCV_OPTION(ENABLE_THIN_LTO            "Enable Thin LTO" OFF IF CMAKE_COMPILER_IS_CLANGCXX)
OCV_OPTION(GENERATE_ABI_DESCRIPTOR    "Generate XML file for abi_compliance_checker tool" OFF IF UNIX)
OCV_OPTION(CV_ENABLE_INTRINSICS       "Use intrinsic-based optimized code" ON )
OCV_OPTION(CV_DISABLE_OPTIMIZATION    "Disable explicit optimized code (dispatched code/intrinsics/loop unrolling/etc)" OFF )
OCV_OPTION(CV_TRACE                   "Enable OpenCV code trace" ON)

OCV_OPTION(ENABLE_PYLINT              "Add target with Pylint checks"           OFF )

if(ENABLE_IMPL_COLLECTION)
  add_definitions(-DCV_COLLECT_IMPL_DATA)
endif()

ocv_cmake_hook(POST_OPTIONS)

# Save libs and executables in the same place
set(EXECUTABLE_OUTPUT_PATH "${CMAKE_BINARY_DIR}/bin" CACHE PATH "Output directory for applications")

set(LIBRARY_OUTPUT_PATH    "${CMAKE_BINARY_DIR}/lib")

# ----------------------------------------------------------------------------
#  Path for build/platform -specific headers
# ----------------------------------------------------------------------------
ocv_update(OPENCV_CONFIG_FILE_INCLUDE_DIR "${CMAKE_BINARY_DIR}/" CACHE PATH "Where to create the platform-dependant cvconfig.h")
ocv_include_directories(${OPENCV_CONFIG_FILE_INCLUDE_DIR})

ocv_cmake_hook(POST_CMAKE_BUILD_OPTIONS)

# --- Python Support ---
if(NOT IOS)
  include(cmake/OpenCVDetectPython.cmake)
endif()

include(cmake/OpenCVCompilerOptions.cmake)

ocv_cmake_hook(POST_COMPILER_OPTIONS)

# ----------------------------------------------------------------------------
#       CHECK FOR SYSTEM LIBRARIES, OPTIONS, ETC..
# ----------------------------------------------------------------------------
if(UNIX)
  include(CheckFunctionExists)
  include(CheckIncludeFile)
  include(CheckSymbolExists)

  if(NOT APPLE)
    CHECK_INCLUDE_FILE(pthread.h HAVE_PTHREAD)
    if(ANDROID)
      set(OPENCV_LINKER_LIBS ${OPENCV_LINKER_LIBS} dl m log)
    elseif(${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD|NetBSD|DragonFly|OpenBSD|Haiku")
      set(OPENCV_LINKER_LIBS ${OPENCV_LINKER_LIBS} m pthread)
    elseif(EMSCRIPTEN)
      # no need to link to system libs with emscripten
    else()
      set(OPENCV_LINKER_LIBS ${OPENCV_LINKER_LIBS} dl m pthread rt)
    endif()
  else()
    set(HAVE_PTHREAD 1)
  endif()

  CHECK_SYMBOL_EXISTS(posix_memalign stdlib.h HAVE_POSIX_MEMALIGN)
  CHECK_INCLUDE_FILE(malloc.h HAVE_MALLOC_H)
  if(HAVE_MALLOC_H)
    CHECK_SYMBOL_EXISTS(memalign malloc.h HAVE_MEMALIGN)
  endif()
endif()

include(cmake/OpenCVPCHSupport.cmake)
include(cmake/OpenCVModule.cmake)

# ----------------------------------------------------------------------------
#  Detect endianness of build platform
# ----------------------------------------------------------------------------

if(IOS)
  # test_big_endian needs try_compile, which doesn't work for iOS
  # http://public.kitware.com/Bug/view.php?id=12288
  set(WORDS_BIGENDIAN 0)
else()
  include(TestBigEndian)
  test_big_endian(WORDS_BIGENDIAN)
endif()


# ----------------------------------------------------------------------------
#  Detect 3rd-party libraries
# ----------------------------------------------------------------------------
include(FindAnyProject)

find_anyproject(ZLIB DEFAULT ON VERSION 1.2.3)
if(ZLIB_FOUND)
    set(HAVE_ZLIB YES)
endif()

find_anyproject(GDAL DEFAULT ${WITH_GDAL})
if(GDAL_FOUND)
    set(HAVE_GDAL YES)
endif()

find_anyproject(PNG DEFAULT ${WITH_PNG})
if(PNG_FOUND)
    set(HAVE_PNG YES)
endif()

find_anyproject(JPEG DEFAULT ${WITH_JPEG})
if(JPEG_FOUND)
    set(HAVE_JPEG YES)
endif()

find_anyproject(TIFF DEFAULT ${WITH_TIFF})
if(TIFF_FOUND)
    set(HAVE_TIFF YES)
endif()

find_anyproject(Qt5 DEFAULT ${WITH_QT} COMPONENT Core Gui Widgets Test Concurrent)
if(QT5_FOUND)
    set(HAVE_QT5 ON)
    set(HAVE_QT  ON)
if(NOT QT5_FOUND AND WITH_QT)
    # Try Qt4
    find_anyproject(Qt4 DEFAULT ON COMPONENT QtCore QtGui QtTest)
    if(QT4_FOUND)
        set(HAVE_QT  ON)
    endif()
endif()


# TODO:
# if(ANDROID AND WITH_CPUFEATURES)
#   add_subdirectory(3rdparty/cpufeatures)
#   set(HAVE_CPUFEATURES 1)
# endif()
#
# include(cmake/OpenCVFindLibsGrfmt.cmake)
# include(cmake/OpenCVFindLibsGUI.cmake)
# include(cmake/OpenCVFindLibsVideo.cmake)
# include(cmake/OpenCVFindLibsPerf.cmake)
# include(cmake/OpenCVFindLAPACK.cmake)
# include(cmake/OpenCVFindProtobuf.cmake)

# --- OpenCL ---
find_anyproject(OpenCL)

# --- Halide ---
find_anyproject(Halide)

# --- Inference Engine ---
# TODO:
# if(WITH_INF_ENGINE)
#   include(cmake/OpenCVDetectInferenceEngine.cmake)
# endif()

# --- DirectX ---
if(WITH_DIRECTX)
  include(cmake/OpenCVDetectDirectX.cmake)
endif()

# --- Matlab/Octave ---
# TODO:
# if(WITH_MATLAB)
#   include(cmake/OpenCVFindMatlab.cmake)
# endif()

# TODO:
# if(WITH_VTK)
#   include(cmake/OpenCVDetectVTK.cmake)
# endif()

find_anyproject(OpenVX)

find_anyproject(CUDA)

# ----------------------------------------------------------------------------
# OpenCV HAL
# ----------------------------------------------------------------------------
set(_hal_includes "")
macro(ocv_hal_register HAL_LIBRARIES_VAR HAL_HEADERS_VAR HAL_INCLUDE_DIRS_VAR)
  # 1. libraries
  foreach (l ${${HAL_LIBRARIES_VAR}})
    if(NOT TARGET ${l})
      get_filename_component(l "${l}" ABSOLUTE)
    endif()
    list(APPEND OPENCV_HAL_LINKER_LIBS ${l})
  endforeach()
  # 2. headers
  foreach (h ${${HAL_HEADERS_VAR}})
    set(_hal_includes "${_hal_includes}\n#include \"${h}\"")
  endforeach()
  # 3. include paths
  ocv_include_directories(${${HAL_INCLUDE_DIRS_VAR}})
endmacro()

if(NOT DEFINED OpenCV_HAL)
  set(OpenCV_HAL "OpenCV_HAL")
endif()

if(HAVE_OPENVX)
  if(NOT ";${OpenCV_HAL};" MATCHES ";openvx;")
    set(OpenCV_HAL "openvx;${OpenCV_HAL}")
  endif()
endif()

if(WITH_CAROTENE)
  ocv_debug_message(STATUS "Enable carotene acceleration")
  if(NOT ";${OpenCV_HAL};" MATCHES ";carotene;")
    set(OpenCV_HAL "carotene;${OpenCV_HAL}")
  endif()
endif()

foreach(hal ${OpenCV_HAL})
  if(hal STREQUAL "carotene")
    add_subdirectory(3rdparty/carotene/hal)
    ocv_hal_register(CAROTENE_HAL_LIBRARIES CAROTENE_HAL_HEADERS CAROTENE_HAL_INCLUDE_DIRS)
    list(APPEND OpenCV_USED_HAL "carotene (ver ${CAROTENE_HAL_VERSION})")
  elseif(hal STREQUAL "openvx")
    add_subdirectory(3rdparty/openvx)
    ocv_hal_register(OPENVX_HAL_LIBRARIES OPENVX_HAL_HEADERS OPENVX_HAL_INCLUDE_DIRS)
    list(APPEND OpenCV_USED_HAL "openvx (ver ${OPENVX_HAL_VERSION})")
  else()
    ocv_clear_vars(OpenCV_HAL_LIBRARIES OpenCV_HAL_HEADERS OpenCV_HAL_INCLUDE_DIRS)
    find_package(${hal} NO_MODULE QUIET)
    if(${hal}_FOUND)
      ocv_hal_register(OpenCV_HAL_LIBRARIES OpenCV_HAL_HEADERS OpenCV_HAL_INCLUDE_DIRS)
      list(APPEND OpenCV_USED_HAL "${hal} (ver ${${hal}_VERSION})")
    endif()
  endif()
endforeach()
configure_file("${OpenCV_SOURCE_DIR}/cmake/templates/custom_hal.hpp.in" "${CMAKE_BINARY_DIR}/custom_hal.hpp" @ONLY)
unset(_hal_includes)


# ----------------------------------------------------------------------------
# Add CUDA libraries (needed for apps/tools, samples)
# ----------------------------------------------------------------------------
if(HAVE_CUDA)
  set(OPENCV_LINKER_LIBS ${OPENCV_LINKER_LIBS} ${CUDA_LIBRARIES} ${CUDA_npp_LIBRARY})
  if(HAVE_CUBLAS)
    set(OPENCV_LINKER_LIBS ${OPENCV_LINKER_LIBS} ${CUDA_cublas_LIBRARY})
  endif()
  if(HAVE_CUFFT)
    set(OPENCV_LINKER_LIBS ${OPENCV_LINKER_LIBS} ${CUDA_cufft_LIBRARY})
  endif()
  foreach(p ${CUDA_LIBS_PATH})
    if(MSVC AND CMAKE_GENERATOR MATCHES "Ninja|JOM")
      set(OPENCV_LINKER_LIBS ${OPENCV_LINKER_LIBS} ${CMAKE_LIBRARY_PATH_FLAG}"${p}")
    else()
      set(OPENCV_LINKER_LIBS ${OPENCV_LINKER_LIBS} ${CMAKE_LIBRARY_PATH_FLAG}${p})
    endif()
  endforeach()
endif()


# ----------------------------------------------------------------------------
# Code trace support
# ----------------------------------------------------------------------------
# TODO:
# if(CV_TRACE)
#   include(cmake/OpenCVDetectTrace.cmake)
# endif()

ocv_cmake_hook(POST_DETECT_DEPENDECIES)

# ----------------------------------------------------------------------------
# Solution folders:
# ----------------------------------------------------------------------------
if(ENABLE_SOLUTION_FOLDERS)
  set_property(GLOBAL PROPERTY USE_FOLDERS ON)
  set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER "CMakeTargets")
endif()

# Extra OpenCV targets: uninstall, package_source, perf, etc.
include(cmake/OpenCVExtraTargets.cmake)

# ----------------------------------------------------------------------------
# Process subdirectories
# ----------------------------------------------------------------------------
string(TOUPPER ${PACKAGE_NAME} PACKAGE_UPPER_NAME)

# opencv.hpp and legacy headers
add_subdirectory(include)

# Enable compiler options for OpenCV modules/apps/samples only (ignore 3rdparty)
ocv_add_modules_compiler_options()

# OpenCV modules
add_subdirectory(modules)

# various data that is used by cv libraries and/or demo applications.
add_subdirectory(data)

# extra applications
if(BUILD_opencv_apps)
  add_subdirectory(apps)
endif()

# ----------------------------------------------------------------------------
# Finalization: generate configuration-based files
# ----------------------------------------------------------------------------

ocv_cmake_hook(PRE_FINALIZE)

# Generate platform-dependent and configuration-dependent headers
include(cmake/OpenCVGenHeaders.cmake)

if(NOT OPENCV_LICENSE_FILE)
  set(OPENCV_LICENSE_FILE ${CMAKE_CURRENT_SOURCE_DIR}/LICENSE)
endif()

# for UNIX it does not make sense as LICENSE and readme will be part of the package automatically
install(FILES ${OPENCV_LICENSE_FILE}
    PERMISSIONS OWNER_READ GROUP_READ WORLD_READ
    DESTINATION ${INSTALL_SHARE_DIR} COMPONENT libs)

# ----------------------------------------------------------------------------
# Summary:
# ----------------------------------------------------------------------------
if(NOT SUPPRESS_VERBOSE_OUTPUT)
    include(summary)
endif()

ocv_cmake_hook(POST_FINALIZE)

# Export package ===============================================================
set(LIB_NAME opencv_world)
# Add path to includes to build-tree export
target_include_directories(${LIB_NAME} INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)

# Add all targets to the build-tree export set
export(TARGETS ${LIB_NAME}
    FILE ${PROJECT_BINARY_DIR}/${PACKAGE_UPPER_NAME}Targets.cmake)

if(REGISTER_PACKAGE)
    # Export the package for use from the build-tree
    # (this registers the build-tree with a global CMake-registry)
    export(PACKAGE ${PACKAGE_UPPER_NAME})
endif()

# Create the <Package>Config.cmake file
configure_file(cmake/PackageConfig.cmake.in
    ${PROJECT_BINARY_DIR}/${PACKAGE_UPPER_NAME}Config.cmake @ONLY)

# ----------------------------------------------------------------------------
# CPack stuff
# ----------------------------------------------------------------------------

set(CPACK_PACKAGE_NAME "${PACKAGE_NAME}")
set(CPACK_PACKAGE_VENDOR "${PACKAGE_VENDOR}")
set(CPACK_PACKAGE_VERSION "${VERSION}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PACKAGE_NAME} Installation")
set(CPACK_PACKAGE_RELOCATABLE TRUE)
set(CPACK_ARCHIVE_COMPONENT_INSTALL ON)
set(CPACK_GENERATOR "ZIP")
set(CPACK_MONOLITHIC_INSTALL ON)
set(CPACK_STRIP_FILES TRUE)

# Get cpack zip archive name
get_cpack_filename(${VERSION} PROJECT_CPACK_FILENAME)
set(CPACK_PACKAGE_FILE_NAME ${PROJECT_CPACK_FILENAME})

include(CPack)

# This should be the last command
ocv_cmake_dump_vars("" TOFILE "CMakeVars.txt")
ocv_cmake_eval(DEBUG_POST ONCE)
