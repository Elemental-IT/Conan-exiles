<#
.SYNOPSIS
    This script modifies the Engine.ini file for Conan Exiles to enable or disable the PVP meta video settings.

.DESCRIPTION
    The script checks if there is text after line 12 in the Engine.ini file. If there is, it removes it.
    If there isn't, it adds a specified string at line 12. This allows toggling the PVP meta video settings
    by modifying or adding the appropriate lines in the configuration file.

.PARAMETER $Path
    The path to the Engine.ini file.

.PARAMETER $Drive
    the drive 

.EXAMPLE
    & .\ModifyEngineIni.ps1 


    Author Theo bird (Bedlem55)
#>

$volumes = Get-Volume

$driveLetters = @()
$Enginepath = ''
$SysSteamPath = ":\Program Files (x86)\steam\SteamLibrary\steamapps\common\Conan Exiles\ConanSandbox\Saved\Config\WindowsNoEditor\Engine.ini"
$SteamLibraryPath = ":\SteamLibrary\steamapps\common\Conan Exiles\ConanSandbox\Saved\Config\WindowsNoEditor\Engine.ini"

# Loop through each volume and add the drive letter to the array
foreach ($volume in $volumes) {
     if ($volume.DriveLetter) {
         $driveLetters += "$($volume.DriveLetter)"
     }
 }

 
foreach($Drive in $driveLetters){

    if (Get-ChildItem -Path "$Drive$SysSteamPath" -ErrorAction SilentlyContinue )
    {$Global:Enginepath = (Get-ChildItem -Path "$Drive$SysSteamPath").FullName}

        else {
        if (Get-ChildItem -Path "$Drive$SteamLibraryPath " -ErrorAction SilentlyContinue )
        {$Global:Enginepath = (Get-ChildItem -Path "$Drive$SteamLibraryPath").FullName}
    }  
}

$String = @'
[SystemSettings]
r.Fog=0
r.BloomQuality=0

[/Script/Engine.RendererOverrideSettings]
grass.heightScale=0

[/script/engine.localplayer]
ParticleLODBias=0


[/script/engine.renderersettings]
r.DefaultFeature.Bloom=False
r.DefaultFeature.AmbientOcclusion=False
r.DefaultFeature.AutoExposure=False
r.DefaultFeature.MotionBlur=False
r.DefaultFeature.LensFlare=False
r.DefaultFeature.DepthOfField=False
r.DefaultFeature.AmbientOcclusionStaticFraction=False
r.DefaultFeature.AntiAliasing=0
r.SeparateTranslucency=False
r.SeparateTranslucency=0
r.MotionBlurQuality=0
r.BloomQuality=0
r.DepthOfFieldQuality=0
r.SSR.Quality=0
r.SSS.Scale=0
r.SSS.SampleSet=0
r.DetailMode=0
r.LensFlareQuality=0
r.MaxAnisotropy=4
r.oneframethreadlag=1
r.LightShaftQuality=0
r.RefractionQuality=0
r.ExposureOffset=0.3
r.ReflectionEnvironment=0
r.Atmosphere=0
r.UpsampleQuality=0
r.TrueSkyQuality=3
r.Fog=0
grass.densityScale=0
grass.heightScale=0.01
foliage.DensityScale=0
foliage.LODDistanceScale=0.01
foliage.ForceLOD=-1
r.ParticleLODBias=0
r.EmitterSpawnRateScale=0.75
r.Upscale.Quality=2
r.TonemapperQuality=0
r.FastBlurThreshold=0
r.AmbientOcclusionLevels=0
r.AmbientOcclusionRadiusScale=0
r.DistanceFieldAO=0
r.MaterialQualityLevel=0
FX.MaxCPUParticlesPerEmitter=0
r.ShadowQuality=0
r.Shadow.CSM.MaxCascades=0
r.Shadow.RadiusThreshold=0
r.Shadow.DistanceScale=0
r.Shadow.CSM.TransitionScale=0
r.DistanceFieldShadowing=0
r.SwitchGridShadow=0
'@

$lines = Get-Content $Enginepath

if ($lines.Count -gt 12) {
    # If there are more than 12 lines, keep only the first 14 lines
    $lines = $lines[0..11]
    Set-Content $Enginepath -Value $lines
    Write-Host "PVP settings disabled"
    Read-Host -Prompt "Press Enter to exit"
} elseif ($lines.Count -eq 12) {
    # If there are exactly 12 lines, append the new string as line 15
    Add-Content $Enginepath  -Value $String
    Write-Host "PVP settings Enabled"
    Read-Host -Prompt "Press Enter to exit"
} else {
    # If there are fewer than 12 lines, pad with empty lines and then add the new string
    $lines = $lines + ("" * (12 - $lines.Count)) + $String
    Set-Content $Enginepath -Value $lines
    Write-Host "PVP settings Enabled"
    Read-Host -Prompt "Press Enter to exit"
}