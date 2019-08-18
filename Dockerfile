FROM golang AS builder

COPY . /app
WORKDIR /app
RUN CGO_ENABLED=0 go build -o simple-server source/main.go

FROM scratch

ENV DIRECTORY=/static
ENV PORT=3000

COPY --from=builder /app/simple-server /simple-server

CMD ["/simple-server"]
