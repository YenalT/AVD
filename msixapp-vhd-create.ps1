#Temp Folder Create
cd\
mkdir -Path C:\temp -Force
mkdir -Path C:\desktop -Force
# VHD File Creation
$file = Get-Item -Path C:\msixapp\*.msix
$file.PSPath
$file.BaseName
$vhdName = $file.BaseName + ".vhd"
New-VHD -SizeBytes 1024MB -Path c:\temp\$vhdName -Dynamic -Confirm:$false
$vhdObject = Mount-VHD c:\temp\$vhdName -Passthru
$disk = Initialize-Disk -Passthru -Number $vhdObject.Number
$partition = New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem NTFS -NewFileSystemLabel $file.BaseName -Confirm:$false -Force

# Download Msixmgr Tool
Invoke-WebRequest -Uri https://aka.ms/msixmgr -OutFile C:\temp\msixmgr.zip
Expand-Archive -Path C:\temp\msixmgr.zip -DestinationPath C:\desktop\

# MSIX File Move
Copy-Item -Path $file.PSPath -Destination C:\Desktop\x64\

# Msix File Create
$partition
mkdir -Path "$($partition.DriveLetter):\msix"
cd C:\desktop\x64
.\msixmgr.exe -Unpack -packagePath $file.Name -destination "$($partition.DriveLetter):\msix" -applyacls

# Dismount Virtual Disk
Dismount-VHD -DiskNumber $vhdObject.DiskNumber