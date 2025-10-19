# tugaspraktikum3

A new Flutter project.

experimen ui font tampilan dan animasi dengan flutter

dengan optimisasi dari gpt biar ga lag

| Area                                       | Optimalisasi             | Efek                |
| ------------------------------------------ | ------------------------ | ------------------- |
| `const` widgets                            | Menambah cache UI statis | Lebih cepat rebuild |
| `RepaintBoundary`                          | Isolasi animasi berat    | FPS lebih stabil    |
| Kurangi blur shadow                        | GPU hemat                | Render lebih ringan |
| `late final` animation controller          | Lebih efisien di memori  | Tidak alokasi ulang |
| Dispose controller & TextEditingController | Mencegah memory leak     | Aman di hot reload  |
