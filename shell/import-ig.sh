#!/bin/bash

echo "INSTAGRAM TO JEKYLL IMPORTER"

echo "[?] Which Instagram post would you like to import?"
read post

echo "[?] What is the title of your new post?"
read title

echo "[?] What should the publish date of the post be? (y-m-d)"
read date

echo "[?] Where should the post be saved?"
read postDir

echo "[?] Where should the images be saved?"
read imgDir

# Format filename
fileName=$(echo "$date-$title" | iconv -t ascii//TRANSLIT | sed -E s/[^a-zA-Z0-9]+/-/g | sed -E s/^-+\|-+$//g | tr A-Z a-z)
path="$postDir/$fileName.md"

# Show confirmation on screen
echo "Starting import"
echo "--> importing post with id '$post'"
echo "--> output file: $fileName.md"

# Download the images
echo "--> import images"
wget --output-document="$imgDir/$fileName.jpg" "https://www.instagram.com/p/$post/media"
wget --output-document="$imgDir/${fileName}_large.jpg" "https://www.instagram.com/p/$post/media?size=l"
wget --output-document="$imgDir/${fileName}_thumbnail.jpg" "https://www.instagram.com/p/$post/media?size=t"

# Output markdown file
content="---
layout: post
title:  '$title'
date:   $date
instagram_id: $ost
tags: []
post_image: $imgDir/$fileName.jpg
post_image_large: $imgDir/${fileName}_large.jpg
post_image_small: $imgDir/${fileName}_thumbnail.jpg
---

<!-- begin ig snippet -->"
echo "$content" >> "$path"

# Download IG snippet
curl -s "https://api.instagram.com/oembed/?url=http://instagr.am/p/$post" | jq -r '.html' >> "$path"
echo "<!-- end ig snippet -->" >> "$path"

echo "IMPORT COMPLETE"