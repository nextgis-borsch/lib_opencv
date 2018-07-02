status("")
status("General configuration for OpenCV ${OPENCV_VERSION} =====================================")
if(OPENCV_VCSVERSION)
  status("  Version control:" ${OPENCV_VCSVERSION})
endif()
if(OPENCV_EXTRA_MODULES_PATH AND NOT BUILD_INFO_SKIP_EXTRA_MODULES)
  set(__dump_extra_header OFF)
  foreach(p ${OPENCV_EXTRA_MODULES_PATH})
    if(EXISTS ${p})
      if(NOT __dump_extra_header)
        set(__dump_extra_header ON)
        status("")
        status("  Extra modules:")
      else()
        status("")
      endif()
      set(EXTRA_MODULES_VCSVERSION "unknown")
      status("    Location (extra):" ${p})
      status("    Version control (extra):" ${EXTRA_MODULES_VCSVERSION})
    endif()
  endforeach()
  unset(__dump_extra_header)
endif()

# ========================== build platform ==========================
status("")
status("  Platform:")
if(NOT DEFINED OPENCV_TIMESTAMP
    AND NOT CMAKE_VERSION VERSION_LESS 2.8.11
    AND NOT BUILD_INFO_SKIP_TIMESTAMP
)
  string(TIMESTAMP OPENCV_TIMESTAMP "" UTC)
  set(OPENCV_TIMESTAMP "${OPENCV_TIMESTAMP}" CACHE STRING "Timestamp of OpenCV build configuration" FORCE)
endif()
if(OPENCV_TIMESTAMP)
  status("    Timestamp:"      ${OPENCV_TIMESTAMP})
endif()
status("    Host:"             ${CMAKE_HOST_SYSTEM_NAME} ${CMAKE_HOST_SYSTEM_VERSION} ${CMAKE_HOST_SYSTEM_PROCESSOR})
if(CMAKE_CROSSCOMPILING)
  status("    Target:"         ${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_VERSION} ${CMAKE_SYSTEM_PROCESSOR})
endif()
status("    CMake:"            ${CMAKE_VERSION})
status("    CMake generator:"  ${CMAKE_GENERATOR})
status("    CMake build tool:" ${CMAKE_BUILD_TOOL})
if(MSVC)
  status("    MSVC:"           ${MSVC_VERSION})
endif()
if(CMAKE_GENERATOR MATCHES Xcode)
  status("    Xcode:"          ${XCODE_VERSION})
endif()
if(NOT CMAKE_GENERATOR MATCHES "Xcode|Visual Studio")
  status("    Configuration:"  ${CMAKE_BUILD_TYPE})
endif()


# ========================= CPU code generation mode =========================
status("")
status("  CPU/HW features:")
status("    Baseline:"  "${CPU_BASELINE_FINAL}")
if(NOT CPU_BASELINE STREQUAL CPU_BASELINE_FINAL)
  status("      requested:"  "${CPU_BASELINE}")
endif()
if(CPU_BASELINE_REQUIRE)
  status("      required:"  "${CPU_BASELINE_REQUIRE}")
endif()
if(CPU_BASELINE_DISABLE)
  status("      disabled:"  "${CPU_BASELINE_DISABLE}")
endif()
if(CPU_DISPATCH_FINAL OR CPU_DISPATCH)
  status("    Dispatched code generation:"  "${CPU_DISPATCH_FINAL}")
  if(NOT CPU_DISPATCH STREQUAL CPU_DISPATCH_FINAL)
    status("      requested:"  "${CPU_DISPATCH}")
  endif()
  if(CPU_DISPATCH_REQUIRE)
    status("      required:"  "${CPU_DISPATCH_REQUIRE}")
  endif()
  foreach(OPT ${CPU_DISPATCH_FINAL})
    status("      ${OPT} (${CPU_${OPT}_USAGE_COUNT} files):"  "+ ${CPU_DISPATCH_${OPT}_INCLUDED}")
  endforeach()
endif()

