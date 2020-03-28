# See: https://github.com/awslabs/aws-lambda-container-image-converter/blob/master/example/Dockerfile

####### Install and compile everything #######

# Same AL version as Lambda execution environment AMI
FROM amazonlinux:2018.03.0.20190514 as builder

# Lock to 2018.03 release (same as Lambda) and install compilation dependencies
RUN sed -i 's;^releasever.*;releasever=2018.03;;' /etc/yum.conf && \
    yum clean all && \
    yum install -y install \
        python3 \
        zip \
        gcc \
        openssl-devel \
        bzip2-devel \
        libffi-devel \
        wget \
        tar \
        gzip \
        make

WORKDIR /

# Install Python 3.8
RUN wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz && \
    tar -xzvf Python-3.8.0.tgz

WORKDIR /Python-3.8.0

RUN ./configure --enable-optimizations && \
    make install && \
    pip3 install --upgrade pip

# Install Python packages
RUN mkdir /packages && \
    echo "opencv-python" >> /packages/requirements.txt && \
    mkdir -p /packages/opencv-python-3.7/python/lib/python3.7/site-packages && \
    mkdir -p /packages/opencv-python-3.8/python/lib/python3.8/site-packages && \
    pip3 install -r /packages/requirements.txt -t /packages/opencv-python-3.7/python/lib/python3.7/site-packages && \
    pip3.8 install -r /packages/requirements.txt -t /packages/opencv-python-3.8/python/lib/python3.8/site-packages

###### Create runtime image ######

FROM lambci/lambda:provided as runtime

# Layer 1
COPY --from=builder /packages /opt