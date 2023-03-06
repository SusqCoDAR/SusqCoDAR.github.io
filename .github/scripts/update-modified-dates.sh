#!/bin/bash

files=($(git grep -l last_modified_at '*.md'))

for file in ${files[@]}; do
  echo "Checking history of $file"
  DATE=$(git log --grep NO_UPDATE_MODIFIED_DATE --invert-grep --pretty="format:%ad" --date="format:%Y-%m-%d" -1 $file)
  if [ -z "${DATE}" ]; then
    echo "::warning:: No commits modify $file"
    continue
  fi
  echo "$file was modified on ${DATE}"
  sed -i "s/last_modified_at: .*/last_modified_at: ${DATE}/" $file
  if ! git diff --quiet --exit-code HEAD $file; then
    echo "::notice:: Modification date updated for $file"
  fi
done

