[![Build Status - Master](https://travis-ci.org/evolution-app/backend.svg?branch=develop)](https://travis-ci.org/unnamedd/swift-evolution-backend)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)

# Evolution App - Backend

This repository contains the backend for frontend (BFF) component that supports the [Evolution App - iOS](https://itunes.apple.com/us/app/evolution-app/id1210898168?mt=8), an app to help you to follow [proposals from Swift Evolution](https://apple.github.io/swift-evolution/) on your iOS device. This BFF component is written in the [Swift](https://swift.org/) programming language and leverages the [Kitura](http://www.kitura.io/) web framework from **[IBM](https://github.com/IBM-Swift)**.

Please note that this BFF component is still undergoing development; we are currently working on the deliverables for a first release. Stay tuned for updates!

## Dependencies

- [Swift 3.1.1](https://swift.org)

## Recommended utilities

- [SwiftEnv](https://swiftenv.fuller.li)
- [Xcode](https://developer.apple.com/xcode/) (if you are using macOS)

## Build and run

```shell
$ git clone -b develop https://github.com/evolution-app/backend
$ cd backend
$ swift run

[2017-06-23T14:07:16.626-03:00] [INFO] [main.swift:11 Server] Server will be started on 'http://localhost:8080'.
[2017-06-23T14:07:16.631-03:00] [INFO] [HTTPServer.swift:104 listen(on:)] Listening on port 8080
```

Using your browser, you can now access the landing page of the BFF component at [http://localhost:8080](http://localhost:8080).

## Generate Xcode Project

```shell
$ swift package generate-xcodeproj
```

## Bluemix toolchain

This BFF component can be deployed to the IBM Cloud using a Bluemix Toolchain. Any required services will be automatically provisioned, once, during the deployment stage.

[![Create Toolchain](https://console.ng.bluemix.net/devops/graphics/create_toolchain_button.png)](https://console.ng.bluemix.net/devops/setup/deploy/)


## Authors

- Taylor Franklin - [GitHub](https://github.com/tfrank64)
- Thiago Holanda - [GitHub](https://github.com/unnamedd) / [Twitter](https://twitter.com/tholanda)
- Ricardo Olivieri - [GitHub](https://github.com/rolivieri)


## License

**Evolution App - Backend** is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