# ========================== C/C++ options ==========================
if(CMAKE_CXX_COMPILER_VERSION)
  set(OPENCV_COMPILER_STR "${CMAKE_CXX_COMPILER} ${CMAKE_CXX_COMPILER_ARG1} (ver ${CMAKE_CXX_COMPILER_VERSION})")
else()
  set(OPENCV_COMPILER_STR "${CMAKE_CXX_COMPILER} ${CMAKE_CXX_COMPILER_ARG1}")
endif()
string(STRIP "${OPENCV_COMPILER_STR}" OPENCV_COMPILER_STR)

status("")
status("  C/C++:")
status("    Built as dynamic libs?:" BUILD_SHARED_LIBS THEN YES ELSE NO)
if(ENABLE_CXX11 OR HAVE_CXX11)
status("    C++11:" HAVE_CXX11 THEN YES ELSE NO)
endif()
status("    C++ Compiler:"           ${OPENCV_COMPILER_STR})
status("    C++ flags (Release):"    ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELEASE})
status("    C++ flags (Debug):"      ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_DEBUG})
status("    C Compiler:"             ${CMAKE_C_COMPILER} ${CMAKE_C_COMPILER_ARG1})
status("    C flags (Release):"      ${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_RELEASE})
status("    C flags (Debug):"        ${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_DEBUG})
if(WIN32)
  status("    Linker flags (Release):" ${CMAKE_EXE_LINKER_FLAGS} ${CMAKE_EXE_LINKER_FLAGS_RELEASE})
  status("    Linker flags (Debug):"   ${CMAKE_EXE_LINKER_FLAGS} ${CMAKE_EXE_LINKER_FLAGS_DEBUG})
else()
  status("    Linker flags (Release):" ${CMAKE_SHARED_LINKER_FLAGS} ${CMAKE_SHARED_LINKER_FLAGS_RELEASE})
  status("    Linker flags (Debug):"   ${CMAKE_SHARED_LINKER_FLAGS} ${CMAKE_SHARED_LINKER_FLAGS_DEBUG})
endif()
status("    ccache:"                  CMAKE_COMPILER_IS_CCACHE THEN YES ELSE NO)
status("    Precompiled headers:"     PCHSupport_FOUND AND ENABLE_PRECOMPILED_HEADERS THEN YES ELSE NO)

# ========================== Dependencies ============================
ocv_get_all_libs(deps_modules deps_extra deps_3rdparty)
status("    Extra dependencies:" ${deps_extra})
status("    3rdparty dependencies:" ${deps_3rdparty})

# ========================== OpenCV modules ==========================
status("")
status("  OpenCV modules:")
string(REPLACE "opencv_" "" OPENCV_MODULES_BUILD_ST          "${OPENCV_MODULES_BUILD}")
string(REPLACE "opencv_" "" OPENCV_MODULES_DISABLED_USER_ST  "${OPENCV_MODULES_DISABLED_USER}")
string(REPLACE "opencv_" "" OPENCV_MODULES_DISABLED_AUTO_ST  "${OPENCV_MODULES_DISABLED_AUTO}")
string(REPLACE "opencv_" "" OPENCV_MODULES_DISABLED_FORCE_ST "${OPENCV_MODULES_DISABLED_FORCE}")
list(SORT OPENCV_MODULES_BUILD_ST)
list(SORT OPENCV_MODULES_DISABLED_USER_ST)
list(SORT OPENCV_MODULES_DISABLED_AUTO_ST)
list(SORT OPENCV_MODULES_DISABLED_FORCE_ST)
status("    To be built:"            OPENCV_MODULES_BUILD          THEN ${OPENCV_MODULES_BUILD_ST}          ELSE "-")
status("    Disabled:"               OPENCV_MODULES_DISABLED_USER  THEN ${OPENCV_MODULES_DISABLED_USER_ST}  ELSE "-")
status("    Disabled by dependency:" OPENCV_MODULES_DISABLED_AUTO  THEN ${OPENCV_MODULES_DISABLED_AUTO_ST}  ELSE "-")
status("    Unavailable:"            OPENCV_MODULES_DISABLED_FORCE THEN ${OPENCV_MODULES_DISABLED_FORCE_ST} ELSE "-")

