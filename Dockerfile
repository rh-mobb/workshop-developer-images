FROM quay.io/devfile/universal-developer-image:ubi8-latest

USER 0

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    dnf install -y https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm && \
    dnf install -y azure-cli parallel yum-utils && \
    TEMP_DIR="$(mktemp -d)"; \
    cd "${TEMP_DIR}"; \
    curl -sSLO https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/rosa/latest/rosa-linux.tar.gz; \
    curl -sSLO https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip; \
    curl -sSLO http://download.joedog.org/siege/siege-latest.tar.gz; \
    tar xvzf ${TEMP_DIR}/rosa-linux.tar.gz && \
    mv rosa /usr/local/bin/rosa && \
    chmod 755 /usr/local/bin/rosa && \
    unzip ${TEMP_DIR}/awscli-exe-linux-x86_64.zip && \
    ${TEMP_DIR}/aws/install && \
    tar xvzf ${TEMP_DIR}/siege-latest.tar.gz && \
    cd $(find -name 'siege*' -type d | head -n1) && \
    ./configure && \
    make && \
    make install && \
    cd ${TEMP_DIR} && \
    bash -c ". /home/user/.sdkman/bin/sdkman-init.sh \
        && sed -i "s/sdkman_auto_answer=false/sdkman_auto_answer=true/g" /home/user/.sdkman/etc/config \
	    && sed -i "s/sdkman_auto_env=false/sdkman_auto_env=true/g" /home/user/.sdkman/etc/config \
        && sdk install quarkus \
        && sdk flush archives \
        && sdk flush temp" && \
    rm -rf ${TEMP_DIR}

USER 10001