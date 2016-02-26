properties {
    $baseDir = Resolve-Path .\
    $config = "Debug"
    $srcDir = "$baseDir\Heartbeat\Heartbeat.sln"
    $packagesDir = "$baseDir\Heartbeat\packages\"
    $VSversion = "/p:VisualStudioVersion=14.0"
    }

task -name PackageRestore -description "Restores nuget packages" -action {
    exec {
            nuget.exe restore $srcDir
        }
}

task -name Clean -depends PackageRestore -description "Deletes all build artifacts" -action {
    exec { 
            msbuild $srcDir /t:Clean $VSversion
           # remove-item $packagesDir -recurse -ErrorAction Ignore
        }
}

task -name Build -description "Builds the outdated artifacts" -action { 
    exec { 
            msbuild $srcDir /t:Build $VSversion
        }
}

task -name default -depends Clean, Build -description "Cleans and Builds project"

