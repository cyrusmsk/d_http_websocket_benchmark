# WebSocket benchmark

This benchmark provides some comparison of `D` websocket implementations.

The comparison itself is pretty simple.
It is based on the [post of Daniel Lemire](https://lemire.me/blog/2023/11/28/a-simple-websocket-benchmark-in-python/).
Initial post's code is making a comparison of `Python` with `Node.js`.

This repo extended `Python` examples and added `D` implementations.

To have a better picture also popular websocket framework from `Go` was added.

## D results
### Vibe.d (1 worker):
rate:  4123.4236018057345  round trips per second

rate:  4143.415433476453  round trips per second

rate:  4152.797289427844  round trips per second

### Arsd CGI:
rate:  9240.015232715543  round trips per second

rate:  9268.835330306563  round trips per second

rate:  9285.041683937668  round trips per second

## Go results
### Melody
rate:  9845.522229868968  round trips per second

rate:  9938.15268126995  round trips per second

rate:  9955.625844117649  round trips per second

## Python results
### Aiohttp:
rate:  6246.744898402702  round trips per second

rate:  6261.469272644013  round trips per second

rate:  6265.500787059558  round trips per second

### Sanic (1 worker):
rate:  4234.844128967857  round trips per second

rate:  4236.69987610743  round trips per second

rate:  4235.844189755944  round trips per second

### Blacksheep (1 worker):
rate:  4383.465767249981  round trips per second

rate:  4371.725258520548  round trips per second

rate:  4384.079704053213  round trips per second

### FastAPI (1 worker):
rate:  4398.975004456969  round trips per second

rate:  4382.471478259602  round trips per second

rate:  4386.621046771637  round trips per second

## Possible improvements
[ ] Add `C++` frameworks

[ ] Add `Rust` frameworks

[ ] Add more sophisticated tests

## References
[C++ framework](https://github.com/oatpp/benchmark-websocket)

[Rust framework](https://c410-f3r.github.io/thoughts/the-fastest-websocket-implementation/)

[More advanced test](https://matttomasetti.medium.com/websocket-performance-comparison-10dc89367055)
