[README before installation]
For the first time installation, manually copy-paste-execute the following scripts is highly recommended.
Because, occasionally, the script asks for sudo password or repository access password.
The comments are beginning with # and indicates the installation progress.
Instructions are beginning without #

[Download and install OS]

    ## the ubuntu image
    wget http://releases.ubuntu.com/14.04/ubuntu-14.04.5-desktop-amd64.iso


[Install utilities and dependencies]
sudo apt-get update

    sudo apt-get install git vim openssh-server g++ texinfo flex bison cmake xdot subversion

[Build llvm 3.7 from source code]

    cd $HOME

    [build gold]

    mkdir -p $HOME/tools/binutils.debug
    wget https://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.bz2
    bzip2 -d binutils-2.25.tar.bz2
    tar xvf binutils-2.25.tar
    mkdir build-binutils
    cd build-binutils
    ../binutils-2.25/configure CC=gcc CXX=g++ CFLAGS="-O0 -ggdb3" CXXFLAGS="-O0 -ggdb3" --enable-gold --enable-binutils --enable-plugins --prefix=$HOME/tools/binutils.debug/

    make all-gold all-binutils -j10
    make install-gold install-binutils

    cp $HOME/tools/binutils.debug/bin/ld.gold $HOME/tools/binutils.debug/bin/ld


    [Build llvm and clang]

    cd $HOME

    wget http://llvm.org/releases/3.7.0/llvm-3.7.0.src.tar.xz
    tar -xvf  llvm-3.7.0.src.tar.xz

    wget http://llvm.org/releases/3.7.0/cfe-3.7.0.src.tar.xz
    tar -xvf cfe-3.7.0.src.tar.xz

    mv cfe-3.7.0.src llvm-3.7.0.src/tools/clang

    mkdir build.llvm-3.7.0
    cd build.llvm-3.7.0

    cmake ../llvm-3.7.0.src/ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=$HOME/tools/llvm.debug -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_C_FLAGS="-v -O0 -ggdb3 -fno-inline-small-functions -fno-inline-functions" -DCMAKE_CXX_FLAGS="-v -O0 -ggdb3 -fno-inline-small-functions -fno-inline-functions" -DLLVM_BINUTILS_INCDIR=$HOME/tools/binutils.debug/include/


    make -j10

    mkdir -p $HOME/tools/llvm.debug


    make install

    [update llvm source tree]

    cd $HOME

    ## clone slicer repository

    cd llvm-3.7.0.src/lib/Transforms/


    git clone tao@152.14.86.176:~/llvm-3.7.0.src/lib/Transforms/Slicer/.git

    ### Input password 123456

    cd Slicer/Slicing
    ./distribute.sh


    [Rebuild and install]

    cd $HOME/build.llvm-3.7.0

    make install -j10

    #add path to environment variable.

    PATH=$HOME/tools/binutils.debug/bin:$HOME/tools/llvm.debug/bin:$PATH

    [Test the frontEnd]
    cd $HOME
    mkdir test
    cd test
    scp -r tao@152.14.86.176:~/test2/inter-slicer/withIF/* .

    #test
    cd $HOME/test/inter-slicer/withIF/1b
    make

    #inspect the cfg
    opt -dot-cfg a.out.opt.bc
    xdot cfg.SlaveStart.dot

    ## so far, the  frontend has been successfully installed. ##

    #develop: the source code of synCat frondEnd is under $HOME/llvm-3.7.0.src/lib/Transforms/Slicer
    #rebuild: after modify any source code under $HOME/llvm-3.7.0.src/lib/Transforms/Slicer
    cd ~/build.llvm-3.7.0
    make install -j10


[Build Cloud debug version]

    [install dependencies]

    #open a new terminal (this is important)
    cd $HOME

    ## install google depot_tools
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
    PATH=`pwd`/depot_tools:"$PATH"

    ## install glog
    wget https://google-glog.googlecode.com/files/glog-0.3.3.tar.gz
    tar -xzvf glog-0.3.3.tar.gz && cd glog-0.3.3/
    ./configure --prefix=/usr
    make -j10
    sudo make install
    cd $HOME
    sudo ldconfig

    sudo apt-get install build-essential libcrypto++-dev  zlib1g-dev dejagnu flex bison protobuf-compiler libprotobuf-dev libboost-thread-dev libboost-system-dev


    sudo ln /usr/include/x86_64-linux-gnu/c++/4.8/bits/*.h /usr/include/c++/4.8/bits/
    sudo ln /usr/lib/x86_64-linux-gnu/libboost_thread.a  /usr/lib/x86_64-linux-gnu/libboost_thread-mt.a
    sudo ln /usr/lib/x86_64-linux-gnu/libboost_system.a  /usr/lib/x86_64-linux-gnu/libboost_system-mt.a

    mkdir Cloud9cd Cloud9
    gclient config --name src git+https://github.com/twang15/cloud9-depot.git

    gclient sync

    ## error: Error: Command '/usr/bin/python src/build/gyp_cloud9' returned non-zero exit status 1

    scp -r tao@152.14.86.176:~/Cloud9.dev2/src/third_party/gyp/ src/third_party/

    ### password: 123456

    gclient sync

    #so far, llvm3.1 and binutils tool chain have been successfully built.

    [install STP]

    cd src/third_party/

    git clone https://github.com/stp/minisat.git
    cd minisat && mkdir build && cd build
    cmake ..

    make

    sudo make install
    cd ../..

    git clone https://github.com/stp/stp.git
    cd stp && mkdir build && cd build
    cmake .. 
    make -j10
    sudo make install
    sudo ldconfig

    [build uclibc]
    cd ~/Cloud9/src/klee-uclibc

    #replace "Release+" in Rules.mak to "Debug+"
    make -j10

    [Build Cloud9]

    cd ..
    #replace "Release+" in Makefile with "Debug+"
    make -j10

    rm -rf cloud9git clone tao@152.14.86.176:~/Cloud9.dev2/src/cloud9/.git

    ##password 123456

    cd cloud9

    CC=gcc CXX=g++ CFLAGS="-O0 -v -g3" CXXFLAGS="-O0 -v -g3" ./configure --with-llvmsrc=../third_party/llvm --with-llvmobj=../third_party/llvm-build --with-uclibc=../klee-uclibc --enable-posix-runtime --with-stp=../third_party/stp --with-runtime=Debug+Asserts

    make -C lib/Data
    make -j10

    [libCxx and cloud9 debug version testing]
    cd ~/Cloud9/
    rm -rf src/testing_targets/libcxx
    scp -r tao@152.14.86.176:/home/tao/Cloud9.dev2/src/testing_targets/libcxx  src/testing_targets

    #replace "Release+" in src/testing_targets/build/g++.proxy with "Debug+"
    build/gyp_testing_targets
    build/make_all

    cd ~/Cloud9/src/cloud9
    Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons /home/tao/Cloud9-2/src/testing_targets/out/Default/prod-cons.bc


    ## there should be output ####
    ## then the installation is successful. ###

    #Develop: the source code is under $HOME/Cloud9/src/cloud9
    #Rebuild: after any modification, rebuild the project with following instructions:

    cd $HOME/Cloud9/src/cloud9
    make -j10

[Build Cloud9 release version]


    cd $HOME
    mkdir Cloud9.release
    cd Cloud9.release
    gclient config --name src git+https://github.com/dslab-epfl/cloud9-depot.git
    gclient sync

    #copy gyp somewhere else. No need for modifying and git commiting it, which are illusions.

    cp -rf $HOME/Cloud9/src/third_party/gyp/ src/third_party/
    gclient sync

    #build uclibc
    cd ~/Cloud9/src/klee-uclibc
    make -j10

    #build cloud9
    cd ../
    make -j10


    cd ~/Cloud9-release/src

    rm -rf cloud9

    git clone tao@152.14.86.176:/home/tao/temp/ori/src/cloud9/.git

    CC=gcc CXX=g++ CFLAGS="-O0 -v -g3" CXXFLAGS="-O0 -v -g3" ./configure --with-llvmsrc=../third_party/llvm --with-llvmobj=../third_party/llvm-build --with-uclibc=../klee-uclibc --enable-posix-runtime --with-stp=../third_party/stp --with-runtime=Release+Asserts

    make -C lib/Data

    make -j10

    [Cloud9: Test release version]

    Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons /home/tao/Cloud9/src/testing_targets/out/Default/prod-cons.bc

    ## there should be output ####
    ## then the installation is successful. ###

[Use the SynCat tool chain]
#open a new terminal for front end
#modify PATH environment
PATH=$HOME/tools/binutils.debug/bin:$HOME/tools/llvm.debug/bin:$PATH

#build the application bc file with frontend
cd $HOME/test/inter-slicer/withIF/1b
make

#inspect the cfg
opt -dot-cfg a.out.opt.bc
xdot cfg.SlaveStart.dot

    #disassemble with llvm.3.7
    llvm-dis a.out.opt.bc -o a.out.ll

    #open a new terminal
    cd $HOME/test/inter-slicer/withIF/1b
    mkdir 3.1
    cd 3.1
    source $HOME/Cloud9/src/testing_targets/build/prepare_build_env.sh

    #assemble with llvm 3.1
    llvm-as ../a.out.ll -o a.out.bc

    #execute it with cloud9
    Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/test/inter-slicer/withIF/1b/3.1/a.out.bc

    # inspect the traces
    cat traces.log

[Others]
any other problems, please send messages to twang15@ncsu.edu
