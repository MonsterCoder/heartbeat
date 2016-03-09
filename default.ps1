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
            msbuild $slnFile /t:Build /p:RunOctoPack=true /p:OctoPackPublishPackageToFileShare=$buildDir $VSversion
        }
}

task -name Test -depends Build -description "Run all tests" {
    msbuild $slnFile /m /p:Configuration=$config /t:Build $VSversion
    exec {
        & $nunitPath\nunit3-console.exe $unitTestAssembly /result=$buildDir\UnitTestResult.xml
    }
    
}

task -name Init -description "Resets the build folder for a fresh build" -action {
    exec {
            delete_directory $buildDir
            create_directory $buildDir
        }
}

task -name default -depends Init, Clean, Test -description "Cleans and Builds project"

function global:create_directory($directory_name)
{
  mkdir $directory_name  -ErrorAction SilentlyContinue  | out-null
}

function global:delete_directory($directory_name)
{
  rd $directory_name -recurse -force  -ErrorAction SilentlyContinue | out-null
}