#!/bin/bash

# Finding global
blog_loc='./_posts/'
now=$(date)

# Just some more fun with dates
year=$(date +%Y)
month=$(date +%m)
day=$(date +%d)
hour=$(date +%H)
min=$(date +%M)
sec=$(date +%S)

# format dates
format_date=$(date +"%Y-%m-%d %H:%M:%S %z")
printf "\t%s\n" "$format_date"

# verification, but also for fun
printf "\tOn the %s day of the %s month of the %s year based on most people's calendar.\n" "$day" "$month" "$year"
printf "\tViet's log will record another chapter at the %s hour, %s minute, and %s second\n\n" "$hour" "$min" "$day"

# format title
title=$1
lower_title=$(echo $title | awk '{print tolower($0)}')
formatted_title="${lower_title// /-}"
filename="${year}-${month}-${day}-${formatted_title}.md"
fullname="${blog_loc}${filename}"

# Create the post
printf "\tCreating post: %s\n" "$filename"

# Populate the post

if [ -f $fullname ]; then
   printf "\tFile %s at blogging path exists. Will clear file content\n" "$filename"
   > $fullname
else
   printf "\tFile %s does not exist. Will be created.\n" "$filename"
   touch "${fullname}"
fi
printf "%s\n" "---" >> $fullname
printf "layout: post\n" >> $fullname
printf "title: \"%s\"\n" "$title" >> $fullname
printf "date: %s\n" "$format_date" >> $fullname
printf "categories: \n" >> $fullname
printf "%s\n" "---">> $fullname

