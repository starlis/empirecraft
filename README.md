# EmpireCraft
## What
EmpireCraft is a fork of [Paper](https://github.com/PaperMC/Paper) used by the [Empire Minecraft](https://ref.emc.gs/Aikar?gam=EmpireCraft) Server.

It contains many gameplay changes to suit our server and some potential performance improvements to be contributed back to Paper.

We also have many APIs that we privately use but [may choose not to](#why-we-dont-release-all-apis) publicly PR upstream.

## Why we don't release all APIs
APIs are tough to design. In public projects such as Bukkit, Spigot, Paper, etc., once an API is commited, it's almost forever. You can't go breaking it without solid justification. This is the politics game.

With that in mind, much thought has to be given to our APIs in current and future use cases and applications to ensure it can be extended without breaking. 

This is a lot of politics that we don't have time in our lives to deal with.

Therefore, we write APIs to OUR base needs, which is often not 'complete' or 'up to style guidelines' of upstream repositories. We do not have the time to write code that we personally do not need for these APIs.

We also want to retain the ability to make breaking changes to these APIs if it results in a better way to do things or performance improvements.

By contributing it upstream, we would give up that power.

So that is why we have many extremely useful APIs that are not PR'd upstream. Several APIs may find their way upstream at some point.

## License, Support, & Usage of Patches
All patches written by Aikar, Starlis LLC, and/or Contractors of Starlis LLC that are included within EmpireCraft are licensed MIT, and are free to be used in your own fork.

We offer __ABSOLUTELY NO SUPPORT__ for these patches. If you wish to use them, you must take the effort to extract them from our repo, apply them to your own, and repair any code changes to get it to compile.

If we make any breaking changes, and you still wish to use these patches, it's your job to fix the changes!

So in summary, we love to share! Use anything we wrote in this repo how ever you please, but support it yourself :)

See [PaperMC/Paper](https://github.com/PaperMC/Paper), and [PaperMC/Paperweight](https://github.com/PaperMC/paperweight) for the license of material used by this project.

## OS Support & Scripts
We only directly support the latest LTS Ubuntu for shell scripts. It may work elsewhere... but no promises.

Some scripts may try to push to our repos, please change that if you fork :)

## API

### Dependency Information
Maven
```xml
<dependency>
    <groupId>com.empireminecraft.empirecraft</groupId>
    <artifactId>empirecraft-api</artifactId>
    <version>1.21.11-R0.1-SNAPSHOT</version>
    <scope>provided</scope>
</dependency>
```

Gradle
```kotlin
dependencies {
    compileOnly("com.empireminecraft.empirecraft:empirecraft-api:1.21.11-R0.1-SNAPSHOT")
}
```

We do not currently have a publicly available repository at this time. one would need to compile and publish locally as needed.

## Building and setting up

#### Initial setup
First, <u>clone</u> this repository. Do not download it.

Then run the following command in the root directory:

```
./gradlew applyAllPatches
```

The project is now ready for use in your IDE.

#### Creating a patch

See [CONTRIBUTING.md](CONTRIBUTING.md).

#### Compiling

Use the command `./gradlew build` to build the API and server. Compiled JARs
will be placed under `empirecraft-api/build/libs` and `empirecraft-server/build/libs`.
**These JARs are not used to start a server.**

To compile a server-ready bundler jar, run `./gradlew createMojmapBundlerJar`.
To install the `empirecraft-api` and `empirecraft` dependencies to your local Maven repo, run `./gradlew publishToMavenLocal`. The compiled bundler jar will be in `empirecraft-server/build/libs`.