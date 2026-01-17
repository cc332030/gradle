
fun getConfigValue(key: String): String? {

    val value = System.getProperty(key)
    if(!value.isNullOrEmpty()) {
        return value
    }
    return System.getenv(key)
}

// before settings.gradle.kts
beforeSettings {

    dependencyResolutionManagement {

        repositories {

            val mavenCentralUrl = getConfigValue("MAVEN_CENTRAL")
            val nexusUsername = getConfigValue("NEXUS_USERNAME")
            val nexusPassword = getConfigValue("NEXUS_PASSWORD")
            val nexusSnapshotUrl = getConfigValue("NEXUS_SNAPSHOT_URL")
            val nexusReleaseUrl = getConfigValue("NEXUS_RELEASE_URL")

            mavenLocal()

            if (!mavenCentralUrl.isNullOrEmpty()) {
                println("apply mavenCentralUrl: $mavenCentralUrl")
                maven {
                    url = uri(mavenCentralUrl)
                }
            }

            if (!nexusSnapshotUrl.isNullOrEmpty()) {
                println("apply nexusSnapshotUrl: $nexusSnapshotUrl")
                maven {
                    url = uri(nexusSnapshotUrl)
                    credentials {
                        username = nexusUsername
                        password = nexusPassword
                    }
                }
            }

            if (!nexusReleaseUrl.isNullOrEmpty()) {
                println("apply nexusReleaseUrl: $nexusReleaseUrl")
                maven {
                    url = uri(nexusReleaseUrl)
                    credentials {
                        username = nexusUsername
                        password = nexusPassword
                    }
                }
            }

            mavenCentral()
            gradlePluginPortal()

        }
    }
}

// before build.gradle.kts
initscript {

}
