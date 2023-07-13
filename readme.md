This project is based on [mattnite/zig-zlib](https://github.com/mattnite/zig-zlib). I also used [LukasKastern]([Title](https://github.com/LukasKastern/zig-zlib) fork for making project compatibile with 0.11 zig master.

There is existing deflate/gzip compressor/decompressor in zig standard library. For using it in websocket implementation I was missing ability to set window size (it is fixed on 32k) and sliding window functionality in decompressor.  
It seams that most other websocket implementations are using zlib for deflate.

### Refrences
[Compression Extensions for WebSocket](https://datatracker.ietf.org/doc/html/rfc7692)  
[zlib 1.2.13 Manual](https://www.zlib.net/manual.html)


### Link
There is empty zig project (made with 'zig init-exe') in [example/exe](example/exe) which illustrates how to link zlib library using zig package manager.

Add dependency in build.zig.zon:
```zig
    .dependencies = .{
        .zlib = .{
            .url = "https://github.com/ianic/zig-zlib/archive/9186b0f5fdfd6c29cd04f7ada7b0113fe1f63611.tar.gz",
            .hash = "122001cc3da638f9315f08fb51fe5aace68c254b59bcac3457e20d746565bad7fe04",
        },
    },
```
In build.zig link 'z' library and 'zlib' module:
```zig
    // Link z library and zlib module.
    exe.linkLibrary(b.dependency("zlib", .{
        .target = target,
        .optimize = optimize,
    }).artifact("z"));
    exe.addModule("zlib", zlib.module("zlib"));
```


### Notes

get zlib source into zlib folder:
```sh
wget https://github.com/madler/zlib/releases/download/v1.2.13/zlib-1.2.13.tar.gz
tar xvf zlib-1.2.13.tar.gz
rm zlib-1.2.13.tar.gz
mv zlib-1.2.13 zlib
```