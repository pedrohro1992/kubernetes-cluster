# 🤖 Cluster Agents & Operators

This document outlines the various agents and operators managed by Terraform within the homelab Kubernetes cluster. These components are responsible for orchestrating infrastructure, managing workloads, and maintaining the desired state of the cluster.

---

## 🏗️ Core Infrastructure Agents

### 🌐 Calico (Tigera Operator)
*   **Module**: `modules/calico`
*   **Purpose**: Manages the installation and lifecycle of Calico CNI, providing networking and network security (NetworkPolicies) for the cluster.
*   **Helm Chart**: `tigera-operator` (Repository: `https://docs.tigera.io/calico/charts`)
*   **Version**: `v3.31.3`
*   **Namespace**: `tigera-operator`

### 💾 OpenEBS
*   **Module**: `modules/open-ebs`
*   **Purpose**: A storage orchestrator that provides local persistent volumes by mapping host directories to the cluster nodes.
*   **Helm Chart**: `openebs` (Repository: `https://openebs.github.io/openebs`)
*   **Version**: `4.1.3`
*   **Namespace**: `openebs`

---

## ⚙️ Operational Operators

### 🗄️ CloudNativePG
*   **Module**: `modules/cloudnative-pg`
*   **Purpose**: An operator for managing PostgreSQL clusters. It handles high availability, backups, and scaling of PostgreSQL instances.
*   **Helm Chart**: `cloudnative-pg` (Repository: `https://cloudnative-pg.github.io/charts`)
*   **Version**: `0.22.1`
*   **Namespace**: `cnpg-system`

### 🔐 External Secrets Operator
*   **Module**: `modules/external-secrets-operator`
*   **Purpose**: Synchronizes secrets from external APIs (like HashiCorp Vault, AWS Secrets Manager, etc.) into Kubernetes Secrets.
*   **Helm Chart**: `external-secrets` (Repository: `https://charts.external-secrets.io`)
*   **Version**: `2.0.1`
*   **Namespace**: `external-secrets`

### 🧶 Vaultweaver
*   **Module**: `modules/vaultweaver`
*   **Purpose**: An operator used for creating roles and policies for Kubernetes resources within HashiCorp Vault. It manages Vault authentication and policy integration.
*   **Type**: Terraform-managed Vault Configuration / Operator
*   **Namespace**: `vaultweaver` (Service Account: `vaultweaver-operator`)

### 🚀 Platform Operator
*   **Module**: `modules/platform-operator`
*   **Purpose**: A custom operator designed for managing platform-specific resources and CRDs.
*   **Helm Chart**: `platform-operator` (Repository: `oci://registry-1.docker.io/opedroramos`)
*   **Version**: `2.0.2` (Image tag: `2.0`)
*   **Namespace**: `platform-system`

---

## 🛣️ Traffic & Access Control

### 🚦 Ingress NGINX Controller
*   **Module**: `modules/ingress-nginx`
*   **Purpose**: An Ingress controller that uses NGINX as a reverse proxy and load balancer to manage external access to services in the cluster.
*   **Helm Chart**: `ingress-nginx` (Repository: `https://kubernetes.github.io/ingress-nginx`)
*   **Version**: `4.10.0`
*   **Namespace**: `ingress-nginx`

---

## 📝 Summary Table

| Agent / Operator | Namespace | Version | Repository |
| :--- | :--- | :--- | :--- |
| **Calico (Tigera)** | `tigera-operator` | `v3.31.3` | `https://docs.tigera.io/calico/charts` |
| **OpenEBS** | `openebs` | `4.1.3` | `https://openebs.github.io/openebs` |
| **CloudNativePG** | `cnpg-system` | `0.22.1` | `https://cloudnative-pg.github.io/charts` |
| **External Secrets** | `external-secrets` | `2.0.1` | `https://charts.external-secrets.io` |
| **VaultReaver** | `vaultweaver` | N/A | Local Module |
| **Platform Operator**| `platform-system` | `2.0.2` | `oci://registry-1.docker.io/opedroramos` |
| **Ingress NGINX** | `ingress-nginx` | `4.10.0` | `https://kubernetes.github.io/ingress-nginx` |
