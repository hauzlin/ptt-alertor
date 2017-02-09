FROM buildpack-deps:jessie-scm

# gcc for cgo
RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
	&& rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.7.5
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 2e4dd6c44f0693bef4e7b46cc701513d74c3cc44f2419bf519d7868b12931ac3

RUN curl -kfsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV GOPATH /go/
ENV GO_WORKDIR github.com/liam-lai/ptt-alertor/
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY docker_golang_1.7/go-wrapper /usr/local/bin/
ADD . "$GOPATH"/src/"$GO_WORKDIR"

RUN go get "$GO_WORKDIR"
RUN go install "$GO_WORKDIR"
#RUN sh "$GOPATH"/src/"$GO_WORKDIR"/.codecov_docker.sh

# Run the outyet command by default when the container starts.
ENTRYPOINT /go/bin/ptt-alertor

# Document that the service listens on port 9090.
EXPOSE 9090
