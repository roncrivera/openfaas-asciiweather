# build stage
FROM golang:alpine AS build-env

RUN mkdir /build

RUN apk update && apk --no-cache add git

RUN go get -u github.com/schachmat/wego

WORKDIR $GOPATH/src/github.com/schachmat/wego

RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=7 go build -o /build/wego .

# final stage
FROM multiarch/alpine:armhf-v3.8

RUN mkdir -p /home/app

ENV WEGORC /home/app/.wegorc

RUN apk --no-cache add curl \
    && echo "Pulling watchdog binary from Github." \
    && curl -sSL https://github.com/openfaas/faas/releases/download/0.9.6/fwatchdog-armhf > /usr/bin/fwatchdog \
    && chmod +x /usr/bin/fwatchdog \
    && cp /usr/bin/fwatchdog /home/app \
    && apk del curl --no-cache
    
# Add non root user
RUN addgroup -S app && adduser app -S -G app

COPY wegorc /home/app/.wegorc

COPY --from=build-env /build/wego /home/app/

RUN chown -R app /home/app

WORKDIR /home/app

USER app

ENV write_debug="true"

ENV fprocess="xargs ./wego"

EXPOSE 8080

HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1

CMD [ "fwatchdog" ]
