#!/usr/bin/env zsh

cd ~

dirToCeck=$(fdfind --type directory --glob --hidden .git neovim)

pushd $dirToCeck

origins=$(git remote -v)

URLS=$(echo $origins | awk '{print $2}')

MODE=$(echo $origins | awk '{print $3}')

echo "${origins[@]}"

length=$(printf '%s\n' "${origins[@]}" | wc -l)
echo $length


for i in {1..$length};
do
    echo $i
done
