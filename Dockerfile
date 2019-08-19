FROM golang AS builder

COPY . /app
WORKDIR /app
RUN CGO_ENABLED=0 go build -o simple-server source/main.go

FROM scratch

ENV DIRECTORY=/static
ENV PORT=3000

# to be able to deploy on heroku, we put the binary where /bin/sh
# should be.
COPY --from=builder /app/simple-server /bin/sh

CMD ["/bin/sh"]
