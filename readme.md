This project is based on [mattnite/zig-zlib](https://github.com/mattnite/zig-zlib). I also used [LukasKastern]([Title](https://github.com/LukasKastern/zig-zlib) fork for making project compatibile with 0.11 zig master.

There is existing deflate/gzip compressor/decompressor in zig standard library. For using it in websocket implementation I was missing ability to set window size (it is fixed on 32k) and sliding window functionality in decompressor.  
It seams that most other websocket implementations are using zlib for deflate.

### Refrences
[Compression Extensions for WebSocket](https://datatracker.ietf.org/doc/html/rfc7692)  
[zlib 1.2.13 Manual](https://www.zlib.net/manual.html)


### Notes

get zlib source into zlib folder:
```sh
wget https://github.com/madler/zlib/releases/download/v1.2.13/zlib-1.2.13.tar.gz
tar xvf zlib-1.2.13.tar.gz
rm zlib-1.2.13.tar.gz
mv zlib-1.2.13 zlib
```