# Stage 1: Build stage (if you need to compile your application or dependencies)
# Use the python base image to facilitate building of the python library
FROM python:slim AS build

# Install any required build tools or libraries for compilation
RUN apt-get update && apt-get install -y git build-essential libpython3-dev python3-venv python3-build libhidapi-dev libhidapi-hidraw0 && \
    python3 -m pip install build

# Set the working directory
WORKDIR /

RUN git clone https://github.com/darrylb123/usbrelay.git app

WORKDIR /app

# Compile the application
RUN make -C /app  
RUN make -C /app/usbrelay_py

# Stage 2: Runtime stage
FROM python:slim

COPY --from=build /app/usbrelay /usr/local/bin/usbrelay
COPY --from=build /app/usbrelayd /usr/local/sbin
COPY entrypoint.sh /entrypoint.sh
COPY --from=build /app/libusbrelay.so.1.? /usr/lib
COPY --from=build /app/usbrelay_py/dist/usbrelay_py*.whl /tmp/

RUN apt-get update && \
    apt-get install -y --no-install-recommends libhidapi-hidraw0 && \
    python3 -m pip install paho-mqtt && \
    python3 -m pip install /tmp/usbrelay_py*.whl && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /tmp/usbrelayd.conf /etc/usbrelayd.conf

ENTRYPOINT ["/entrypoint.sh"]
