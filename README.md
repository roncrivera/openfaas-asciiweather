# openfaas-asciiweather

This repo contains the artifacts required to convert the `wego` weather client from [Markus Teich](https://github.com/schachmat/wego) into an [OpenFaaS](https://www.openfaas.com) serverless function.

## Prerequisites

* API key from  [OpenWeatherMap](https://openweathermap.org/api)
* [Docker Hub](http://hub.docker.com) account
* [OpenFaaS](https://docs.openfaas.com/deployment/) cluster
* [faas-cli](https://docs.openfaas.com/cli/install/) installed

## Setup

### Clone the function repo

```
$ git clone https://github.com/roncrivera/openfaas-asciiweather \
    && cd openfaas-asciiweather
```

Commands from this point forward will assume that you are in the `openfaas-asciiweather` directory.

### Update wego config file

Open up the `wegorc` file and update with your OWM API key, e.g.

```
$ grep YOUR_OPENWEATHERMAP_API_KEY_HERE asciiweather/wegorc
owm-api-key=YOUR_OPENWEATHERMAP_API_KEY_HERE
```

## Build/Push/Deploy

Build the function inside a Docker image.

```
$ faas-cli build -f asciiweather.yml

```

Push the image to your Docker repository.

* Remember to `docker login` first.

```
$ faas-cli push -f asciiweather.yml
```


Deploy function to the OpenFaas cluster.

```
$ faas-cli deploy -f asciiweather.yml
Deploying: asciiweather.

Deployed. 202 Accepted.
URL: http://gateway.openfaas.labs.roncrivera.io:31112/function/asciiweather
```

Verify that function is deployed.

```
$ faas-cli list
Function                      	Invocations    	Replicas
asciiweather                  	13             	1
certinfo                      	4              	1
nodeinfo                      	13             	1
```

## Testing

Invoke the asciiweather function.

```
$ echo | faas-cli invoke asciiweather
Weather for Sydney, AU

               overcast clouds
      .--.     23 – 25 °C
   .-(    ).   ↙ 2 km/h
  (___.__)__)
               0.0 mm/h
                                                       ┌─────────────┐
┌──────────────────────────────┬───────────────────────┤ Sun 30. Dec ├───────────────────────┬──────────────────────────────┐
│           Morning            │             Noon      └──────┬──────┘    Evening            │            Night             │
├──────────────────────────────┼──────────────────────────────┼──────────────────────────────┼──────────────────────────────┤
│               overcast clouds│               overcast clouds│               broken clouds  │               broken clouds  │
│      .--.     23 – 25 °C     │      .--.     23 – 25 °C     │      .--.     22 – 24 °C     │      .--.     22 – 23 °C     │
│   .-(    ).   ↙ 2 km/h      │   .-(    ).   ↙ 2 km/h      │   .-(    ).   ← 3 km/h       │   .-(    ).   ↖ 2 km/h      │
│  (___.__)__)                 │  (___.__)__)                 │  (___.__)__)                 │  (___.__)__)                 │
│               0.0 mm/h       │               0.0 mm/h       │               0.0 mm/h       │               0.0 mm/h       │
└──────────────────────────────┴──────────────────────────────┴──────────────────────────────┴──────────────────────────────┘
                                                       ┌─────────────┐
┌──────────────────────────────┬───────────────────────┤ Mon 31. Dec ├───────────────────────┬──────────────────────────────┐
│           Morning            │             Noon      └──────┬──────┘    Evening            │            Night             │
├──────────────────────────────┼──────────────────────────────┼──────────────────────────────┼──────────────────────────────┤
│               overcast clouds│  _`/"".-.     light rain     │  _`/"".-.     light rain     │    \  /       few clouds     │
│      .--.     26 °C          │   ,\_(   ).   22 °C          │   ,\_(   ).   20 °C          │  _ /"".-.     22 °C          │
│   .-(    ).   ← 5 km/h       │    /(___(__)  ↗ 4 km/h      │    /(___(__)  ↘ 7 km/h      │    \_(   ).   ↓ 4 km/h       │
│  (___.__)__)                 │      ʻ ʻ ʻ ʻ                 │      ʻ ʻ ʻ ʻ                 │    /(___(__)                 │
│               0.0 mm/h       │     ʻ ʻ ʻ ʻ   0.2 mm/h       │     ʻ ʻ ʻ ʻ   0.0 mm/h       │               0.0 mm/h       │
└──────────────────────────────┴──────────────────────────────┴──────────────────────────────┴──────────────────────────────┘
                                                       ┌─────────────┐
┌──────────────────────────────┬───────────────────────┤ Tue 01. Jan ├───────────────────────┬──────────────────────────────┐
│           Morning            │             Noon      └──────┬──────┘    Evening            │            Night             │
├──────────────────────────────┼──────────────────────────────┼──────────────────────────────┼──────────────────────────────┤
│  _`/"".-.     light rain     │     \   /     clear sky      │    \  /       few clouds     │  _`/"".-.     light rain     │
│   ,\_(   ).   25 °C          │      .-.      23 °C          │  _ /"".-.     21 °C          │   ,\_(   ).   22 °C          │
│    /(___(__)  ← 5 km/h       │   ‒ (   ) ‒   ← 5 km/h       │    \_(   ).   ↑ 4 km/h       │    /(___(__)  ↗ 4 km/h      │
│      ʻ ʻ ʻ ʻ                 │      `-᾿                     │    /(___(__)                 │      ʻ ʻ ʻ ʻ                 │
│     ʻ ʻ ʻ ʻ   0.3 mm/h       │     /   \     0.0 mm/h       │               0.0 mm/h       │     ʻ ʻ ʻ ʻ   0.0 mm/h       │
└──────────────────────────────┴──────────────────────────────┴──────────────────────────────┴──────────────────────────────┘
```

The default location is currently set to 'Sydney,AU'.

To check a different location

```
$ echo -n '-l=london,uk' | faas-cli invoke asciiweather
Weather for London, GB

  _`/"".-.     light rain
   ,\_(   ).   9 – 9 °C
    /(___(__)  → 10 km/h
      ʻ ʻ ʻ ʻ
     ʻ ʻ ʻ ʻ   0.0 mm/h
                                                       ┌─────────────┐
┌──────────────────────────────┬───────────────────────┤ Sun 30. Dec ├───────────────────────┬──────────────────────────────┐
│           Morning            │             Noon      └──────┬──────┘    Evening            │            Night             │
├──────────────────────────────┼──────────────────────────────┼──────────────────────────────┼──────────────────────────────┤
│  _`/"".-.     light rain     │  _`/"".-.     light rain     │  _`/"".-.     light rain     │  _`/"".-.     light rain     │
│   ,\_(   ).   9 – 9 °C       │   ,\_(   ).   9 – 9 °C       │   ,\_(   ).   8 – 9 °C       │   ,\_(   ).   8 – 8 °C       │
│    /(___(__)  → 10 km/h      │    /(___(__)  → 10 km/h      │    /(___(__)  → 10 km/h      │    /(___(__)  → 10 km/h      │
│      ʻ ʻ ʻ ʻ                 │      ʻ ʻ ʻ ʻ                 │      ʻ ʻ ʻ ʻ                 │      ʻ ʻ ʻ ʻ                 │
│     ʻ ʻ ʻ ʻ   0.0 mm/h       │     ʻ ʻ ʻ ʻ   0.0 mm/h       │     ʻ ʻ ʻ ʻ   0.0 mm/h       │     ʻ ʻ ʻ ʻ   0.0 mm/h       │
└──────────────────────────────┴──────────────────────────────┴──────────────────────────────┴──────────────────────────────┘
                                                       ┌─────────────┐
┌──────────────────────────────┬───────────────────────┤ Mon 31. Dec ├───────────────────────┬──────────────────────────────┐
│           Morning            │             Noon      └──────┬──────┘    Evening            │            Night             │
├──────────────────────────────┼──────────────────────────────┼──────────────────────────────┼──────────────────────────────┤
│  _`/"".-.     light rain     │  _`/"".-.     light rain     │  _`/"".-.     light rain     │  _`/"".-.     light rain     │
│   ,\_(   ).   7 °C           │   ,\_(   ).   8 °C           │   ,\_(   ).   7 °C           │   ,\_(   ).   6 °C           │
│    /(___(__)  → 9 km/h       │    /(___(__)  → 10 km/h      │    /(___(__)  → 12 km/h      │    /(___(__)  → 12 km/h      │
│      ʻ ʻ ʻ ʻ                 │      ʻ ʻ ʻ ʻ                 │      ʻ ʻ ʻ ʻ                 │      ʻ ʻ ʻ ʻ                 │
│     ʻ ʻ ʻ ʻ   0.0 mm/h       │     ʻ ʻ ʻ ʻ   0.0 mm/h       │     ʻ ʻ ʻ ʻ   0.0 mm/h       │     ʻ ʻ ʻ ʻ   0.0 mm/h       │
└──────────────────────────────┴──────────────────────────────┴──────────────────────────────┴──────────────────────────────┘
                                                       ┌─────────────┐
┌──────────────────────────────┬───────────────────────┤ Tue 01. Jan ├───────────────────────┬──────────────────────────────┐
│           Morning            │             Noon      └──────┬──────┘    Evening            │            Night             │
├──────────────────────────────┼──────────────────────────────┼──────────────────────────────┼──────────────────────────────┤
│  _`/"".-.     light rain     │  _`/"".-.     light rain     │  _`/"".-.     light rain     │  _`/"".-.     light rain     │
│   ,\_(   ).   7 °C           │   ,\_(   ).   8 °C           │   ,\_(   ).   9 °C           │   ,\_(   ).   4 °C           │
│    /(___(__)  ↘ 13 km/h     │    /(___(__)  ↘ 15 km/h     │    /(___(__)  ↓ 14 km/h      │    /(___(__)  ↓ 13 km/h      │
│      ʻ ʻ ʻ ʻ                 │      ʻ ʻ ʻ ʻ                 │      ʻ ʻ ʻ ʻ                 │      ʻ ʻ ʻ ʻ                 │
│     ʻ ʻ ʻ ʻ   0.0 mm/h       │     ʻ ʻ ʻ ʻ   0.0 mm/h       │     ʻ ʻ ʻ ʻ   0.0 mm/h       │     ʻ ʻ ʻ ʻ   0.0 mm/h       │
└──────────────────────────────┴──────────────────────────────┴──────────────────────────────┴──────────────────────────────┘
```

## Acknowledgments

Kudos to Alex Ellis and the OpenFaaS community for this amazing piece of work.

