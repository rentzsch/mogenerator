property kExplicitlyProcessedOptions : {"--human-dir ", "--machine-dir ", "--output-dir ", "--log-command"}

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
		set modelList to every file reference of _project whose file kind is "wrapper.xcdatamodel" and comments contains "xmod"
		repeat with modelItr in modelList
			my updateModel(_project, modelItr, comments of modelItr)
		end repeat
		-- Iterate over every .xcdatamodeld (notice the 'd') in the project.
		set modeldList to every group of _project whose name contains ".xcdatamodeld" and comments contains "xmod"
		repeat with modeldIt in modeldList
			-- Find the 'active' model version
			set currentVersionFile to full path of modeldIt & "/.xccurrentversion"
			tell application "System Events"
				set currentVersionPlist to contents of property list file currentVersionFile
				set activeModelVersionFilename to value of property list item "_XCCurrentVersionName" of currentVersionPlist
			end tell
			set activeModelVersion to full path of modeldIt & "/" & activeModelVersionFilename
			set modelItr to item 1 of (every file reference of modeldIt whose name is activeModelVersionFilename)
			-- Then update it
			my updateModel(_project, modelItr, comments of modeldIt)
		end repeat
	end tell
end updateProjectXmod

on updateModel(_project, modelItr, theComments)
	tell application "Xcode"
				
				set modelInfo to my getModelInfo(full path of modelItr, theComments)
				set humanGroupRef to null
				set machineGroupRef to null
				
				-- Figure out the model's parent group.
				-- Unversioned models are simple files so their group is the answer.
				-- Version models are bundles, which are represented as pseudo-groups in Xcode. You can't ask a pseudo-group for its parent group,
				-- so we discover it by querying project-wide all groups that contain the pseudo-group and using the first result.
				set modelItemRef to item 1 of (every item reference of _project whose full path is (full path of modelItr))
				set modelGroupRef to group of modelItemRef
				if isBundle of modelInfo then
					set modelGroupRef to item 1 of (every group of _project whose groups contains modelGroupRef)
				end if
				
				-- look for a group in the project that has the full path of the human manageable files
				set groupRefs to (every group of _project whose full path is (humanDirPath of modelInfo))
				-- if we don't find one, create it in the same group as the model file
				if (count of groupRefs) = 0 then
					tell modelGroupRef
						-- if we have different human and machine paths, then append '_human' to the model name for the group name
						if (humanDirPath of modelInfo) is not equal to (machineDirPath of modelInfo) then
							make new group with properties {full path:(humanDirPath of modelInfo), name:(name of modelInfo & "_human")}
						else
							make new group with properties {full path:(humanDirPath of modelInfo), name:(name of modelInfo)}
						end if
						set groupRefs to (every group of _project whose full path is (humanDirPath of modelInfo))
					end tell
				end if
				set humanGroupRef to item 1 of groupRefs
				
				-- if we have different human and machine paths, then look for a group for the machine files
				if (humanDirPath of modelInfo) is not equal to (machineDirPath of modelInfo) then
					set groupRefs to (every group of _project whose full path is (machineDirPath of modelInfo))
					-- if we don't find one, create it in the same group as the model file... named with '_machine' appended to the model name
					if (count of groupRefs) = 0 then
						tell modelGroupRef
							make new group with properties {full path:(machineDirPath of modelInfo), name:(name of modelInfo & "_machine")}
						end tell
						set groupRefs to (every group of _project whose full path is (machineDirPath of modelInfo))
					end if
					set machineGroupRef to item 1 of groupRefs
				end if
				
				-- Create the do shell script string and append any custom per model options to it, skipping the ones we've already parsed out
				set logCommand to false
				set theScript to "/usr/bin/mogenerator --model '" & full path of modelItr & "' --human-dir '" & (humanDirPath of modelInfo) & "' --machine-dir '" & (machineDirPath of modelInfo) & "'"
				set theParagraphs to every paragraph of theComments
				repeat with theParagraph in theParagraphs
					if theParagraph starts with "--" then
						set isExplicitlyProcessedOption to false
						repeat with explicitlyProcessedOption in kExplicitlyProcessedOptions
							if theParagraph starts with explicitlyProcessedOption then set isExplicitlyProcessedOption to true
						end repeat
						if not isExplicitlyProcessedOption then
							set theScript to theScript & " " & the text of theParagraph
						end if
						if theParagraph starts with "--log-command" then
							set logCommand to true
						end if
					end if
				end repeat
				
				--	Meat.
				if logCommand then
					my logger(theScript)
				end if
				do shell script theScript
				
				my addFilesFromPathToGroup(_project, modelItr, humanGroupRef)
				if machineGroupRef is not null then
					my addFilesFromPathToGroup(_project, modelItr, machineGroupRef)
				end if
	end tell
end updateModel

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

