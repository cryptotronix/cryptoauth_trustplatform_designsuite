FROM python:3.7

COPY . /root/cryptoauth_trustplatform_designsuite

RUN apt update && apt install -y -q \
    libusb-1.0-0-dev \
    libudev-dev \
    cmake

RUN pip install hidapi cryptography

WORKDIR /root/cryptoauth_trustplatform_designsuite/assets/dependencies/cryptoauthlib
RUN mkdir build && \
    cd build && \
    cmake -DATCA_HAL_KIT_HID=1 -DATCA_HAL_I2C=1 -DATCA_HAL_CUSTOM=1 .. && \
    make && \
    cp lib/libcryptoauth.so /usr/lib/

WORKDIR /root/cryptoauth_trustplatform_designsuite/assets/dependencies/cryptoauthlib/python
RUN python setup.py install

ENV PYTHONPATH="/root/cryptoauth_trustplatform_designsuite/assets/python:${PYTHONPATH}"

WORKDIR /root/
CMD ["python"]