ocv_build_features_string(apps_status
  IF BUILD_TESTS AND HAVE_opencv_ts THEN "tests"
  IF BUILD_PERF_TESTS AND HAVE_opencv_ts THEN "perf_tests"
  IF BUILD_EXAMPLES THEN "examples"
  IF BUILD_opencv_apps THEN "apps"
  IF BUILD_ANDROID_SERVICE THEN "android_service"
  IF BUILD_ANDROID_EXAMPLES AND CAN_BUILD_ANDROID_PROJECTS THEN "android_examples"
  ELSE "-")
status("    Applications:" "${apps_status}")
ocv_build_features_string(docs_status
    IF TARGET doxygen_cpp THEN "doxygen"
    IF TARGET doxygen_python THEN "python"
    IF TARGET doxygen_javadoc THEN "javadoc"
    IF BUILD_opencv_js OR DEFINED OPENCV_JS_LOCATION THEN "js"
    ELSE "NO"
)
status("    Documentation:" "${docs_status}")
status("    Non-free algorithms:" OPENCV_ENABLE_NONFREE THEN "YES" ELSE "NO")

# ========================== Android details ==========================
if(ANDROID)
  status("")
  status("  Android: ")
  status("    Android ABI:" ${ANDROID_ABI})
  status("    STL type:" ${ANDROID_STL})
  status("    Native API level:" android-${ANDROID_NATIVE_API_LEVEL})
  android_get_compatible_target(android_sdk_target_status ${ANDROID_NATIVE_API_LEVEL} ${ANDROID_SDK_TARGET} 11)
  status("    SDK target:" "${android_sdk_target_status}")
  if(BUILD_WITH_ANDROID_NDK)
    status("    Android NDK:" "${ANDROID_NDK} (toolchain: ${ANDROID_TOOLCHAIN_NAME})")
  elseif(BUILD_WITH_STANDALONE_TOOLCHAIN)
    status("    Android toolchain:" "${ANDROID_STANDALONE_TOOLCHAIN}")
  endif()
  status("    android tool:"  ANDROID_EXECUTABLE  THEN "${ANDROID_EXECUTABLE} (${ANDROID_TOOLS_Pkg_Desc})" ELSE NO)
endif()

# ================== Windows RT features ==================
if(WIN32)
status("")
status("  Windows RT support:" WINRT THEN YES ELSE NO)
  if(WINRT)
    status("    Building for Microsoft platform: " ${CMAKE_SYSTEM_NAME})
    status("    Building for architectures: " ${CMAKE_VS_EFFECTIVE_PLATFORMS})
    status("    Building for version: " ${CMAKE_SYSTEM_VERSION})
    if (DEFINED ENABLE_WINRT_MODE_NATIVE)
      status("    Building for C++ without CX extensions")
    endif()
  endif()
endif(WIN32)

# ========================== GUI ==========================
status("")
status("  GUI: ")

if(WITH_QT OR HAVE_QT)
  if(HAVE_QT5)
    status("    QT:" "YES (ver ${Qt5Core_VERSION_STRING})")
    status("      QT OpenGL support:" HAVE_QT_OPENGL THEN "YES (${Qt5OpenGL_LIBRARIES} ${Qt5OpenGL_VERSION_STRING})" ELSE NO)
  elseif(HAVE_QT)
    status("    QT:" "YES (ver ${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH} ${QT_EDITION})")
    status("      QT OpenGL support:" HAVE_QT_OPENGL THEN "YES (${QT_QTOPENGL_LIBRARY})" ELSE NO)
  else()
    status("    QT:" "NO")
  endif()
endif()

if(WITH_WIN32UI)
  status("    Win32 UI:" HAVE_WIN32UI THEN YES ELSE NO)
endif()

if(APPLE)
  if(WITH_CARBON)
    status("    Carbon:" YES)
  else()
    status("    Cocoa:"  YES)
  endif()
endif()

