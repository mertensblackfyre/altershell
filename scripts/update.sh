#!/usr/bin/bash

# Remove old configuration directories if they exist
for dir in nvim hypr ghostty quickshell fastfetch matugen; do
  if [ -d ~/Desktop/arch/config/$dir ]; then
    echo "Removing existing $dir config..."
    rm -rf ~/Desktop/Projects/arch/config/$dir
  else
    echo "$dir config does not exist on Desktop/arch/config/"
  fi
done

# Copy current configurations to the Desktop/arch/config directory
for dir in nvim hypr ghostty quickshell fastfetch matugen; do
  if [ -d ~/.config/$dir ]; then
    echo "Copying $dir config to Desktop/arch/config..."
    cp -r ~/.config/$dir ~/Desktop/arch/config/
  else
    echo "$dir config does not exist in ~/.config/"
  fi
done



rm ../.bashrc
cp ~/.bashrc ../


echo "Configuration sync complete."

