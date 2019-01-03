#!/bin/sh

OWMAPIKEY=$(cat /var/openfaas/secrets/owm-api-key)

exec ./wego -b openweathermap -owm-api-key $OWMAPIKEY "$@"
