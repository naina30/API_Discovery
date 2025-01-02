# API_Discovery
 A tool to help you intrusively discover all the publicly available endpoints for all the subdomains of a parent domain name. We use fuzzing for this and have created a custom wordlist to help bruteforce a substantial amount of probable scenarios. Can be modified for the better in the future so stay tuned! 

 Requirements:

- Install subfinder 
- Install Ffuf 
- Edit the domain name at discover_public_apis.sh script 
- Run on Linux with command ./discover_public_apis.sh after adding the required domain name.
-------------------------------------------------------------------------------------------------------------------------
Installing FFUF
FFUF is a web fuzzing tool written in Go.

Prerequisites:
- Ensure that you have Go installed on your system. Install it with:

sudo apt update && sudo apt install golang -y

- Verify installation:
go version

- Install FFUF: Run the following commands:
go install github.com/ffuf/ffuf/v2@latest

- Add FFUF to PATH:
export PATH=$PATH:$(go env GOPATH)/bin

- Add this line to your shell configuration file (e.g., ~/.bashrc or ~/.zshrc) for persistence:
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
source ~/.bashrc

- Verify Installation:
ffuf -h
--------------------------------------------------------------------------------------------------------------------------
Installing Subfinder
Subfinder is a subdomain discovery tool.

Prerequisites: Subfinder also requires Go. If you haven't installed Go, follow the steps in the FFUF section.

- Install Subfinder: Run:
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

- Add Subfinder to PATH:
export PATH=$PATH:$(go env GOPATH)/bin

- For persistence:
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
source ~/.bashrc

- Verify Installation
  subfinder -h