if(WITH_GTK OR HAVE_GTK)
  if(HAVE_GTK3)
    status("    GTK+:" "YES (ver ${ALIASOF_gtk+-3.0_VERSION})")
  elseif(HAVE_GTK)
    status("    GTK+:" "YES (ver ${ALIASOF_gtk+-2.0_VERSION})")
  else()
    status("    GTK+:" "NO")
  endif()
  if(HAVE_GTK)
    status(  "      GThread :" HAVE_GTHREAD THEN "YES (ver ${ALIASOF_gthread-2.0_VERSION})" ELSE NO)
    status(  "      GtkGlExt:" HAVE_GTKGLEXT THEN "YES (ver ${ALIASOF_gtkglext-1.0_VERSION})" ELSE NO)
  endif()
endif()

if(WITH_OPENGL OR HAVE_OPENGL)
  status("    OpenGL support:" HAVE_OPENGL THEN "YES (${OPENGL_LIBRARIES})" ELSE NO)
endif()

if(WITH_VTK OR HAVE_VTK)
  status("    VTK support:" HAVE_VTK THEN "YES (ver ${VTK_VERSION})" ELSE NO)
endif()

# ========================== MEDIA IO ==========================
status("")
status("  Media I/O: ")
status("    ZLib:"   ZLIB_FOUND THEN "${ZLIB_LIBRARIES} (ver ${ZLIB_VERSION_STRING})" ELSE "build (ver ${ZLIB_VERSION_STRING})")

if(WITH_JPEG OR HAVE_JPEG)
  status("    JPEG:" JPEG_FOUND THEN "${JPEG_LIBRARY} (ver ${JPEG_LIB_VERSION})" ELSE "build (ver ${JPEG_LIB_VERSION})")
endif()

if(WITH_WEBP OR HAVE_WEBP)
  status("    WEBP:" WEBP_FOUND THEN "${WEBP_LIBRARY} (ver ${WEBP_VERSION})" ELSE "build (ver ${WEBP_VERSION})")
endif()

if(WITH_PNG OR HAVE_PNG)
  status("    PNG:"  PNG_FOUND  THEN "${PNG_LIBRARY} (ver ${PNG_VERSION})" ELSE "build (ver ${PNG_VERSION})")
endif()

if(WITH_TIFF OR HAVE_TIFF)
  status("    TIFF:" TIFF_FOUND THEN "${TIFF_LIBRARY} (ver ${TIFF_VERSION} / ${TIFF_VERSION_STRING})" ELSE "build (ver ${TIFF_VERSION} - ${TIFF_VERSION_STRING})")
endif()

if(WITH_JASPER OR HAVE_JASPER)
  status("    JPEG 2000:" JASPER_FOUND THEN "${JASPER_LIBRARY} (ver ${JASPER_VERSION_STRING})" ELSE "build (ver ${JASPER_VERSION_STRING})")
endif()

if(WITH_OPENEXR OR HAVE_OPENEXR)
  status("    OpenEXR:" OPENEXR_FOUND THEN "${OPENEXR_LIBRARIES} (ver ${OPENEXR_VERSION})" ELSE "build (ver ${OPENEXR_VERSION})")
endif()

if(WITH_GDAL OR HAVE_GDAL)
  status("    GDAL:" HAVE_GDAL THEN "YES (${GDAL_LIBRARY})" ELSE "NO")
endif()

if(WITH_GDCM OR HAVE_GDCM)
  status("    GDCM:" HAVE_GDCM THEN "YES (ver ${GDCM_VERSION})" ELSE "NO")
endif()

# ========================== VIDEO IO ==========================
status("")
status("  Video I/O:")

if(WITH_VFW OR HAVE_VFW)
  status("    Video for Windows:" HAVE_VFW         THEN YES                                        ELSE NO)
endif()

if(WITH_1394 OR HAVE_DC1394)
  if (HAVE_DC1394_2)
    status("    DC1394:" "YES (ver ${ALIASOF_libdc1394-2_VERSION})")
  elseif (HAVE_DC1394)
    status("    DC1394:" "YES (ver ${ALIASOF_libdc1394_VERSION})")
  else()
    status("    DC1394:" "NO")
  endif()
endif()

