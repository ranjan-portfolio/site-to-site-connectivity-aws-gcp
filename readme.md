# 🌐 GCP ↔ AWS HA VPN with Terraform (Fully Automated)

<img width="1081" height="521" alt="AWS-GCP-Site-to-Site" src="https://github.com/user-attachments/assets/20e16c13-1af4-4043-941c-bb954299ff52" />


Provision a **production-grade, highly available Site-to-Site VPN** between **Google Cloud Platform (GCP)** and **Amazon Web Services (AWS)** using Terraform — with **zero manual steps**.

This project demonstrates how to leverage Terraform’s dependency graph to fully automate a traditionally manual, error-prone setup involving IPSec tunnels, BGP routing, and cross-cloud dependencies.

---

## 🚀 Features

- 🔐 End-to-end encrypted IPSec VPN
- 🌍 Multi-cloud connectivity (GCP ↔ AWS)
- 🔁 High Availability architecture (4 tunnels)
- 📡 Dynamic routing with BGP
- ⚙️ Fully automated Terraform deployment
- 🔑 No hardcoded secrets (PSKs generated and consumed automatically)
- 🧠 Dependency graph-driven orchestration

---

## 🏗️ Architecture

**GCP**
- Custom VPC with public & private subnets
- HA VPN Gateway (2 interfaces)
- Cloud Router (BGP)

**AWS**
- VPC with public & private subnets
- Virtual Private Gateway (VGW)
- 2 Customer Gateways
- 2 VPN Connections (each with 2 tunnels)

**Connectivity**
- 4 IPSec tunnels total
- BGP sessions over each tunnel
- ECMP for load balancing and failover

---

## 🔄 How It Works

Terraform orchestrates the full lifecycle:

1. Create GCP VPC and HA VPN Gateway  
2. Use GCP gateway IPs to create AWS Customer Gateways  
3. Create AWS VPN connections (auto-generates PSKs & tunnel configs)  
4. Feed AWS outputs (PSKs, IPs, BGP ranges) into GCP  
5. Create GCP VPN tunnels and BGP peers  

✅ All of this happens in a **single `terraform apply`**

---

## 📁 Project Structure
├── main.tf # Root orchestration
├── provider.tf # AWS & GCP providers
├── outputs.tf # Outputs for testing
├── modules/
│ ├── gcp-vpc/ # GCP VPC + subnets + firewall
│ ├── gcp-network/ # HA VPN, Cloud Router, tunnels, BGP
│ ├── gcp-ec2/ # GCP VM instance
│ ├── vpc/ # AWS VPC + VPN + networking
│ └── ec2/ # AWS EC2 instance

---


---

## ⚙️ Prerequisites

- Terraform ≥ 1.5
- AWS CLI configured
- Google Cloud SDK (gcloud) installed

---

## 🔐 Authentication

```bash
# GCP
gcloud auth application-default login

# AWS
aws configure

terraform init
terraform apply

# Get private IPs
GCP_IP=$(terraform output -raw gcp_vm_private_ip)
AWS_IP=$(terraform output -raw aws_ec2_private_ip)

# SSH into GCP VM
ssh user@$(terraform output -raw gcp_vm_public_ip)

# Test connectivity
ping $AWS_IP
```

✔️ Successful ping = VPN + BGP + routing all working
🚨 IKEv2 is mandatory

AWS defaults to IKEv1 + DH Group 2 (unsupported by GCP).

```hcl
tunnel1_ike_versions = ["ikev2"]
tunnel1_phase1_dh_group_numbers = [14]
```

🔑 PSKs are auto-generated
Retrieved directly from aws_vpn_connection
Passed to GCP without manual handling
Marked as sensitive in Terraform

🔁 Route propagation matters

Ensure VPN routes propagate to:

Public route table
Private route table

🧩 Module separation solves dependency issues
gcp-vpc → no AWS dependency
gcp-network → depends on AWS outputs

This avoids circular dependencies and enables full automation.

📊 Outputs

gcp_vm_private_ip
aws_ec2_private_ip

🧠 Key Learnings
Terraform can orchestrate cross-cloud dependencies seamlessly
AWS exposes VPN configuration as readable attributes
Proper module design is critical for dependency resolution

Silent failures (IKE mismatch) require explicit configuration


📌 Use Cases


Multi-cloud architectures,
Hybrid cloud networking,
Disaster recovery setups,
Cross-cloud service communication
