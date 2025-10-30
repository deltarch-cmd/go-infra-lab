# Go Infra Lab

A personal DevOps learning project where I build and deploy a Go web app inside a self-hosted Proxmox environment.  

The project covers provisioning, containerization, CI/CD with GitHub Actions, and future automation using Ansible and Terraform.

## Objectives

The main objective of this project is to learn the workflow of DevOps while doing other useful stuff.

The idea is to first deploy the simple HTTP server (with Nginx and HTTPS) on my own Ubuntu Server hosted on Proxmox and later deploy it using Ansible and Terraform. All of this process will be version controlled and integrated with Github Actions (CI/CD).

## Tools and Technologies
- **Proxmox VE** - Virtualization
- **Ubuntu Server** - Host OS
- **Go** - Application backend
- **Podman/Docker** - Containerization
- **Github Actions** - CI/CD (planned)
- **Ansible and Terraform** - Automation and infraestructure as Code (planned)

## Progress
### Proxmox

The Proxmox install doesn't have anything special. Download the ISO, install Proxmox VE and that's it.

### Ubuntu Server

Installed Ubuntu Server as a VM in Proxmox using the standard setup.

Once the server is installed, enable SSH:
```bash
sudo apt update
sudo apt install openssh-server
sudo systemctl enable --now ssh
```

Now is possible to access the server from the main machine.

#### Static IP

Setting a static IP address is useful because it will make connecting to the server from outside predictable and easy.

The newer Ubuntu Server versions use **Netplan** to manager the network services, so is needed to modify the file `/etc/netplan/50-cloud-init.yaml` to set an static IP address.

In my case, the resulting file looks like this:
```yaml
network:
  version: 2
  ethernets:
    ens18:
      dhcp4: false
      addresses:
        - 192.168.1.135/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses: [1.1.1.1, 8.8.8.8]
```

Apply the plan to make the changes:
```bash
sudo netplan apply
```

#### UFW

To make the server more secure, I configured UFW to:
- Allow SSH
- Allow network trafic (HTTP/HTTPS)
- Block the rest by default

To achieve that, the following changes are applied:
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing

# SSH and Web
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Enable and apply rules
sudo ufw enable
```

### Go application

The Go app will be a very simple HTTP server. Right now it just outputs some text. The goal is to extend it with logging and environment variable handling for a more realistic setup.

### Containerization

I created a `Dockerfile` to build the image for the Go app and also added a script under `/scripts` to quickly deploy the container.

## Next steps
- [ ] Nginx reverse proxy + HTTPS (Let's Encrypt)
- [ ] Automate deployment with Github Actions (CI/CD)
- [ ] Provision and configure server using Ansible
- [ ] Manager infraestructure with Terraform
