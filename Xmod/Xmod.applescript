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
		repeat with modelItr in modelList
			set theComments to the comments of modelItr
			if theComments contains "xmod" then
				
				set modelInfo to my getModelInfo(full path of modelItr)
				
				-- Figure out the model's parent group.
				-- Unversioned models are simple files so their group is the answer.
				-- Version models are bundles, which are represented as pseudo-groups in Xcode. You can't ask a pseudo-group for its parent group,
				-- so we discover it by querying project-wide all groups that contain the pseudo-group and using the first result.
				set modelItemRef to item 1 of (every item reference of _project whose full path is (full path of modelItr))
				set modelGroupRef to group of modelItemRef
				if isBundle of modelInfo then
					set modelGroupRef to item 1 of (every group of _project whose groups contains modelGroupRef)
				end if
				
				-- Create the .xcdatamodel related source group if necessary.
				if not (exists (every item reference of modelGroupRef whose full path is (srcDirPath of modelInfo))) then
					tell modelGroupRef
						make new group with properties {full path:(srcDirPath of modelInfo), name:(name of modelInfo)}
					end tell
				end if
				set modelSrcGroup to item 1 of (every item reference of modelGroupRef whose full path is (srcDirPath of modelInfo))
				tell modelSrcGroup to delete every item reference -- clear it out for population in case we didn't just create it
				
				-- Create the do shell script string and append any custom per model options to it
				set theScript to "/usr/bin/mogenerator --model '" & full path of modelItr & "' --output-dir '" & (srcDirPath of modelInfo) & "'"
				set theParagraphs to every paragraph of theComments
				repeat with theParagraph in theParagraphs
					if (length of the characters of theParagraph) is greater than 2 then
						set theToken to the first character of theParagraph & the second character of theParagraph
						if theToken is "--" then
							set theScript to theScript & " " & the text of theParagraph
						end if
					end if
				end repeat
				
				--	Meat.
				do shell script theScript
				
				--	Build a list of resulting source files.
				tell application "System Events"
					set modelSrcDirAlias to POSIX file (srcDirPath of modelInfo) as alias
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
				set targetList to my everyTargetWithBuildFilePath(_project, full path of modelItr)
				repeat with pathItr in pathList
					tell modelSrcGroup
						set modelSrcFileRef to make new file reference with properties {full path:pathItr, name:name of (info for POSIX file pathItr)}
						repeat with targetIndex from 1 to (count of targetList)
							set targetItr to item targetIndex of targetList
							add modelSrcFileRef to targetItr
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
		repeat with targetItr in (every target of _project)
			repeat with buildFileItr in build files of targetItr
				if full path of file reference of buildFileItr is _buildFilePath then set theResult to theResult & {(targetItr as anything)}
			end repeat
		end repeat
	end tell
	return theResult
end everyTargetWithBuildFilePath

on getModelInfo(modelFileUnixPath)
	set modelFilePosixRef to POSIX file modelFileUnixPath
	set modelFileAlias to modelFilePosixRef as alias
	
	tell application "Finder"
		set modelFileFolder to folder of modelFileAlias
		
		set isModelBundle to name of modelFileFolder ends with ".xcdatamodeld"
		if isModelBundle then
			set modelFileAlias to (folder of modelFileAlias) as alias -- it's a bundle, go up one folder
			set modelFileFolder to folder of modelFileAlias
		end if
		
		set modelFileName to name of modelFileAlias
		if isModelBundle then
			set extensionLength to length of ".xcdatamodeld"
		else
			set extensionLength to length of ".xcdatamodel"
		end if
		
		set modelName to text 1 thru -(extensionLength + 1) of modelFileName -- pull off the extension
		if not (exists folder modelName of modelFileFolder) then
			make folder at modelFileFolder with properties {name:modelName}
		end if
		set modelSrcFolder to folder modelName of modelFileFolder
	end tell
	set srcDirPath to text 1 thru -2 of (POSIX path of (modelSrcFolder as alias)) -- kill the trailing slash
	return {name:modelName, isBundle:isModelBundle, srcDirPath:srcDirPath}
end getModelInfo

on logger(msg)
	do shell script "logger '" & msg & "'"
end logger
