# WebSocket benchmark

This benchmark provides some comparison of `D` websocket implementations.

The comparison itself is pretty simple.
It is based on the [post of Daniel Lemire](https://lemire.me/blog/2023/11/28/a-simple-websocket-benchmark-in-python/).
Initial post's code is making a comparison of `Python` with `Node.js`.

This repo extended `Python` examples and added `D` implementations.

To have a better picture also popular websocket framework from `Go` was added.

## With Python client
![plot](https://raw.githubusercontent.com/cyrusmsk/d_http_websocket_benchmark/refs/heads/main/output/plot_py_data.png)

## With D client
![plot](https://raw.githubusercontent.com/cyrusmsk/d_http_websocket_benchmark/refs/heads/main/output/plot_d_data.png)


## Possible improvements
[ ] Add `C++` frameworks

[ ] Add `Rust` frameworks

[ ] Add more sophisticated tests

[x] Faster client

[x] Add plotting

## References
[C++ framework](https://github.com/oatpp/benchmark-websocket)

[Rust framework](https://c410-f3r.github.io/thoughts/the-fastest-websocket-implementation/)

[More advanced test](https://matttomasetti.medium.com/websocket-performance-comparison-10dc89367055)