on getModelInfo(modelFileUnixPath, theComments)
	set modelFilePosixRef to POSIX file modelFileUnixPath
	set modelFileAlias to modelFilePosixRef as alias
	set theOutputDir to ""
	set theHumanDir to ""
	set theMachineDir to ""
	
	-- check for any directory path options specified in the commments
	set theParagraphs to every paragraph of theComments
	repeat with theParagraph in theParagraphs
		set paragraphLength to (length of theParagraph)
		if (offset of "--human-dir " in theParagraph) = 1 then
			set remainderOffset to (length of "--human-dir ") + 1
			if remainderOffset > paragraphLength then
				set theHumanDir to ""
			else
				set theHumanDir to text remainderOffset thru -1 of theParagraph
			end if
		else if (offset of "--machine-dir " in theParagraph) = 1 then
			set remainderOffset to (length of "--machine-dir ") + 1
			if remainderOffset > paragraphLength then
				set theMachineDir to ""
			else
				set theMachineDir to text remainderOffset thru -1 of theParagraph
			end if
		else if (offset of "--output-dir " in theParagraph) = 1 then
			set remainderOffset to (length of "--output-dir ") + 1
			if remainderOffset > paragraphLength then
				set theOutputDir to ""
			else
				set theOutputDir to text remainderOffset thru -1 of theParagraph
			end if
		end if
	end repeat
	
	-- remove any leading/trailing spaces or tabs from the paths
	if (length of theHumanDir) > 0 then
		repeat while character 1 of theHumanDir = tab or character 1 of theHumanDir = space
			set theHumanDir to text 2 thru -1 of theHumanDir
		end repeat
		repeat while last character of theHumanDir = tab or last character of theHumanDir = space
			set theHumanDir to text 1 thru -2 of theHumanDir
		end repeat
	end if
	
	if (length of theMachineDir) > 0 then
		repeat while character 1 of theMachineDir = tab or character 1 of theMachineDir = space
			set theMachineDir to text 2 thru -1 of theMachineDir
		end repeat
		repeat while last character of theMachineDir = tab or last character of theMachineDir = space
			set theMachineDir to text 1 thru -2 of theMachineDir
		end repeat
	end if
	
	if (length of theOutputDir) > 0 then
		repeat while character 1 of theOutputDir = tab or character 1 of theOutputDir = space
			set theOutputDir to text 2 thru -1 of theOutputDir
		end repeat
		repeat while last character of theOutputDir = tab or last character of theOutputDir = space
			set theOutputDir to text 1 thru -2 of theOutputDir
		end repeat
	end if
	
	-- get actual the model info and modify value for theOutputDir if necessary
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
		
		-- if we didn't find any directory specifiers in the comments, then make theOutputDir the folder containg the model file
		if ((length of theOutputDir) = 0) and ((length of theHumanDir) = 0) and ((length of theMachineDir) = 0) then
			if not (exists folder modelName of modelFileFolder) then Â
				make folder at modelFileFolder with properties {name:modelName}
			set modelSrcFolder to folder modelName of modelFileFolder
			set theOutputDir to text 1 thru -2 of (POSIX path of (modelSrcFolder as alias))
			-- otherwise, if theOutputDir isn't a full path itself already, set theOutputDir to a full path relative to the model file
		else if theOutputDir does not start with "/" then
			set modelFolderPath to text 1 thru -2 of (POSIX path of (modelFileFolder as alias))
			if (length of theOutputDir) = 0 then
				set theOutputDir to modelFolderPath
			else
				copy modelFolderPath & "/" & theOutputDir to theOutputDir
			end if
		end if
		
	end tell
	
	
	-- if theHumanDir is empty, use theOutputDir value instead, if theHumanDir not empty and it isn't a full path, then treat it as a relative path to theOutputDir
	if (length of theHumanDir) = 0 then
		set theHumanDir to theOutputDir
	else if theHumanDir does not start with "/" then
		copy theOutputDir & "/" & theHumanDir to theHumanDir
	end if
	
	-- if theMachineDir is empty, use theOutputDir value instead, if theMachineDir not empty and it isn't a full path, then treat it as a relative path to theOutputDir
	if (length of theMachineDir) = 0 then
		set theMachineDir to theOutputDir
	else if theMachineDir does not start with "/" then
		copy theOutputDir & "/" & theMachineDir to theMachineDir
	end if
	
	-- ensure the directories exist
	do shell script "mkdir -p '" & theHumanDir & "'"
	do shell script "mkdir -p '" & theMachineDir & "'"
	
	-- the following should resolve any symlinks, '..', or '~' in the paths
	tell application "System Events"
		set dirAlias to POSIX file theHumanDir as alias
		set theHumanDir to (POSIX path of (dirAlias as alias))
		set dirAlias to POSIX file theMachineDir as alias
		set theMachineDir to (POSIX path of (dirAlias as alias))
	end tell
	
	return {name:modelName, isBundle:isModelBundle, machineDirPath:theMachineDir, humanDirPath:theHumanDir}
	
end getModelInfo

on logger(msg)
	do shell script "logger '" & msg & "'"
end logger

on addFilesFromPathToGroup(_project, modelItr, groupRef)
	tell application "Xcode"
		-- get the full path of the directory that the groupRef represents
		set groupPath to full path of groupRef
		
		--	Build a list of source files in the group's directory
		tell application "System Events"
			set modelSrcDirAlias to POSIX file groupPath as alias
			set fileList to (every file of modelSrcDirAlias whose (name ends with ".m" or name ends with ".mm" or name ends with ".h"))
			set pathList to {}
			repeat with fileItem in fileList
				set pathList to pathList & POSIX path of fileItem
			end repeat
		end tell
		
		--	Add the source files to the group and the model's targets, but only if they don't exist already
		set targetList to null
		repeat with pathItr in pathList
			tell groupRef
				set fileRefs to (every file reference of _project whose full path is pathItr)
				if (count of fileRefs) = 0 then
					set modelSrcFileRef to make new file reference with properties {full path:pathItr, name:name of (info for POSIX file pathItr)}
					if targetList is null then
						set targetList to my everyTargetWithBuildFilePath(_project, full path of modelItr)
					end if
					repeat with targetIndex from 1 to (count of targetList)
						set targetItr to item targetIndex of targetList
						add modelSrcFileRef to targetItr
					end repeat
				end if
			end tell
		end repeat
	end tell
end addFilesFromPathToGroup
