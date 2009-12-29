tell application "Xcode"
	if not (exists active project document) then Â
		error "No active project. Please open an Xcode project and re-run the script."
	try
		my updateProjectXmod(project of active project document)
	on error errMsg
		my logger("Xmod.scpt exception: " & errMsg)
	end try
end tell

on updateProjectXmod(_project)
	tell application "Xcode"
		-- Iterate over every .xcdatamodel in the project.
		set modelList to every file reference of _project whose file kind is "wrapper.xcdatamodel"
		repeat with modelIt in modelList
			if comments of modelIt contains "xmod" then
				set modelSrcDir to my modelSrcDirPath(full path of modelIt)
				set targetList to my everyTargetWithBuildFilePath(_project, full path of modelIt)
				
				-- Create the .xcdatamodel related source group if necessary.
				if not (exists (every item reference of group of modelIt whose full path is modelSrcDir)) then
					tell group of modelIt
						make new group with properties {full path:modelSrcDir, name:text 1 thru -13 of ((name of modelIt) as string)}
					end tell
				end if
				set modelSrcGroup to item 1 of (every item reference of group of modelIt whose full path is modelSrcDir)
				tell modelSrcGroup to delete every item reference -- clear it out for population in case we didn't just create it
				
				--	Meat.
				do shell script "/usr/bin/mogenerator --model '" & full path of modelIt & "' --output-dir '" & modelSrcDir & "'"
				
				--	Build a list of resulting source files.
				tell application "System Events"
					set modelSrcDirAlias to POSIX file modelSrcDir as alias
					set humanHeaderFileList to (every file of modelSrcDirAlias whose name ends with ".h" and name does not start with "_")
					set humanSourceFileList to (every file of modelSrcDirAlias whose (name ends with ".m" or name ends with ".mm") and name does not start with "_")
					set machineHeaderFileList to (every file of modelSrcDirAlias whose name ends with ".h" and name starts with "_")
					set machineSourceFileList to (every file of modelSrcDirAlias whose (name ends with ".m" or name ends with ".mm") and name starts with "_")
					set fileList to humanSourceFileList & humanHeaderFileList & machineSourceFileList & machineHeaderFileList
					set pathList to {}
					repeat with fileItem in fileList
						set pathList to pathList & POSIX path of fileItem
					end repeat
				end tell
				
				--	Add the source files to the model's source group and the model's targets.
				repeat with pathIt in pathList
					tell modelSrcGroup
						set modelSrcFileRef to make new file reference with properties {full path:pathIt, name:name of (info for POSIX file pathIt)}
						repeat with targetIndex from 1 to (count of targetList)
							set targetIt to item targetIndex of targetList
							add modelSrcFileRef to targetIt
						end repeat
					end tell
				end repeat
			end if
		end repeat
	end tell
end updateProjectXmod

on everyTargetWithBuildFilePath(_project, _buildFilePath)
	set theResult to {}
	tell application "Xcode"
		repeat with targetIt in (every target of _project)
			repeat with buildFileIt in build files of targetIt
				if full path of file reference of buildFileIt is _buildFilePath then set theResult to theResult & {(targetIt as anything)}
			end repeat
		end repeat
	end tell
	return theResult
end everyTargetWithBuildFilePath

on modelSrcDirPath(modelFileUnixPath)
	set modelFilePosixRef to POSIX file modelFileUnixPath
	set modelFileAlias to modelFilePosixRef as alias
	
	tell application "Finder"
		set modelFileFolder to folder of modelFileAlias
		set modelFileName to name of modelFileAlias
		set modelSrcFolderName to text 1 thru -13 of modelFileName -- pull off the .xcdatamodel extension
		if not (exists folder modelSrcFolderName of modelFileFolder) then
			make folder at modelFileFolder with properties {name:modelSrcFolderName}
		end if
		set modelSrcFolder to folder modelSrcFolderName of modelFileFolder
	end tell
	return text 1 thru -2 of (POSIX path of (modelSrcFolder as alias)) -- kill the trailing slash
end modelSrcDirPath

on logger(msg)
	do shell script "logger '" & msg & "'"
end logger
