# Extract the current version from the Dockerfile
VERSION=$(grep -oP 'ARG PYTORCH_IMG=\K\d{2}\.\d{2}' docker/Dockerfile.release)
echo "Current version is: $VERSION"

# Get the year and month
YEAR=$(echo $VERSION | cut -d'.' -f1)
MONTH=$(echo $VERSION | cut -d'.' -f2)

# Calculate the previous month
PREV_MONTH=$(($MONTH - 1))
if [ $PREV_MONTH -eq 0 ]; then
PREV_MONTH=12
YEAR=$(($YEAR - 1))  # Move to previous year
fi

# Format the previous month in MM format
PREV_MONTH=$(printf "%02d" $PREV_MONTH)

# Construct the new version
NEW_VERSION="${YEAR}.${PREV_MONTH}"
echo "Previous month version: $NEW_VERSION"

echo "::set-output name=old_version::$VERSION"
echo "::set-output name=new_version::$NEW_VERSION"


# OLD_VERSION=${{ steps.get_version.outputs.old_version }}
# NEW_VERSION=${{ steps.get_version.outputs.new_version }}
sed -i "s/$VERSION/$NEW_VERSION/g" docker/Dockerfile.release
echo "Updated Dockerfile with new version: $NEW_VERSION"