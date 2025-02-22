# AWS EBS Cleanup Script

This repository contains a bash script to clean up unattached EBS volumes in AWS using the AWS CLI. The script allows you to:
- Choose the AWS profile and region.
- Filter volumes by their status (unattached volumes).
- Skip volumes with a `BotIgnore=True` tag to prevent accidental deletion.
- Delete the unattached EBS volumes after user confirmation.

## Features:
- Select AWS profile and region.
- Fetch unattached EBS volumes.
- Skip volumes with `BotIgnore=True` tag.
- User-friendly confirmation before deletion.
- Supports all regions or specific regions.

## Prerequisites:
- [AWS CLI](https://aws.amazon.com/cli/) installed and configured with the necessary permissions.
- Bash shell for running the script.
- An AWS account with permissions to describe and delete volumes.

## Usage:
1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/your-repo.git
    cd your-repo
    ```
   
2. Run the script:
    ```bash
    ./ebs_cleanup.sh
    ```

3. The script will prompt you to select the AWS profile and region, then fetch unattached EBS volumes.
4. You will be asked if you want to delete the volumes after reviewing the list.

## License:
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
