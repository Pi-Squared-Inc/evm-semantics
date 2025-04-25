# Modified from:
#   evm-semantics Dockerfile
# incorporating configuration from:
#   github.com/Pi-Squared-Inc/ulm/blob/main/Docker/OP-KEVM/Dockerfile.opkevm

ARG Z3_VERSION
ARG K_VERSION

FROM runtimeverificationinc/z3:ubuntu-noble-${Z3_VERSION} as Z3

FROM runtimeverificationinc/kframework-k:ubuntu-noble-${K_VERSION}

COPY --from=Z3 /usr/bin/z3 /usr/bin/z3

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
            ninja-build                \
            python3                    \
            python3-pip                \
            software-properties-common \
            wget


# ULM Depends on specific version of LLVM and Go, not available through apt.
## Install LLVM 16: Install version 16 as later versions have a known bug affecting the code generator.
ARG LLVM_VERSION=16
ARG GO_VERSION=1.23.1
RUN apt-get install -y --no-install-recommends clang-${LLVM_VERSION} lldb-${LLVM_VERSION} lld-${LLVM_VERSION}
# Install Go
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -O go${GO_VERSION}.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

ARG USER=user
ARG GROUP
ARG USER_ID
ARG GROUP_ID
# if our desired group or user id is already taken, try to rename
RUN ( groupadd -g ${GROUP_ID} ${GROUP} || \
      groupmod -n ${GROUP} $(getent group ${GROUP_ID} | cut -d: -f1) \
    ) && \
    useradd -m -u ${USER_ID} -s /bin/sh -g ${GROUP_ID} -d /home/${USER} ${USER} || \
    usermod -m -u ${USER_ID} -s /bin/sh -g ${GROUP_ID} -d /home/${USER} -l ${USER} $(getent passwd ${USER_ID} | cut -d: -f1)

USER ${USER}:${GROUP}
RUN mkdir /home/${USER}/workspace
WORKDIR /home/${USER}/workspace

ENV PATH=/home/${USER}/.local/bin:${PATH}

ARG POETRY_VERSION
RUN    curl -sSL https://install.python-poetry.org | python3 - --version ${POETRY_VERSION} \
    && poetry --version

