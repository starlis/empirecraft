pluginManagement {
    repositories {
        gradlePluginPortal()
		maven("https://papermc.io/repo/repository/maven-public/")
    }
}

rootProject.name = "EmpireCraft"
include("EmpireCraft-API", "EmpireCraft-Server")
