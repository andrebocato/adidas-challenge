# adidas-challenge

## Running the App
- Start the local server with `docker-compose`
- Open `AdidasChallenge.xcworkspace` and wait for SPM to resolve its packages
- Run the `App` target 
- **Notes:**
  - `App` is also the target for running unit and snapshot tests.
  - The snapshots were recorded in an iPhone 11, with iOS 14.5
  - The full working code is in [the development branch](https://github.com/andrebocato/adidas-challenge/tree/dev)

## Design Choices
### Repository
The `Repository` module is currently working as a Facade, because it's just a simpler interface for performing requests. 
In case we implemented a persistency system, for example, its actions would also be implemented in that module.
It can still be seen as a repository, though, since it has a single instance in `LightInjection`'s dependency container.

### Interface modules
The decision to implement Core modules with its "Interface" counterparts was made to reduce iOS build time.
A more detailed explanation on how it works [can be found here](https://swiftrocks.com/reducing-ios-build-times-by-using-interface-targets).

## How does the app look?

### AppIcon  
![WhatsApp Image 2021-05-03 at 10 49 41](https://user-images.githubusercontent.com/45316574/116885217-06db2480-abfe-11eb-9c67-85efe83e8f3c.jpeg)

### Screens
![Simulator Screen Shot - iPhone 11 - 2021-05-03 at 10 59 45](https://user-images.githubusercontent.com/45316574/116885858-bf08cd00-abfe-11eb-8cf3-dad89d870f1b.png)
![Simulator Screen Shot - iPhone 11 - 2021-05-03 at 11 01 48](https://user-images.githubusercontent.com/45316574/116886108-0beca380-abff-11eb-9ebd-85a601bbdcfb.png)
![Simulator Screen Shot - iPhone 11 - 2021-05-03 at 11 02 48](https://user-images.githubusercontent.com/45316574/116886215-2e7ebc80-abff-11eb-9fc7-75c348039be3.png)
![Simulator Screen Shot - iPhone 11 - 2021-05-03 at 10 48 08](https://user-images.githubusercontent.com/45316574/116886311-4f471200-abff-11eb-9c63-9ae9603c797d.png)
![Simulator Screen Shot - iPhone 11 - 2021-05-03 at 11 04 46](https://user-images.githubusercontent.com/45316574/116886417-6ede3a80-abff-11eb-9e45-d501236acc97.png)
