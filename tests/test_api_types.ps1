# Library API type testing script
#
# Version: 20161110

$ExitSuccess = 0
$ExitFailure = 1
$ExitIgnore = 77

$TestPrefix = Split-Path -path ${Pwd}.Path -parent
$TestPrefix = Split-Path -path ${TestPrefix} -leaf
$TestPrefix = ${TestPrefix}.Substring(3)

$TestTypes = "aes_ccm_encrypted_key encryption_context io_handle key key_protector metadata metadata_entry password_key_data sector_data stretch_key volume_master_key"
$TestTypesWithInput = "volume"

$TestToolDirectory = "..\msvscpp\Release"

Function TestAPIType
{
	param( [string]$TestType )

	$TestDescription = "Testing API type: ${TestType}"
	$TestExecutable = "${TestToolDirectory}\${TestPrefix}_test_${TestType}.exe"

	$Output = Invoke-Expression ${TestExecutable}
	$Result = ${LastExitCode}

	If (${Result} -ne ${ExitSuccess})
	{
		Write-Host ${Output} -foreground Red
	}
	Write-Host "${TestDescription} " -nonewline

	If (${Result} -ne ${ExitSuccess})
	{
		Write-Host " (FAIL)"
	}
	Else
	{
		Write-Host " (PASS)"
	}
	Return ${Result}
}

If (-Not (Test-Path ${TestToolDirectory}))
{
	$TestToolDirectory = "..\vs2010\Release"
}
If (-Not (Test-Path ${TestToolDirectory}))
{
	Write-Host "Missing test tool directory." -foreground Red

	Exit ${ExitFailure}
}

$Result = ${ExitIgnore}

Foreach (${TestType} in ${TestTypes} -split " ")
{
	$Result = TestAPIType ${TestType}

	If (${Result} -ne ${ExitSuccess})
	{
		Break
	}
}

Foreach (${TestType} in ${TestTypesWithInput} -split " ")
{
	$Result = TestAPIType ${TestType}

	If (${Result} -ne ${ExitSuccess})
	{
		Break
	}
}

Exit ${Result}