if(WITH_FFMPEG OR HAVE_FFMPEG)
  if(WIN32)
    status("    FFMPEG:"       HAVE_FFMPEG         THEN "YES (prebuilt binaries)"                  ELSE NO)
  else()
    status("    FFMPEG:"       HAVE_FFMPEG         THEN YES ELSE NO)
  endif()
  status("      avcodec:"      FFMPEG_libavcodec_FOUND    THEN "YES (ver ${FFMPEG_libavcodec_VERSION})"    ELSE NO)
  status("      avformat:"     FFMPEG_libavformat_FOUND   THEN "YES (ver ${FFMPEG_libavformat_VERSION})"   ELSE NO)
  status("      avutil:"       FFMPEG_libavutil_FOUND     THEN "YES (ver ${FFMPEG_libavutil_VERSION})"     ELSE NO)
  status("      swscale:"      FFMPEG_libswscale_FOUND    THEN "YES (ver ${FFMPEG_libswscale_VERSION})"    ELSE NO)
  status("      avresample:"   FFMPEG_libavresample_FOUND THEN "YES (ver ${FFMPEG_libavresample_VERSION})" ELSE NO)
endif()

if(WITH_GSTREAMER OR HAVE_GSTREAMER)
  status("    GStreamer:"      HAVE_GSTREAMER      THEN ""                                         ELSE NO)
  if(HAVE_GSTREAMER)
    status("      base:"       "YES (ver ${GSTREAMER_BASE_VERSION})")
    status("      video:"      "YES (ver ${GSTREAMER_VIDEO_VERSION})")
    status("      app:"        "YES (ver ${GSTREAMER_APP_VERSION})")
    status("      riff:"       "YES (ver ${GSTREAMER_RIFF_VERSION})")
    status("      pbutils:"    "YES (ver ${GSTREAMER_PBUTILS_VERSION})")
  endif(HAVE_GSTREAMER)
endif()

if(WITH_OPENNI OR HAVE_OPENNI)
  status("    OpenNI:"         HAVE_OPENNI         THEN "YES (ver ${OPENNI_VERSION_STRING}, build ${OPENNI_VERSION_BUILD})" ELSE NO)
  status("    OpenNI PrimeSensor Modules:" HAVE_OPENNI_PRIME_SENSOR_MODULE THEN "YES (${OPENNI_PRIME_SENSOR_MODULE})"      ELSE NO)
endif()

if(WITH_OPENNI2 OR HAVE_OPENNI2)
  status("    OpenNI2:"        HAVE_OPENNI2    THEN "YES (ver ${OPENNI2_VERSION_STRING}, build ${OPENNI2_VERSION_BUILD})" ELSE NO)
endif()

if(WITH_PVAPI OR HAVE_PVAPI)
  status("    PvAPI:"          HAVE_PVAPI          THEN YES                                        ELSE NO)
endif()

if(WITH_GIGEAPI OR HAVE_GIGE_API)
  status("    GigEVisionSDK:"  HAVE_GIGE_API       THEN YES                                        ELSE NO)
endif()

if(WITH_ARAVIS OR HAVE_ARAVIS_API)
  status("    Aravis SDK:"     HAVE_ARAVIS_API     THEN "YES (${ARAVIS_LIBRARIES})"                ELSE NO)
endif()

if(APPLE)
  status("    AVFoundation:"   HAVE_AVFOUNDATION   THEN YES                                        ELSE NO)
  if(WITH_QUICKTIME OR HAVE_QUICKTIME)
    status("    QuickTime:"      HAVE_QUICKTIME      THEN YES                                        ELSE NO)
  endif()
  if(WITH_QTKIT OR HAVE_QTKIT)
    status("    QTKit:"          HAVE_QTKIT          THEN "YES (deprecated)"                         ELSE NO)
  endif()
endif()

if(WITH_UNICAP OR HAVE_UNICAP)
  status("    UniCap:"         HAVE_UNICAP         THEN "YES (ver ${ALIASOF_libunicap_VERSION})"   ELSE NO)
  status("    UniCap ucil:"    HAVE_UNICAP_UCIL    THEN "YES (ver ${ALIASOF_libucil_VERSION})"     ELSE NO)
endif()

