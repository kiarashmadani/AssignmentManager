# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Release")
  file(REMOVE_RECURSE
  "CMakeFiles\\appAssignmentManager_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appAssignmentManager_autogen.dir\\ParseCache.txt"
  "appAssignmentManager_autogen"
  )
endif()
