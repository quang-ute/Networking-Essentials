FROM ubuntu:22.04
RUN apt-get update && apt-get install -y curl tshark tcpdump && \
    rm -rf /var/lib/apt/lists/*
CMD ["bash"]