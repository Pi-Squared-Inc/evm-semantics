# Modified from:
#   evm-semantics Dockerfile
# incorporating configuration from:
#   github.com/Pi-Squared-Inc/ulm/blob/main/Docker/OP-KEVM/Dockerfile.opkevm

ARG Z3_VERSION
ARG K_VERSION
ARG BASE_DISTRO
ARG LLVM_VERSION

ARG Z3_VERSION
FROM runtimeverificationinc/z3:ubuntu-jammy-${Z3_VERSION} as Z3

ARG K_VERSION
FROM runtimeverificationinc/kframework-k:ubuntu-jammy-${K_VERSION}

COPY --from=Z3 /usr/bin/z3 /usr/bin/z3

ARG LLVM_VERSION

RUN    apt-get update                  \
    && apt-get upgrade --yes           \
    && apt-get install --yes           \
            cmake                      \
            curl                       \
            debhelper                  \
            gnupg                      \
            libboost-test-dev          \
            libcrypto++-dev            \
            libsecp256k1-dev           \
            libssl-dev                 \
            libyaml-dev                \
            lsb-release                \
            maven                      \
            python3                    \
            python3-pip                \
            software-properties-common \
            wget


# ULM Depends on specific version of LLVM and Go, not available through apt.
## Install LLVM 16: Install version 16 as later versions have a known bug affecting the code generator.
ARG LLVM_VERSION=16
ARG GO_VERSION=1.23.1
RUN wget https://apt.llvm.org/llvm.sh -O llvm.sh && chmod +x llvm.sh
RUN ./llvm.sh ${LLVM_VERSION} all && \
    apt-get install -y --no-install-recommends clang-${LLVM_VERSION} lldb-${LLVM_VERSION} lld-${LLVM_VERSION} && \
    rm -f llvm.sh
# Install Go
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -O go${GO_VERSION}.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

ARG USER=user
ARG GROUP
ARG USER_ID
ARG GROUP_ID
RUN groupadd -g ${GROUP_ID} ${GROUP} && useradd -m -u ${USER_ID} -s /bin/sh -g ${GROUP} ${USER}


USER ${USER}:${GROUP}
RUN mkdir /home/${USER}/workspace
WORKDIR /home/${USER}/workspace

ENV PATH=/home/${USER}/.local/bin:${PATH}

RUN    curl -sSL https://install.python-poetry.org | python3 - --version 1.8.3 \
    && poetry --version

