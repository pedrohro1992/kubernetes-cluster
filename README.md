# 🏠 Homelab Kubernetes Cluster

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

A modular, Infrastructure-as-Code (IaC) project using **Terraform** to provision a fully-featured local Kubernetes cluster via **kind** (Kubernetes IN Docker). 

Designed for homelabs and local development, this project creates a robust baseline environment pre-configured with networking, persistent storage, cloud-native databases, and secrets management.

---

## ✨ Features

* **🚀 Automated Provisioning**: Fully declarative cluster lifecycle managed by Terraform.
* **🌐 Networking**: Replaces default networking with **Calico CNI** and injects custom **CoreDNS** zones.
* **💾 Persistent Storage**: Uses **OpenEBS** to provision Local Persistent Volumes mapped directly to your host machine—ensuring your data survives container restarts.
* **🗄️ Databases**: Ships with the **CloudNativePG** operator for modern, resilient PostgreSQL cluster management.
* **🔐 Secrets Management**: Includes **HashiCorp Vault** configured out-of-the-box in High Availability mode, backed by PostgreSQL.
* **⚙️ Extensible Blueprint Architecture**: Modules are orchestrated sequentially via a central `blueprint` module, making it trivial to stamp out new clusters.

---

## 🏗️ Architecture Stack

1. **Kind** (Cluster Provisioner)
2. **CoreDNS** (Custom internal zones)
3. **Calico** (Network Plugin / CNI)
4. **OpenEBS** (StorageClass `openebs-local`)
5. **Platform Operator** (Custom Custom Resource definitions)
6. **CloudNativePG** (PostgreSQL operator)
7. **HashiCorp Vault** (Secrets Backend)

---

## 🛠️ Prerequisites

Ensure you have the following installed on your local machine:
* [Docker](https://docs.docker.com/get-docker/) (Ensure the daemon is running)
* [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.0.0)
* [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)

---

## 🚀 Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/pedrohro1992/kubernetes-cluster.git
   cd kubernetes-cluster
   ```

2. **Navigate to the target environment:**
   ```bash
   cd clusters/kind/homelab-infra-services
   ```

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Review the deployment plan:**
   ```bash
   terraform plan
   ```

5. **Apply the configuration to spin up the cluster:**
   ```bash
   terraform apply
   ```
   *(Type `yes` when prompted)*

6. **Access your cluster:**
   Terraform will automatically generate the kubeconfig context for your new kind cluster.
   ```bash
   kubectl get nodes
   kubectl get pods -A
   ```

---

## 📂 Project Structure

```text
.
├── clusters/
│   └── kind/
│       └── homelab-infra-services/  # Environment entrypoint (main.tf)
├── modules/
│   ├── blueprint/                   # Master module that sequences dependencies
│   ├── calico/                      # Calico CNI deployment
│   ├── cloudnative-pg/              # PostgreSQL Operator
│   ├── coredns-config/              # Internal DNS routing
│   ├── kind/                        # Kind cluster & host storage logic
│   ├── open-ebs/                    # Local Persistent Volumes
│   ├── platform-operator/           # Custom CRDs
│   ├── postgresql/                  # PostgreSQL deployment
│   ├── ingress-nginx/               # Ingress Controller
│   ├── external-secrets-operator/   # External Secrets synchronization
│   └── vaultweaver/                 # Vault Policy & Role Operator
└── README.md
```

---

## 🧹 Teardown

To destroy the cluster and all associated resources:

```bash
cd clusters/kind/homelab-infra-services
terraform destroy
```

> **Note**: Because OpenEBS maps storage to your host machine (`/data/kind-storage/`), you may need to manually clean up that directory if you want a completely fresh state.
