<div align="center">

  <h1>HK2 Magento PHP 8.3 FPM</h1>
  <b>PHP 8.3 FPM Docker environment specifically optimized for Magento 2.4.8</b><br><br>

  <img src="https://img.shields.io/badge/version-2.1-blue?style=flat-square" alt="Version">
  <img src="https://img.shields.io/badge/Magento-2.4.8-blue?style=flat-square" alt="Magento Version">
  <img src="https://img.shields.io/badge/PHP-8.3-blue?style=flat-square" alt="PHP Version">
  <img src="https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white" alt="Docker">
  <img src="https://img.shields.io/badge/license-OSL--3.0-green?style=flat-square" alt="License">
  <br>
  <a href="https://github.com/basantmandal/docker-magento2-php83"><img src="https://img.shields.io/badge/github-repo-blue?logo=github&style=flat-square" alt="Github Repository"></a>
  <a href="https://www.basantmandal.in/"><img src="https://img.shields.io/badge/Website-000?style=flat-square&logo=ko-fi&logoColor=white" alt="Website"></a>
  <a href="https://www.linkedin.com/in/basantmandal/"><img src="https://img.shields.io/badge/LinkedIn-0A66C2?style=flat-square&logo=linkedin&logoColor=white" alt="LinkedIn"></a>
  <a href="mailto:support@basantmandal.in"><img src="https://img.shields.io/badge/Email-support%40basantmandal.in-ea4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>
</div>

---

## 📄 Overview

The HK2 Magento PHP 8.3 FPM project provides a highly optimized, fully configured PHP 8.3 FPM Docker image specifically designed to run Magento 2.4.8 environments. It includes all necessary PHP extensions, Composer 2.x, IonCube loaders (with automatic architecture detection for Mac compatibility), and built-in MSMTP support for email routing.

### 👥 Who is this for?

- Magento 2 Backend and Frontend Developers
- DevOps Engineers managing Magento environments
- E-commerce technical agencies running legacy Magento 2 versions on modern hardware (including Apple Silicon)

---

## ✨ Key Features

| Feature | Details |
| :--- | :--- |
| 💻 **Multi-Architecture Support** | Fully compatible with standard servers (`linux/amd64`) and Apple Silicon Macs/ARM devices (`linux/arm64`) with automated IonCube loader switching. Images are built natively via Docker Buildx. |
| 📦 **Pre-configured Extensions** | Includes essential Magento 2 PHP extensions: bcmath, gd, intl, pdo_mysql, soap, xsl, zip, redis, and optional xdebug. |
| 🧱 **Developer Tools** | Comes pre-installed with Composer 2.x, image optimization tools (jpegoptim, optipng), Git, and msmtp for email interception. |
| 🔐 **Optimized Configurations** | Pre-tuned `php.ini` with 2GB memory limit, increased execution times, and optimal upload sizes for heavy Magento operations. |

---

## 📋 System Requirements

| Requirement | Minimum Version |
| :--- | :--- |
| **Docker Engine** | 20.10.0+ |
| **Docker Compose** | 2.0.0+ |
| **Hardware** | 4GB RAM minimum (8GB recommended for Magento 2) |

> ⚠ **Note:** This container requires an external web server (Nginx/Apache) to proxy requests to the FPM daemon on port 9000.

---

## 🚀 Installation & Usage

### 1. Using Pre-built Image from Docker Hub (Recommended)

The simplest way to use this environment is to pull the pre-built, multi-architecture image directly from Docker Hub:

```bash
docker pull basantmandal/hk2-php8.3-fpm
```

or

```bash
docker pull basantmandal/hk2-php8.3-fpm:latest
```

> Always use the latest tag or don't use any tag, so it gets the latest one.

### 2. Using Docker Compose

Add the following service to your `docker-compose.yml`:

```yaml
services:
  php:
    image: basantmandal/hk2-php8.3-fpm
    build:
      context: .
      args:
        - INSTALL_XDEBUG=false  # Set to true to install Xdebug
    volumes:
      - ./src:/var/www/html
      - ./php/conf.d/99-custom.ini:/usr/local/etc/php/conf.d/99-custom.ini
    ports:
      - "9000:9000"
```

### 3. Local Development & Testing

If you need to build the image locally or modify configurations:

**Clone the repository:**

```bash
git clone https://github.com/basantmandal/docker-magento2-php83.git
cd docker-magento2-php83
```

**Build the image locally (no cache):**

```bash
./local_build.sh
```

**Run Automated Validation Tests:**
Ensure PHP version, required extensions, Composer, and IonCube loaded correctly within the container:

```bash
./scripts/test.sh
```

**Push to Docker Hub (Maintainers):**

```bash
./scripts/local_upload_image.sh
```

> ⚠ **Security Warning:** Do not expose the FPM port (9000) publicly to the internet. Keep it internal to the Docker network.

---

## ⚙️ Configuration

| Service | Version | Purpose |
| :--- | :--- | :--- |
| **PHP FPM** | 8.3.x | Core application processing for Magento. |
| **Composer** | 2 | Dependency management optimized for older Magento versions. |
| **IonCube** | Latest | Required for running encrypted third-party extensions. |

---

## 🔒 Content Security Policy (CSP)

This image relies on your web server (Nginx/Apache) or Magento application to configure and enforce Content Security Policies. Ensure your web server passes appropriate CSP headers.

---

## 🔐 Privacy & GDPR

This container image does not independently collect, store, or transmit any personally identifiable information (PII). All log outputs are written to standard output (`stdout`/`stderr`) and managed locally by your Docker daemon.

---

## 📚 Documentation

| Document | Purpose |
| :--- | :--- |
| [**SECURITY.md**](./SECURITY.md) | Security vulnerability reporting policy and guidelines. |
| [**CONTRIBUTING.md**](./.github/CONTRIBUTING.md) | Instructions and rules for contributing to the repository. |
| [**Dockerfile**](./Dockerfile) | Source configurations for the Docker container build. |

---

## ⚠️ Known Limitations

- Running PHP 8.3 means this environment is meant for **modern** operations and should be used for Magento 2.4.7+ projects. For legacy projects requiring older PHP versions, please use the appropriate legacy image.
- Xdebug is turned off by default (`INSTALL_XDEBUG=false`) to prevent performance penalties in production-like environments.

---

## 🤝 Contributing

We actively welcome contributions! Please read our [Contributing Guidelines](./.github/CONTRIBUTING.md) to understand how to submit bug reports, feature requests, and pull requests.

---

## 📄 License

This project is licensed under the OSL 3.0 License. See the [LICENSE](LICENSE) file for details.

---

## ⚖️ Disclaimer

The author provides this Docker image "as is" without any warranties. Users are responsible for ensuring that running this environment complies with their internal security and software requirements.

---

<div align="center">
  <b>Basant Mandal</b><br>
  <i>Full Stack Developer</i><br><br>

  <a href="https://www.basantmandal.in/"><img src="https://img.shields.io/badge/Website-000?style=flat-square&logo=ko-fi&logoColor=white" alt="Website"></a>
  <a href="https://www.linkedin.com/in/basantmandal/"><img src="https://img.shields.io/badge/LinkedIn-0A66C2?style=flat-square&logo=linkedin&logoColor=white" alt="LinkedIn"></a>
<a href="mailto:support@basantmanda.in">
    <img src="https://img.shields.io/badge/Email-support%40basantmandal.in-blue?style=flat-square&logo=gmail" alt="Email">
</a>
  <br>

  ---
  > *Copyright © 2026 Basant Mandal. All rights reserved.*
</div>
