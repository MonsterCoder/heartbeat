properties {
    $baseDir = Resolve-Path .\
    $config = "Debug"
    $srcDir = "$baseDir\Heartbeat\Heartbeat.sln"
    $VSversion = "/p:VisualStudioVersion=14.0"
    }

task -name Clean -description "Deletes all build artifacts" -action {
    exec { 
            msbuild $srcDir /t:Clean $VSversion
        }
}

task -name Build -description "Builds the outdated artifacts" -action { 
    exec { 
            msbuild $srcDir /t:Build $VSversion
        }
}

task -name default -depends Clean, Build -description "Cleans and Builds project"

