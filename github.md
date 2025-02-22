Here’s a complete step-by-step guide to set up your project with GitHub, including creating the repository, adding necessary files (`README.md`, `.gitignore`, `LICENSE`), and pushing it all to GitHub.

---

### **Step 1: Create a GitHub Repository**
1. Go to [GitHub](https://github.com) and sign in (or create an account).
2. Click the **+** icon on the top right and select **New repository**.
3. Provide a **Repository name**, **Description**, and choose whether it’s **Public** or **Private**.
4. Click **Create repository**.

---

### **Step 2: Initialize Git in Your Local Project**
1. Open your terminal and navigate to the directory where your script is located.

```bash
cd /path/to/your/scripts  # Change to the script directory
```

2. Initialize a new Git repository:

```bash
git init
```

3. If you already have your script in this folder, proceed to the next step. Otherwise, add your script file (`ebs_cleanup.sh`).

---

### **Step 3: Add Remote GitHub Repository**
1. Copy the **URL** of your newly created GitHub repository. It will be something like:

   - For HTTPS: `https://github.com/yourusername/your-repo.git`
   - For SSH: `git@github.com:yourusername/your-repo.git`

2. Add the GitHub repository as a remote to your local Git repository:

```bash
git remote add origin https://github.com/yourusername/your-repo.git  # Replace with your URL
```

---

### **Step 4: Create and Add the Files to Your Repository**
Now, we’ll create and add three important files: `README.md`, `.gitignore`, and `LICENSE`.

#### 1. **Create the `README.md`**
   - This will explain what the project does and how to use it.
   
```bash
touch README.md
```

   - Add the following content to the `README.md` file:

```markdown
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
```

---

#### 2. **Create the `.gitignore`**
   - This file tells Git which files to ignore, such as temporary files and logs.

```bash
touch .gitignore
```

   - Add the following content to `.gitignore`:

```plaintext
# Ignore AWS CLI credentials
.aws/

# Ignore log files
*.log

# Ignore temporary files
*.tmp
*.swp

# Ignore system files
.DS_Store
Thumbs.db
```

---

#### 3. **Create the `LICENSE`**
   - This will define the licensing terms for your project. We'll use the **MIT License** as an example.

```bash
touch LICENSE
```

   - Add the following content for the **MIT License**:

```plaintext
MIT License

Copyright (c) [year] [your name or organization]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

   - Replace `[year]` with the current year and `[your name or organization]` with your name or organization.

---

### **Step 5: Add Files to Git and Commit**
1. Add the files to the staging area:

```bash
git add README.md .gitignore LICENSE
```

2. Commit the files to the local repository:

```bash
git commit -m "Add README, .gitignore, LICENSE, and cleanup script"
```

---

### **Step 6: Push the Code to GitHub**
Now, push your changes to GitHub.

```bash
git push -u origin master  # Pushes to the master branch. If you're using a different branch, replace 'master' with your branch name.
```

---

### **Step 7: Verify on GitHub**
1. Go to your GitHub repository page.
2. Refresh the page to see your files (`README.md`, `.gitignore`, `LICENSE`, and your script) displayed there.

---

### **Final Directory Structure on GitHub:**
Your repository on GitHub should now look like this:

```
my-repo/
├── LICENSE
├── README.md
├── .gitignore
└── ebs_cleanup.sh  # Your script file
```

---

### Additional Tips:
- If you need to update or modify any files, simply make changes locally and commit them again.
- You can always add more details to your `README.md` file to make it even more helpful for users.

Let me know if you have any questions or need further help with any of these steps!
