Here's a full version of your `ebs_cleanup.sh` script that you can use for cleaning up unattached AWS EBS volumes:

```bash
#!/bin/bash

# Logging function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> /var/log/ebs_cleanup.log
}

# Check if AWS_PROFILE and AWS_REGION are set
check_aws_profile_and_region() {
    if [ -z "$AWS_PROFILE" ]; then
        echo "AWS_PROFILE environment variable is not set. Please specify it."
        log_message "AWS_PROFILE environment variable is not set."
        exit 1
    fi

    if [ -z "$AWS_REGION" ]; then
        echo "AWS_REGION environment variable is not set. Please specify it."
        log_message "AWS_REGION environment variable is not set."
        exit 1
    fi
}

# Fetch unattached EBS volumes and exclude those with the 'BotIgnore=True' tag
fetch_unattached_volumes() {
    echo "Fetching unattached EBS volumes in region $AWS_REGION..."

    unattached_volumes=$(aws ec2 describe-volumes --profile "$AWS_PROFILE" --region "$AWS_REGION" \
        --filters Name=status,Values=available \
        --query 'Volumes[?!contains(Tags[?Key==`BotIgnore`].Value, `True`)].{ID:VolumeId,State:State,Tags:Tags}' \
        --output json)

    echo "$unattached_volumes"
    log_message "Fetched unattached volumes from region $AWS_REGION"
}

# Ask for confirmation to delete volumes
confirm_and_delete_volumes() {
    echo "Are you sure you want to delete these unattached volumes? (y/n)"
    read -r confirmation

    if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
        for volume in $(echo "$unattached_volumes" | jq -r '.[].ID'); do
            echo "Deleting volume $volume..."
            aws ec2 delete-volume --profile "$AWS_PROFILE" --region "$AWS_REGION" --volume-id "$volume"
            log_message "Deleted volume $volume in region $AWS_REGION"
        done
    else
        echo "No volumes were deleted."
        log_message "No volumes were deleted in region $AWS_REGION"
    fi
}

# Main script execution
main() {
    check_aws_profile_and_region

    echo "Select AWS profile (e.g., 'default')"
    read -p "#? " profile_choice
    export AWS_PROFILE=$profile_choice
    log_message "Using AWS Profile: $AWS_PROFILE"

    echo "Select AWS region:"
    regions=("ap-south-1" "us-east-1" "us-west-2" "eu-west-1")  # List your preferred regions here
    PS3="Please select a region: "
    select region in "${regions[@]}"; do
        if [[ " ${regions[@]} " =~ " ${region} " ]]; then
            export AWS_REGION=$region
            log_message "Using AWS Region: $AWS_REGION"
            break
        else
            echo "Invalid selection."
        fi
    done

    fetch_unattached_volumes

    # Check if there are unattached volumes to delete
    if [[ -z "$unattached_volumes" || "$unattached_volumes" == "[]" ]]; then
        echo "No unattached volumes found."
        log_message "No unattached volumes found in region $AWS_REGION"
    else
        confirm_and_delete_volumes
    fi
}

# Start the script
main
```

### Explanation of Key Sections:

1. **Logging Function (`log_message`)**:
    - This function logs messages with a timestamp to `/var/log/ebs_cleanup.log`. You can adjust the log location if needed.

2. **Profile and Region Check (`check_aws_profile_and_region`)**:
    - This function checks if the `AWS_PROFILE` and `AWS_REGION` environment variables are set. If not, it prompts for these values and exits.

3. **Fetch Unattached Volumes (`fetch_unattached_volumes`)**:
    - Uses the `aws ec2 describe-volumes` command to fetch all unattached EBS volumes in the specified region. Volumes with a tag `BotIgnore=True` are excluded from the results.

4. **Confirmation and Deletion (`confirm_and_delete_volumes`)**:
    - After listing unattached volumes, the script asks for a confirmation before proceeding with deletion. If the user confirms, it deletes the volumes using `aws ec2 delete-volume`.

5. **Main Execution Flow (`main`)**:
    - The main function sets the profile and region using a prompt, fetches unattached volumes, and deletes them after confirmation.

### Requirements:
1. **AWS CLI**: Ensure the AWS CLI is installed and configured with the necessary permissions to describe and delete EBS volumes.
2. **jq**: This script uses `jq` to parse the JSON output from the `aws ec2 describe-volumes` command. Make sure `jq` is installed.

```bash
sudo apt-get install jq  # For Debian/Ubuntu-based systems
```

### Usage:
1. Clone the repository or place the `ebs_cleanup.sh` script on your local system.
2. Make the script executable:

```bash
chmod +x ebs_cleanup.sh
```

3. Run the script:

```bash
./ebs_cleanup.sh
```

This script will guide you through selecting the AWS profile, region, and confirming the deletion of unattached volumes.

---

Let me know if you need further adjustments or improvements!