if(WITH_V4L OR WITH_LIBV4L OR HAVE_LIBV4L OR HAVE_CAMV4L OR HAVE_CAMV4L2 OR HAVE_VIDEOIO)
  status("    libv4l/libv4l2:" HAVE_LIBV4L THEN "${ALIASOF_libv4l1_VERSION} / ${ALIASOF_libv4l2_VERSION}" ELSE "NO")
  ocv_build_features_string(v4l_status
    IF HAVE_CAMV4L THEN "linux/videodev.h"
    IF HAVE_CAMV4L2 THEN "linux/videodev2.h"
    IF HAVE_VIDEOIO THEN "sys/videoio.h"
    ELSE "NO")
  status("    v4l/v4l2:" "${v4l_status}")
endif()

if(WITH_DSHOW OR HAVE_DSHOW)
  status("    DirectShow:"     HAVE_DSHOW     THEN YES                                        ELSE NO)
endif()

if(WITH_MSMF OR HAVE_MSMF)
  status("    Media Foundation:" HAVE_MSMF    THEN YES                                        ELSE NO)
endif()

if(WITH_XIMEA OR HAVE_XIMEA)
  status("    XIMEA:"          HAVE_XIMEA          THEN YES                                        ELSE NO)
endif()

if(WITH_XINE OR HAVE_XINE)
  status("    Xine:"           HAVE_XINE           THEN "YES (ver ${ALIASOF_libxine_VERSION})"     ELSE NO)
endif()

if(WITH_INTELPERC OR HAVE_INTELPERC)
  status("    Intel PerC:"     HAVE_INTELPERC      THEN "YES"                                 ELSE NO)
endif()

if(WITH_MFX OR HAVE_MFX)
  status("    Intel Media SDK:" HAVE_MFX      THEN "YES (${MFX_LIBRARY})" ELSE NO)
endif()

if(WITH_GPHOTO2 OR HAVE_GPHOTO2)
  status("    gPhoto2:"        HAVE_GPHOTO2        THEN "YES"                                 ELSE NO)
endif()

# Order is similar to CV_PARALLEL_FRAMEWORK in core/src/parallel.cpp
ocv_build_features_string(parallel_status EXCLUSIVE
  IF HAVE_TBB THEN "TBB (ver ${TBB_VERSION_MAJOR}.${TBB_VERSION_MINOR} interface ${TBB_INTERFACE_VERSION})"
  IF HAVE_CSTRIPES THEN "C="
  IF HAVE_OPENMP THEN "OpenMP"
  IF HAVE_GCD THEN "GCD"
  IF WINRT OR HAVE_CONCURRENCY THEN "Concurrency"
  IF HAVE_PTHREADS_PF THEN "pthreads"
  ELSE "none")
status("")
status("  Parallel framework:" "${parallel_status}")

if(CV_TRACE OR OPENCV_TRACE)
  ocv_build_features_string(trace_status EXCLUSIVE
    IF HAVE_ITT THEN "with Intel ITT"
    ELSE "built-in")
  status("")
  status("  Trace: " OPENCV_TRACE THEN "YES (${trace_status})" ELSE NO)
endif()

# ========================== Other third-party libraries ==========================
status("")
status("  Other third-party libraries:")

if(WITH_IPP AND HAVE_IPP)
  status("    Intel IPP:" "${IPP_VERSION_STR} [${IPP_VERSION_MAJOR}.${IPP_VERSION_MINOR}.${IPP_VERSION_BUILD}]")
  status("           at:" "${IPP_ROOT_DIR}")
  if(NOT HAVE_IPP_ICV)
    status("       linked:" BUILD_WITH_DYNAMIC_IPP THEN "dynamic" ELSE "static")
  endif()
  if(HAVE_IPP_IW)
    if(BUILD_IPP_IW)
      status("    Intel IPP IW:" "sources (${IW_VERSION_MAJOR}.${IW_VERSION_MINOR}.${IW_VERSION_UPDATE})")
    else()
      status("    Intel IPP IW:" "binaries (${IW_VERSION_MAJOR}.${IW_VERSION_MINOR}.${IW_VERSION_UPDATE})")
    endif()
    status("              at:" "${IPP_IW_PATH}")
  else()
    status("    Intel IPP IW:"   NO)
  endif()
