ARG BASE_ARCH=amd64
ARG BASE_TAG=alpine

FROM ${BASE_ARCH}/golang:${BASE_TAG} AS builder

ENV CGO_ENABLED=0
ENV GOOS=linux

COPY . /app
WORKDIR /app
RUN go build -o simple-server source/main.go

FROM scratch

ENV DIRECTORY=/static
ENV PORT=3000

# to be able to deploy on heroku, we put the binary where /bin/sh
# should be.
COPY --from=builder /app/simple-server /bin/sh

CMD ["/bin/sh"]
