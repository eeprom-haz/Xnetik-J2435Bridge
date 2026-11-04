cmake_minimum_required(VERSION 3.19)
project(XnetikBridge LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

if(NOT WIN32)
    message(FATAL_ERROR "Xnetik Bridge is Windows-only (J2534).")
endif()

# ── 32-bit J2534 proxy DLL ──────────────────────────────────────────────────
add_library(XnetikBridgeJ2534 SHARED
    src/proxy/J2534Proxy.cpp
)
target_include_directories(XnetikBridgeJ2534 PRIVATE src)
target_link_libraries(XnetikBridgeJ2534 PRIVATE ws2_32)
target_link_options(XnetikBridgeJ2534 PRIVATE
    -static -static-libgcc -static-libstdc++
    -Wl,--add-stdcall-alias
)
set_target_properties(XnetikBridgeJ2534 PROPERTIES
    PREFIX ""
    OUTPUT_NAME "XnetikBridgeJ2534"
)

# ── Remote agent (32-bit vendor host) ───────────────────────────────────────
add_executable(XnetikBridgeAgent
    src/agent/main.cpp
    src/agent/VendorHost.cpp
    src/agent/Status.cpp
    src/agent/HttpStatus.cpp
    src/common/Registry.cpp
)
target_include_directories(XnetikBridgeAgent PRIVATE src)
target_link_libraries(XnetikBridgeAgent PRIVATE ws2_32 advapi32)
target_link_options(XnetikBridgeAgent PRIVATE -static -static-libgcc -static-libstdc++)

# ── Probe / registry lister ─────────────────────────────────────────────────
add_executable(XnetikBridgeProbe
    src/probe/main.cpp
    src/agent/VendorHost.cpp
    src/common/Registry.cpp
)
target_include_directories(XnetikBridgeProbe PRIVATE src)
target_link_libraries(XnetikBridgeProbe PRIVATE advapi32)
target_link_options(XnetikBridgeProbe PRIVATE -static -static-libgcc -static-libstdc++)

# ── Test fake vendor DLL + loopback client ──────────────────────────────────
add_library(fakej2534 SHARED tests/fake_j2534.cpp)
target_include_directories(fakej2534 PRIVATE src)
target_link_options(fakej2534 PRIVATE
    -static -static-libgcc -static-libstdc++
    -Wl,--add-stdcall-alias
)
set_target_properties(fakej2534 PROPERTIES PREFIX "" OUTPUT_NAME "fakej2534")

add_executable(xn_test_proxy tests/test_proxy.cpp)
target_include_directories(xn_test_proxy PRIVATE src)
target_link_options(xn_test_proxy PRIVATE -static -static-libgcc -static-libstdc++)
