
# 多环境配置

```shell script
gradle -PbuildProfile=test greeting
```

```groovy
if (!hasProperty('buildProfile')) ext.buildProfile = 'default'  

apply from: "profile-${buildProfile}.gradle"  

task greeting {
    doLast {
        println message  
    }
}
```
