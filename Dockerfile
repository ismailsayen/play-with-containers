FROM alpine:latest

RUN apk update && \
    apk add --no-cache bash postgresql postgresql-contrib

COPY ./scripts/InitPgDb.sh /script.sh

ENTRYPOINT [ "/script.sh" ]

