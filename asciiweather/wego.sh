#!/bin/sh

OWMAPIKEY=$(cat /var/openfaas/secrets/owm-api-key)

exec ./wego -aat-monochrome=true -b openweathermap -owm-api-key $OWMAPIKEY "$@"
