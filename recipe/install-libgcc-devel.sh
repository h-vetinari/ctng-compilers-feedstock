set -e -x

export CHOST="${gcc_machine}-${gcc_vendor}-linux-gnu"

# libtool wants to use ranlib that is here, macOS install doesn't grok -t etc
# .. do we need this scoped over the whole file though?
#export PATH=${SRC_DIR}/gcc_built/bin:${SRC_DIR}/.build/${CHOST}/buildtools/bin:${SRC_DIR}/.build/tools/bin:${PATH}

pushd ${SRC_DIR}/build

make -C ${CHOST}/libgcc prefix=${PREFIX} install

# These go into libgcc output
rm -rf ${PREFIX}/lib/libgcc_s.so*
# These go into gcc_impl
find ${PREFIX}/${CHOST}/lib/ ! -name 'libgcc_s.so*' -type l -or -type f -exec rm -f {} +
# This is in gcc_impl as it is gcc specific and clang has the same header
rm -rf ${PREFIX}/lib/gcc/${CHOST}/${gcc_version}/include/unwind.h

popd

