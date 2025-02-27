#!/bin/bash

<< readme
This is for Linux OS.
This is script for backup with 5 day rotation.
Use 'crontab -e' command for scheduling.

usage: 
./backup.sh <path/to/ur/source> <path/to/backup/folder>

source: the directory u want to backup.
backup folder: the directory where backups will be stored.
readme

function display_usage {
	echo "usage: ./backup.sh <path to ur source> <path to backup folder>"
}

# '$#' means total cli arguments. If arguments = 0 then it will call display_usage function
if [ $# -eq 0 ];then
	display_usage
fi

source_dir=$1
backup_dir=$2
# $(...) (Command Substitution): The $(...) syntax runs the command inside the parentheses and # captures its output.
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')

function create_backup {

# > /dev/null: This part redirects the warnings or standard output(usually shown in the
# terminal) to /dev/null, which is a special file that discards all output.
# zip: This is the command used to create a ZIP file.
# -r: This flag stands for recursive, meaning it includes all files and subdirectories inside
# the source directory in the ZIP file.

	zip -r "${backup_dir}/backup_${timestamp}.zip" "${source_dir}" > /dev/null

# '$?' has commands value after execution. If prev command/above command executes perfectly,   #  it will have zero value stored in it.

        if [ $? -eq 0 ]; then
                echo "backup generated successfully for ${timestamp}"
	fi
}

function perform_rotation {

# backups=(...): The result of the ls -t command is captured and stored in the backups array.
# Each file listed by the ls command becomes an element in the backups array.
# 2>/dev/null redirects any error output (such as "no files found") to /dev/null

	backups=($(ls -t "${backup_dir}/backup_"*.zip 2>/dev/null))

# '#' inside "${#backups[@]}" has a special meaning in bash scripting, it gives length.
# The ${#array[@]} syntax is used to get the length of the array.
# So in this script, "${#backups[@]}" gives the number of elements in the backups array.

	if [ "${#backups[@]}" -gt 5 ]; then
		echo "Performing rotation for 5 days"

# ${backups[@]}: This refers to all the elements in the 'backups' array.
# :2 means skip the first two elements (starting from index 2) and select the rest of the array
		
                backups_to_remove=("${backups[@]:2}")
		#echo "${backups_to_remove[@]}"

		for backup in "${backups_to_remove[@]}";
	       	do
			rm -f "${backup}"
		done
	fi
}

# calling functions
create_backup
perform_rotation





