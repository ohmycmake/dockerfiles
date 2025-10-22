cmake_minimum_required(VERSION 4.1 FATAL_ERROR)

project(dockerfiles
    VERSION         1.0.0
    DESCRIPTION     "ohmycmake docker development environment configurations"
    HOMEPAGE_URL    "https://ohmycmake.com/"
    LANGUAGES       NONE
)

# Add custom target to build docker image
add_custom_target(build-ohmycmake ALL
    COMMAND docker build -f ohmycmake.dockerfile -t ohmycmake:latest .
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Building ohmycmake docker image"
)