endif()

if(WITH_VA OR HAVE_VA)
  status("    VA:"            HAVE_VA          THEN "YES" ELSE NO)
endif()

if(WITH_VA_INTEL OR HAVE_VA_INTEL)
  status("    Intel VA-API/OpenCL:"  HAVE_VA_INTEL       THEN "YES (MSDK: ${VA_INTEL_MSDK_ROOT}  OpenCL: ${VA_INTEL_IOCL_ROOT})" ELSE NO)
endif()

if(WITH_LAPACK OR HAVE_LAPACK)
  status("    Lapack:"      HAVE_LAPACK     THEN "YES (${LAPACK_LIBRARIES})" ELSE NO)
endif()

if(WITH_HALIDE OR HAVE_HALIDE)
  status("    Halide:"     HAVE_HALIDE      THEN "YES (${HALIDE_LIBRARIES} ${HALIDE_INCLUDE_DIRS})" ELSE NO)
endif()

if(WITH_INF_ENGINE OR HAVE_INF_ENGINE)
  status("    Inference Engine:"     HAVE_INF_ENGINE     THEN "YES (${INF_ENGINE_LIBRARIES} ${INF_ENGINE_INCLUDE_DIRS})" ELSE NO)
endif()

if(WITH_EIGEN OR HAVE_EIGEN)
  status("    Eigen:"      HAVE_EIGEN       THEN "YES (ver ${EIGEN_WORLD_VERSION}.${EIGEN_MAJOR_VERSION}.${EIGEN_MINOR_VERSION})" ELSE NO)
endif()

if(WITH_OPENVX OR HAVE_OPENVX)
  status("    OpenVX:"     HAVE_OPENVX      THEN "YES (${OPENVX_LIBRARIES})" ELSE "NO")
endif()

status("    Custom HAL:" OpenCV_USED_HAL  THEN "YES (${OpenCV_USED_HAL})" ELSE "NO")

foreach(s ${CUSTOM_STATUS})
  status(${CUSTOM_STATUS_${s}})
endforeach()

if(WITH_CUDA OR HAVE_CUDA)
  ocv_build_features_string(cuda_features
    IF HAVE_CUFFT THEN "CUFFT"
    IF HAVE_CUBLAS THEN "CUBLAS"
    IF HAVE_NVCUVID THEN "NVCUVID"
    IF CUDA_FAST_MATH THEN "FAST_MATH"
    ELSE "no extra features")
  status("")
  status("  NVIDIA CUDA:" HAVE_CUDA THEN "YES (ver ${CUDA_VERSION_STRING}, ${cuda_features})" ELSE NO)
  if(HAVE_CUDA)
    status("    NVIDIA GPU arch:"      ${OPENCV_CUDA_ARCH_BIN})
    status("    NVIDIA PTX archs:"     ${OPENCV_CUDA_ARCH_PTX})
  endif()
endif()

if(WITH_OPENCL OR HAVE_OPENCL)
  ocv_build_features_string(opencl_features
    IF HAVE_OPENCL_SVM THEN "SVM"
    IF HAVE_CLAMDFFT THEN "AMDFFT"
    IF HAVE_CLAMDBLAS THEN "AMDBLAS"
    ELSE "no extra features")
  status("")
  status("  OpenCL:"     HAVE_OPENCL   THEN   "YES (${opencl_features})" ELSE "NO")
  if(HAVE_OPENCL)
    status("    Include path:"  OPENCL_INCLUDE_DIRS THEN "${OPENCL_INCLUDE_DIRS}" ELSE "NO")
    status("    Link libraries:"       OPENCL_LIBRARIES THEN "${OPENCL_LIBRARIES}" ELSE "Dynamic load")
  endif()
endif()

