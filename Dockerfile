# manylinux2014 targets glibc 2.17 and includes a newer GCC toolchain.
FROM quay.io/pypa/manylinux2014_x86_64

ARG NVIM_REF=v0.12.6
ARG CMAKE_VERSION=3.27.9

# The official CMake Linux x86-64 distribution runs on glibc 2.17.
RUN curl -fsSL "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz" \
    | tar -xz -C /usr/local --strip-components=1

WORKDIR /src
RUN git clone https://github.com/neovim/neovim.git neovim \
    && cd neovim \
    && git checkout --detach "$NVIM_REF" \
    && git rev-parse HEAD > /nvim-source-commit

WORKDIR /src/neovim
RUN make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/opt/nvim \
    && make CMAKE_INSTALL_PREFIX=/opt/nvim install
