#!/bin/bash

# --- Log Setup ---
# Set the location for the log file to the user's home directory.
LOG_FILE="$HOME/ebs_cleanup.log"
exec &> >(tee -a "$LOG_FILE")  # Redirects all output to both the console and the log file.

# Function to log messages with a timestamp.
log_message() {
    echo "$(date "+%Y-%m-%d %H:%M:%S") - $1"
}

# --- AWS Profile Setup ---
# Check if the AWS_PROFILE environment variable is set.
if [ -z "$AWS_PROFILE" ]; then
    echo "AWS_PROFILE is not set. Please select an AWS profile:"
    
    # List all available AWS profiles.
    profiles=$(aws configure list-profiles)
    
    # Present the user with a numbered list of profiles and ask them to choose one.
    select profile in $profiles; do
        if [ -n "$profile" ]; then
            export AWS_PROFILE=$profile
            echo "Using AWS Profile: $AWS_PROFILE"
            log_message "Using AWS Profile: $AWS_PROFILE"
            break
        else
            echo "Invalid choice. Please select a valid profile."
        fi
    done
fi

# --- Region Selection ---
# List all available regions.
regions=$(aws ec2 describe-regions --query "Regions[*].RegionName" --output text)

# Provide an option to select all regions or specific regions.
echo "Select an option:"
echo "1) Select All Regions"
echo "2) Select Specific Region(s)"
read -p "Enter your choice (1/2): " region_choice

if [[ "$region_choice" == "1" ]]; then
    # Use all available regions.
    selected_regions=($regions)
    echo "You selected All Regions."
    log_message "User selected All Regions."
elif [[ "$region_choice" == "2" ]]; then
    # Ask the user to choose specific region(s).
    echo "Available Regions:"
    select region in $regions; do
        if [ -n "$region" ]; then
            selected_regions=($region)
            echo "You selected region: $region"
            log_message "User selected region: $region"
            break
        else
            echo "Invalid choice. Please select a valid region."
        fi
    done
else
    echo "Invalid choice, exiting..."
    exit 1
fi

# --- Loop through selected regions ---
for region in "${selected_regions[@]}"; do
    echo "Processing region: $region"
    log_message "Processing region: $region"

    # --- Fetch Unattached EBS Volumes ---
    log_message "Fetching unattached EBS volumes in region $region..."
    VOLUMES=$(aws ec2 describe-volumes --region "$region" --profile "$AWS_PROFILE" \
        --filters Name=status,Values=available --query "Volumes[*].VolumeId" --output text)

    if [ -z "$VOLUMES" ]; then
        log_message "No unattached EBS volumes found in region $region."
        echo "No unattached volumes found in region $region."
        continue  # Skip this region if no volumes are found.
    fi

    log_message "Found the following unattached volumes in region $region:"
    echo "$VOLUMES"

    # --- Check for 'BotIgnore=True' Tag ---
    volumes_to_delete=()
    for VOLUME in $VOLUMES; do
        VOLUME_TAGS=$(aws ec2 describe-tags --region "$region" --profile "$AWS_PROFILE" \
            --filters "Name=resource-id,Values=$VOLUME" "Name=key,Values=BotIgnore" --query "Tags[*].Value" --output text)

        if [[ "$VOLUME_TAGS" == "True" ]]; then
            log_message "Skipping volume $VOLUME in region $region because it has the 'BotIgnore=True' tag."
            echo "Skipping volume $VOLUME in region $region because it has the 'BotIgnore=True' tag."
        else
            volumes_to_delete+=("$VOLUME")
        fi
    done

    # --- Ask for confirmation to delete all volumes in this region ---
    if [ ${#volumes_to_delete[@]} -gt 0 ]; then
        read -p "Do you want to delete the following volumes in region $region? (y/n): ${volumes_to_delete[@]}: " confirm_all
        if [[ "$confirm_all" == "y" || "$confirm_all" == "Y" ]]; then
            for VOLUME in "${volumes_to_delete[@]}"; do
                # --- Delete the Volume ---
                log_message "Deleting volume: $VOLUME in region $region"
                if aws ec2 delete-volume --region "$region" --profile "$AWS_PROFILE" --volume-id "$VOLUME"; then
                    log_message "Volume $VOLUME deleted successfully in region $region."
                    echo "Volume $VOLUME deleted successfully in region $region."
                else
                    log_message "Failed to delete volume $VOLUME in region $region."
                    echo "Failed to delete volume $VOLUME in region $region."
                fi
            done
        else
            log_message "User chose to skip deletion in region $region."
            echo "Skipping deletion in region $region."
        fi
    else
        log_message "No volumes to delete in region $region."
        echo "No volumes to delete in region $region."
    fi
done

# --- Script Completion ---
log_message "Script completed."
