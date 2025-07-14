  # Extract the current version from the Dockerfile
  FILE_VERSION=$(grep -oP 'ARG PYTORCH_IMG=\K\d{2}\.\d{2}' docker/Dockerfile.release)
  FILE_VERSION_SOURCE=$(grep -oP 'ARG PYTORCH_IMG=\K\d{2}\.\d{2}' docker/Dockerfile.source)
  
  # Construct the date for the new version
  DATE=$(date '+%y.%m')
  
  # Separate new 
  YEAR=$(echo $DATE | cut -d'.' -f1)
  MONTH=$(echo $DATE | cut -d'.' -f2)
  
  ## --- Handling of special cases ---
  # Move to the previous year
  if [ "$MONTH" == "01" ]; then
  PREV_MONTH="12"
  YEAR=$(($YEAR - 1))
  # 09 and 08 will be interpreted in Octal, so they have to be handled differently 
  elif [ "$MONTH" == "09" ]; then
  PREV_MONTH="08"
  elif [ "$MONTH" == "08" ]; then
  PREV_MONTH="07"
  else
  PREV_MONTH=$(($MONTH - 1))
  # Ensure the previous month is 2 digits
  PREV_MONTH=$(printf "%02d" $PREV_MONTH)
  fi
  
  # Construct the new version
  NEW_VERSION="${YEAR}.${PREV_MONTH}"
  
  sed -i "s/$FILE_VERSION/$NEW_VERSION/g" docker/Dockerfile.release
  sed -i "s/$FILE_VERSION_SOURCE/$NEW_VERSION/g" docker/Dockerfile.source