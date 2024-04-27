1. Clone the Repository
First, clone the repository to your local machine using the following command:

```bash
git clone https://github.com/iesodias/startup-setup.git
```
2. Install Azure CLI
If you don't already have Azure CLI installed on your machine, follow the installation instructions according to your operating system:

For Windows: Install Azure CLI on Windows
For macOS: Install Azure CLI on macOS
For Linux: Install Azure CLI on Linux
3. Log in to Azure CLI
After installing Azure CLI, open your terminal and log in to your Azure account with the command:
```bash
az login
```
Follow the instructions in the terminal to enter your credentials and complete the login process.
4. Change Permissions and Execute the Script
Navigate to the directory where you cloned the repository and access the createvm.sh script. Before executing it, ensure that it has execution permission:
```bash
cd startup-setup
```
chmod +x createvm.sh
Next, open the createvm.sh file in a text editor and modify the user (username) and password (password) information as needed for VM creation.
Finally, execute the script with the following command:
```bash
./createvm.sh
```
5. Access the VM via SSH
After executing the script, you will be provided with the VM's IP address. Use the following SSH command to connect to the VM:
```bash
ssh username@vm_ip_address
```
Replace username with the username you set and vm_ip_address with the VM's IP address provided by the script.

With these steps, you'll be able to execute the script and access the VM created in your Azure account. Make sure you have the correct credentials and necessary permissions to perform these operations.