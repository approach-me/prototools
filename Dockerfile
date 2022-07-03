FROM golang:1.18.3 AS protocbuilder

RUN apt-get update && \
    apt-get install -y -q unzip && \ 
    apt-get clean && \
    mkdir -p /tmp/protoc && \
    cd /tmp/protoc && \
    curl -L https://github.com/google/protobuf/releases/download/v3.2.0/protoc-3.2.0-linux-x86_64.zip > protoc.zip && \
    unzip protoc.zip && \
    cp /tmp/protoc/bin/protoc /usr/local/bin && \
    curl -L https://github.com/grpc/grpc-web/releases/download/1.3.1/protoc-gen-grpc-web-1.3.1-linux-x86_64 > protoc-gen-grpc-web && \
    cp /tmp/protoc/protoc-gen-grpc-web /usr/local/bin && \
    cd /tmp && \
    rm -r /tmp/protoc && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2 && \
    cp /go/bin/* /usr/local/bin

FROM bitnami/git:2.37.0

COPY --from=protocbuilder /usr/local/bin /usr/local/bin
