# adidas-challenge

## Running the App
- Start the local server with `docker-compose`
- Open `AdidasChallenge.xcworkspace` and wait for SPM to resolve its packages
- Run the `App` target 
- **Note:** `App` is also the target for running unit and snapshot tests.

## Design Choices
### Repository
The `Repository` module is currently working as a Facade, because it's just a simpler interface for performing requests. 
In case we implemented a persistency system, for example, its actions would also be implemented in that module.
It can still be seen as a repository, though, since it has a single instance in `LightInjection`'s dependency container.

### Interface modules
The decision to implement Core modules with its "Interface" counterparts was made to reduce iOS build time.
A more detailed explanation on how it works [can be found here](https://swiftrocks.com/reducing-ios-build-times-by-using-interface-targets).

