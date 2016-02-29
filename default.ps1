properties {
    $config = "Debug"
    $baseDir = Resolve-Path .\
    $srcDir = "$baseDir\Heartbeat"
    $buildDir = "$baseDir\build\"
    $slnFile = "$srcDir\Heartbeat.sln"
    $packagesDir = "$srcDir\packages\"
    $VSversion = "/p:VisualStudioVersion=14.0"
    $unitTestAssembly = "$srcDir\UnitTests\bin\$config\UnitTests.dll"
    $nunitPath = "$packagesDir\NUnit.Console.3.0.1\tools"
    }

task -name PackageRestore -description "Restores nuget packages" -action {
    exec {
            .\tools\nuget.exe restore $slnFile
        }
}

task -name Clean -depends PackageRestore -description "Deletes all build artifacts" -action {
    exec {
            msbuild $slnFile /t:Clean $VSversion
           # remove-item $packagesDir -recurse -ErrorAction Ignore
        }
}

task -name Build -description "Builds the outdated artifacts" -action {
    exec {
            msbuild $slnFile /t:Build $VSversion
        }
}

task -name Test -depends Build -description "Run all tests" {
    msbuild $slnFile /m /p:Configuration=$config /t:Build $VSversion
    exec {
        & $nunitPath\nunit3-console.exe $unitTestAssembly /result=$buildDir\UnitTestResult.xml
    }
    
}
task -name default -depends Clean, Build, Test -description "Cleans and Builds project"
