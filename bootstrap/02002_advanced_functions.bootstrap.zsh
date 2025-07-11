
# FUNCTION_DOCUMENTATION_START
# - cd with grep (globbing)
# - if more than one pattern matches, use fzf to select
# FUNCTION_DOCUMENTATION_END
cg() {
  local pattern="$1"
  local matching_dirs=( *"$pattern"*/ )  # Use () to create an array

  if [ ${#matching_dirs[@]} -eq 1 ]; then
    cd "${matching_dirs[1]}"
    return 0
  elif [ ${#matching_dirs[@]} -gt 1 ]; then
    local selected_dir=$(printf '%s\n' "${matching_dirs[@]}" | fzf)
    cd "${selected_dir}"
    return 0
  else
    echo "No matching directory found for '$pattern'"
    return 1
  fi
}

# FUNCTION_DOCUMENTATION_START
# - Search for files in the current directory with fzf
# - Use bat to display the selected file's content
# FUNCTION_DOCUMENTATION_END
bg() {
  # clear the screen
  c
  local pattern="$1"
  local end_pattern=*"$pattern"* 
  echo "$end_pattern"
  local matching_files=( *"$pattern"* )  # Use () to create an array
  echo "matching files: $matching_files"
  if [ ${#matching_files[@]} -eq 1 ]; then
    bat --paging=never "${matching_files[1]}"
    return 0
  elif [ ${#matching_files[@]} -lt 6 ]; then
    for selected_file in "${matching_files[@]}"; do
      if [ -n "$selected_file" ]; then
        bat --paging=never "$selected_file"
      fi
    done
    return 0
  else
    local selected_file=$(printf '%s\n' "${matching_files[@]}" | fzf)
    if [ -n "$selected_file" ]; then
      bat --paging=never "$selected_file"
      return 0
    else
      echo "No file selected."
      return 1
    fi
  fi
}