
#set(LLVM_LINK_COMPONENTS core )
#engine bitwriter)


#add_llvm_library(LLVMSlicer
#only keep source files related to slicing. 
#Kleerer.cpp, ModStats.cpp are irrelevant. So far, I don't know what they are doing.

#for both .a and .so
add_llvm_library( LLVMSlicer

#for .a
#add_library(LLVMSlicer

# for .so
#add_llvm_loadable_module(LLVMSlicer
  #Kleerer.cpp
  #ModStats.cpp
	Slicing/FunctionStaticSlicer.cpp
	Slicing/PostDominanceFrontier.cpp
	Slicing/Prepare.cpp
	Slicing/StaticSlicer.cpp
  Slicing/utility.cpp
  Slicing/ValueRangePropagation.cpp
  Slicing/Instrumenter.cpp
  Slicing/BoundaryDetection.cpp
	Callgraph/Callgraph.cpp
	Languages/LLVM.cpp
	Modifies/Modifies.cpp
	PointsTo/PointsTo.cpp
)


#llvm_map_components_to_libraries(REQ_LLVM_LIBRARIES core engine bitwriter)
#target_link_libraries(LLVMSlicer ${REQ_LLVM_LIBRARIES})

message(STATUS "REQ_LLVM_LIBRARIES: ${REQ_LLVM_LIBRARIES}")

#add_dependencies(LLVMSlicer core engine bitwriter)