# ========================== python ==========================
if(BUILD_opencv_python2)
  status("")
  status("  Python 2:")
  status("    Interpreter:"     PYTHON2INTERP_FOUND  THEN "${PYTHON2_EXECUTABLE} (ver ${PYTHON2_VERSION_STRING})"       ELSE NO)
  if(PYTHON2LIBS_VERSION_STRING)
    status("    Libraries:"   HAVE_opencv_python2  THEN  "${PYTHON2_LIBRARIES} (ver ${PYTHON2LIBS_VERSION_STRING})"   ELSE NO)
  else()
    status("    Libraries:"   HAVE_opencv_python2  THEN  "${PYTHON2_LIBRARIES}"                                      ELSE NO)
  endif()
  status("    numpy:"         PYTHON2_NUMPY_INCLUDE_DIRS THEN "${PYTHON2_NUMPY_INCLUDE_DIRS} (ver ${PYTHON2_NUMPY_VERSION})" ELSE "NO (Python wrappers can not be generated)")
  status("    packages path:" PYTHON2_EXECUTABLE         THEN "${PYTHON2_PACKAGES_PATH}"                                    ELSE "-")
endif()

if(BUILD_opencv_python3)
  status("")
  status("  Python 3:")
  status("    Interpreter:"     PYTHON3INTERP_FOUND  THEN "${PYTHON3_EXECUTABLE} (ver ${PYTHON3_VERSION_STRING})"       ELSE NO)
  if(PYTHON3LIBS_VERSION_STRING)
    status("    Libraries:"   HAVE_opencv_python3  THEN  "${PYTHON3_LIBRARIES} (ver ${PYTHON3LIBS_VERSION_STRING})"   ELSE NO)
  else()
    status("    Libraries:"   HAVE_opencv_python3  THEN  "${PYTHON3_LIBRARIES}"                                      ELSE NO)
  endif()
  status("    numpy:"         PYTHON3_NUMPY_INCLUDE_DIRS THEN "${PYTHON3_NUMPY_INCLUDE_DIRS} (ver ${PYTHON3_NUMPY_VERSION})" ELSE "NO (Python3 wrappers can not be generated)")
  status("    packages path:" PYTHON3_EXECUTABLE         THEN "${PYTHON3_PACKAGES_PATH}"                                    ELSE "-")
endif()

status("")
status("  Python (for build):"  PYTHON_DEFAULT_AVAILABLE THEN "${PYTHON_DEFAULT_EXECUTABLE}" ELSE NO)
if(PYLINT_FOUND AND PYLINT_EXECUTABLE)
  status("    Pylint:"  PYLINT_FOUND THEN "${PYLINT_EXECUTABLE} (ver: ${PYLINT_VERSION}, checks: ${PYLINT_TOTAL_TARGETS})" ELSE NO)
endif()

# ========================== java ==========================
if(BUILD_JAVA OR BUILD_opencv_java)
  status("")
  status("  Java:"            BUILD_FAT_JAVA_LIB  THEN "export all functions"                                      ELSE "")
  status("    ant:"           ANT_EXECUTABLE      THEN "${ANT_EXECUTABLE} (ver ${ANT_VERSION})"                    ELSE NO)
  if(NOT ANDROID)
    status("    JNI:"         JNI_INCLUDE_DIRS    THEN "${JNI_INCLUDE_DIRS}"                                       ELSE NO)
  endif()
  status("    Java wrappers:" HAVE_opencv_java                                                            THEN YES ELSE NO)
  status("    Java tests:"    BUILD_TESTS AND opencv_test_java_BINARY_DIR                                 THEN YES ELSE NO)
endif()

# ========================= matlab =========================
if(WITH_MATLAB OR MATLAB_FOUND)
  status("")
  status("  Matlab:" MATLAB_FOUND THEN "YES" ELSE "NO")
  if(MATLAB_FOUND)
    status("    mex:"         MATLAB_MEX_SCRIPT  THEN  "${MATLAB_MEX_SCRIPT}"   ELSE NO)
    status("    Compiler/generator:" MEX_WORKS   THEN  "Working"                ELSE "Not working (bindings will not be generated)")
  endif()
endif()

# ========================== auxiliary ==========================
status("")
status("  Install to:" "${CMAKE_INSTALL_PREFIX}")
status("-----------------------------------------------------------------")
status("")


ocv_finalize_status()
