![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)

# Swift Evolution - Backend

This repository contains the backend for frontend (BFF) component that supports the iOS [Evolution](https://itunes.apple.com/us/app/evolution-app/id1210898168?mt=8) app. This BFF component is written in the [Swift](https://swift.org/) programming language and leverages the [Kitura](http://www.kitura.io/) web framework from **IBM**.

Please note that this BFF component is still undergoing development; we are currently working on the deliverables for a first release. Stay tuned for updates!

## Dependencies

- [Swift 3.1.1](https://swift.org)

## Recommended utilities

- [SwiftEnv](https://swiftenv.fuller.li)
- [Xcode](https://developer.apple.com/xcode/) (if you are using macOS)

## Build and run

```shell
$ git clone -b develop https://github.com/unnamedd/swift-evolution-backend
$ cd swift-evolution-backend
$ swift build
$ ./.build/debug/Server

[2017-06-23T14:07:16.626-03:00] [INFO] [main.swift:11 Server] Server will be started on 'http://localhost:8080'.
[2017-06-23T14:07:16.631-03:00] [INFO] [HTTPServer.swift:104 listen(on:)] Listening on port 8080
```

Using your browser, you can now access the landing page of the BFF component at [http://localhost:8080](http://localhost:8080).

## Generate Xcode Project

```shell
$ swift package generate-xcodeproj
```

## Bluemix toolchain

It will be possible soon to deploy this BFF component to Bluemix using a Bluemix Toolchain (**work in progress**). Any required services will be automatically provisioned, once, during toolchain creation.

[![Create Toolchain](https://console.ng.bluemix.net/devops/graphics/create_toolchain_button.png)](https://console.ng.bluemix.net/devops/setup/deploy/)


## Authors

- Taylor Franklin - [GitHub](https://github.com/tfrank64)
- Thiago Holanda - [GitHub](https://github.com/unnamedd) / [Twitter](https://twitter.com/tholanda)
- Ricardo Olivieri - [GitHub](https://github.com/rolivieri)


## License

**Swift Evolution - Backend** is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
