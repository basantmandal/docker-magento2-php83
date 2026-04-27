<div align="center">
  <h1>Docker HK2 Magento PHP 8.3</h1>
  <b>A comprehensive Docker environment for Magento 2.4.8 using PHP 8.3.</b>

  <img src="https://img.shields.io/badge/version-3.0.0-blue?style=flat-square" alt="Version">
  <img src="https://img.shields.io/badge/Magento-2.4.8-EE672F?style=flat-square&logo=magento&logoColor=white" alt="Magento Version">
  <img src="https://img.shields.io/badge/PHP-8.3+-777BB4?style=flat-square&logo=php&logoColor=white" alt="PHP Version">
  <img src="https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white" alt="Docker">
  <img src="https://img.shields.io/badge/license-OSL--3.0-green?style=flat-square" alt="License">

  <br>

  <a href="https://www.basantmandal.in/"><img src="https://img.shields.io/badge/Website-000?style=flat-square&logo=ko-fi&logoColor=white" alt="Website"></a>
  <a href="https://www.linkedin.com/in/basantmandal/"><img src="https://img.shields.io/badge/LinkedIn-0A66C2?style=flat-square&logo=linkedin&logoColor=white" alt="LinkedIn"></a>
  <a href="https://github.com/basantmandal/Docker_HK2_Magento_PHP8.3"><img src="https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github" alt="GitHub"></a>
  <a href="mailto:support@basantmandal.in"><img src="https://img.shields.io/badge/Email-support%40basantmandal.in-blue?style=flat-square&logo=gmail" alt="Email"></a>
</div>

---

## 📄 Overview

This repository provides a robust and scalable Docker-based development environment specifically tailored for Magento 2 running on PHP 8.3. It streamlines the setup process and ensures consistency across different development machines.

### 👥 Who is this for?

- Magento 2 Backend Developers
- Magento 2 Frontend Developers
- DevOps Engineers setting up Magento 2 environments

---

## ✨ Key Features

| Feature | Details |
| :--- | :--- |
| 💻 **PHP 8.3 Support** | Fully configured PHP-FPM container running PHP 8.3 optimized for Magento 2. |
| 🔐 **Secure Setup** | Includes sensible security defaults for a development environment. |
| 📦 **All-in-One Infrastructure** | Bundles Nginx, MySQL/MariaDB, Redis, Elasticsearch/OpenSearch, and RabbitMQ. |
| 🧱 **Developer Tools** | Comes with Xdebug, Composer, and other essential CLI tools pre-installed. |

---

## 📋 System Requirements

| Requirement | Minimum Version |
| :--- | :--- |
| **Docker Engine** | 24.0.0+ |
| **Docker Compose** | 2.20.0+ |

> ⚠ **Note:** Ensure you have enough RAM allocated to Docker (at least 6GB recommended) for smooth Magento 2 operation.

---

## 🚀 Installation

### Using Docker Compose — Recommended

```bash
git clone git@github.com:basantmandal/docker-magento2-php83.git
cd docker-magento2-php83
docker compose up -d
```

### Manual Installation

**1. Prerequisites**
Clone the repository and ensure you have your Magento 2 source code ready.

**2. Configuration**
Copy the example `.env` file and adjust the variables according to your local setup.

**3. Start Services**
Run the standard docker compose command to bring up the environment.

> ⚠ **Security Warning:** Do not use these default configurations in a production environment. Ensure you change all default passwords.

---

## ⚙️ Configuration

| Service | Version | Purpose |
| :--- | :--- | :--- |
| **PHP-FPM** | 8.3 | Executes Magento PHP code |
| **Nginx** | 1.24+ | Web server for handling HTTP requests |
| **MySQL / MariaDB** | 8.0+ / 10.6+ | Database management system |
| **Redis** | 7.0+ | Session and cache storage |
| **Elasticsearch/OpenSearch** | 7.17+ / 2.5+ | Search engine backend for Magento catalog |
| **RabbitMQ** | 3.12+ | Message queue system |

---

## 🎯 Demo Pages

This is an infrastructure project, so it does not include frontend demo pages. Once Magento is installed using this Docker setup, you can access your local Magento storefront.

---

## 🔒 Content Security Policy (CSP)

This environment is designed to work with Magento's default CSP modules. If you need to allow external resources in your local environment, you may need to configure the Magento CSP settings accordingly.

---

## 🔐 Privacy & GDPR

This is a local development environment. By default, no user data is collected or sent externally. If you load production data into this environment, ensure you comply with your organization's data protection policies and sanitize sensitive customer information.

---

## 📚 Documentation

| Document | Purpose |
| :--- | :--- |
| [**README.md**](./README.md) | Main project overview and setup instructions |
| [**CONTRIBUTING.md**](./.github/CONTRIBUTING.md) | Guidelines for contributing to the project |
| [**SECURITY.md**](./SECURITY.md) | Security policy and vulnerability reporting |

---

## ⚠️ Known Limitations

- Running this on Windows using WSL2 or macOS might have slight performance overheads due to file system syncing compared to native Linux.
- Does not currently support automated SSL certificate generation out-of-the-box (HTTP only).

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](./.github/CONTRIBUTING.md) for details on how to submit pull requests, report issues, and suggest improvements.

---

## 📄 License

This project is licensed under the OSL-3.0 License. See the [LICENCE.txt](./LICENCE.txt) file for details.

---

## ⚖️ Disclaimer

This Docker environment is provided "as is", without warranty of any kind. Use it at your own risk. The author is not responsible for any data loss or issues that may arise from using this setup.

---

<div align="center">
  <b>Basant Mandal</b><br>
  <i>Full Stack Developer</i><br><br>

  <a href="https://www.basantmandal.in/"><img src="https://img.shields.io/badge/Website-000?style=flat-square&logo=ko-fi&logoColor=white" alt="Website"></a>
  <a href="https://www.linkedin.com/in/basantmandal/"><img src="https://img.shields.io/badge/LinkedIn-0A66C2?style=flat-square&logo=linkedin&logoColor=white" alt="LinkedIn"></a>
  
  <br>

  ---
  > *Copyright © 2026 Basant Mandal. All rights reserved.*
</div>
