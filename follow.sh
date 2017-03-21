filename=".team.txt"
current="$(keybase status | grep Username | awk '{ print $2; }')"

while read -r line
do
  if [[ ! $line = \#* ]] ; then
    IFS=' ' read -a parts <<< "$line"

    if [[ "${parts[0]}" == "$current" ]] ; then
      echo "Skipping current user"
      continue
    fi

    echo "Following ${parts[0]} on Keybase.io"
    keybase follow "${parts[0]}"

    echo "Adding gpg key for ${parts[0]}"
    gpg --keyserver gpg.mozilla.org --recv-keys "${parts[1]}"
    echo "\n••••••••••\n"
  fi
done < "$filename"

pass init $(grep -v '#' < "$filename" | awk '{ print $2 }')
echo "\nFinishing following team"
