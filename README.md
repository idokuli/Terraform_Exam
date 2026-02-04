# Terraform AWS Infrastructure Exam

This repository contains Terraform configurations for provisioning AWS infrastructure, organized into basic setup (Tasks 1 & 2) and advanced modular architecture (Tasks 3, 4 & 5).

## Project Structure

```
Terraform_Exam/
├── Tasks1_2/              # Basic VPC and EC2 setup
├── Tasks3_4_5/            # Modular architecture
│   └── Modules/
│       ├── Custom_vpc_ec2/    # VPC, networking, and base EC2
│       ├── LB_TG_AS/          # Load Balancer & Auto Scaling
│       └── Deployments/       # Main orchestration
└── Answers.txt            # Terraform exam Q&A
```

---

## Tasks 1 & 2: Basic Infrastructure

Simple Terraform setup creating:
- **VPC** with public (`10.0.1.0/24`) and private (`10.0.2.0/24`) subnets
- **Internet Gateway** and routing for public subnet
- **Security Group** allowing SSH (22) and HTTP (80)
- **EC2 Instance** (t3.micro) in public subnet with public IP

**Run from**: `Tasks1_2/`

---

## Tasks 3, 4 & 5: Modular Architecture

Production-ready infrastructure with auto-scaling web servers behind a load balancer.

### Module 1: Custom_vpc_ec2

Creates VPC infrastructure with a bootstrapped EC2 instance.

**Key Features**:
- Dynamic subnet creation across multiple AZs (configurable count)
- Auto-generated SSH key pair (saved as `id_rsa_generated.pem`)
- EC2 instance with Nginx and stress-ng pre-installed
- Serves "Healthy" page at root

**Outputs**: VPC ID, subnet IDs, security group ID, instance ID, key name

---

### Module 2: LB_TG_AS

Auto-scaling infrastructure with load balancing.

**Components**:
1. **Application Load Balancer** - Internet-facing, distributes traffic
2. **Target Group** - Health checks on port 80, path `/`
3. **Custom AMI** - Created from base EC2 instance (includes Nginx)
4. **Launch Template** - User data runs CPU stress test after 3-minute delay
5. **Auto Scaling Group** - Min: 1, Max: 3, Desired: 1
6. **Scaling Policy** - Target tracking at 50% CPU utilization

**Auto-Scaling Logic**:
- New instances trigger CPU load via `stress-ng` for 10 minutes
- When avg CPU > 50%: Scale up (add instances)
- When avg CPU < 50%: Scale down (remove instances)
- Maintains minimum 1 instance

---

### Module 3: Deployments

Orchestrates the deployment by combining both modules.

**Flow**:
1. Creates VPC with 3 subnets, security group, and base EC2 instance
2. Passes VPC resources to LB_TG_AS module
3. Creates load balancer, AMI, and auto-scaling group
4. Configures CPU-based scaling

---

## Usage

### Prerequisites
- Terraform >= 1.0
- AWS CLI configured with credentials
- Appropriate AWS permissions

### Deployment

**Tasks 1 & 2**:
```bash
cd Tasks1_2
terraform init
terraform plan
terraform apply
```

**Tasks 3, 4 & 5**:
```bash
cd Tasks3_4_5/Modules/Deployments
terraform init
terraform plan
terraform apply
```

### Testing Auto-Scaling

```bash
# Get load balancer DNS from outputs
terraform output

# Test the application
curl http://<load-balancer-dns>
# Returns: <h1>Healthy</h1>

# Monitor in AWS Console:
# - CloudWatch: CPU metrics
# - EC2: New instances launching
# - Target Group: Instance registration
```

**Expected Timeline**:
- ~3 min: CPU load starts
- ~5-10 min: Instances scale up to 3
- ~13 min: CPU load stops
- ~15-20 min: Instances scale down to 1

---

## Architecture

```
                    Internet
                       │
                 ┌─────▼─────┐
                 │    ALB    │
                 │ (Port 80) │
                 └─────┬─────┘
                       │
        ┌──────────────┼──────────────┐
        │              │              │
    ┌───▼───┐      ┌───▼───┐      ┌───▼───┐
    │ AZ-1  │      │ AZ-2  │      │ AZ-3  │
    │Subnet │      │Subnet │      │Subnet │
    └───┬───┘      └───┬───┘      └───┬───┘
        │              │              │
    ┌───▼───┐      ┌───▼───┐      ┌───▼───┐
    │ EC2   │      │ EC2   │      │ EC2   │
    │Nginx  │      │Nginx  │      │Nginx  │
    └───────┘      └───────┘      └───────┘
    
    Auto Scaling Group (1-3 instances)
    Scales on CPU > 50%
```

---

## 🔑 Key Concepts Demonstrated

- ✅ Modular Terraform architecture
- ✅ Dynamic resource creation with `count`
- ✅ Multi-AZ deployment for high availability
- ✅ Auto-scaling with target tracking policies
- ✅ Custom AMI creation from running instances
- ✅ Remote provisioning with SSH
- ✅ Load balancing with health checks
- ✅ Infrastructure as Code best practices

---

## Cleanup

```bash
# Tasks 1 & 2
cd Tasks1_2
terraform destroy

# Tasks 3, 4 & 5
cd Tasks3_4_5/Modules/Deployments
terraform destroy
```

> **Note**: AMI may need manual deregistration if destroy fails.

---

## Additional Resources

- **[Answers.txt](file:///Users/idokulishevski/Desktop/Terraform_Exam/Answers.txt)** - Terraform exam Q&A covering fundamentals, state management, modules, AWS configurations, and debugging

---

## Learning Outcomes

This project demonstrates VPC networking, EC2 provisioning, Terraform modules, auto-scaling, load balancing, and Infrastructure as Code best practices for AWS.
