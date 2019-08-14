
ap_exists() {
  for ap in $(sudo iw dev wlo1 scan | grep -i ssid | sed 's/SSID: //g'); do
    arg=`echo $ap | xargs`
    # printf "$arg\n"
    if [ "$ap" == "$1" ]; then
      echo $ap
      return 0
    fi
  done
  return 1
}

n=`ap_exists "$1"`
if [ "$n" ]; then
  echo "The access point $n exists"
else
  echo "There is no such access point"
fi

