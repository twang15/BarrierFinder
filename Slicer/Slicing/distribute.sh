#!/bin/bash
## Distribute source code and build files into llvm source tree.


##Dominator, Post Dominance Frontier calculation
cp $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/llvm/DominanceFrontier.h  $HOME/llvm-3.7.0.src/include/llvm/Analysis/DominanceFrontier.h
cp $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/llvm/DominanceFrontierImpl.h  $HOME/llvm-3.7.0.src/include/llvm/Analysis/DominanceFrontierImpl.h

## llvm debug infrastructure enhancement: xdot CFG
cp $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/llvm/GraphWriter.cpp   $HOME/llvm-3.7.0.src/lib/Support/GraphWriter.cpp
cp $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/llvm/Function.h   $HOME/llvm-3.7.0.src/include/llvm/IR/Function.h

## llvm 3.7 dis-assembler adpation to llvm 3.1's IR.
cp $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/llvm/AsmWriter.cpp  $HOME/llvm-3.7.0.src/lib/IR/AsmWriter.cpp
cp $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/llvm/Attributes.cpp  $HOME/llvm-3.7.0.src/lib/IR/Attributes.cpp

## llvm infrastructure dependency update
cp $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/llvm/InitializePasses.h  $HOME/llvm-3.7.0.src/include/llvm/InitializePasses.h

##Gold, create inter-slicer pass and hammock CFG cannoicalization pass
cp $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/llvm/gold-plugin.cpp  $HOME/llvm-3.7.0.src/tools/gold/gold-plugin.cpp

##Gold dependency on Slicer
cp $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/llvm/CMakeLists.txt.tools.gold  $HOME/llvm-3.7.0.src/tools/gold/CMakeLists.txt

## add Slicer into llvm source tree
cp $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/llvm/CMakeLists.txt.lib.Transform $HOME/llvm-3.7.0.src/lib/Transforms/CMakeLists.txt
