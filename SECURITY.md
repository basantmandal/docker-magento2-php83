# Security Policy

## Supported Versions

| Version | Status | Support Level |
| :--- | :--- | :--- |
| Latest stable | ✅ Supported | Active security updates & patches |
| Previous major | ⚠️ Limited | Critical vulnerabilities only |
| End-of-life (EOL) | ❌ Unsupported | No security updates |

> 🔒 **Best Practice:** Always keep your dependencies up to date and use the latest stable version of this project.

## Reporting a Vulnerability

If you discover a security vulnerability within this project, please report it privately.
Do not open a public issue.

Please send an email to `support@basantmandal.in` with the details of the vulnerability.
Include steps to reproduce, potential impact, and any other relevant information.
We will respond to your report as quickly as possible.

## What to Expect

1. We will acknowledge receipt of your report within 48 hours.
2. We will investigate the issue and determine its validity and severity.
3. If confirmed, we will develop a patch and release a new secure version.
4. We maintain confidentiality until the patch is released.

## Scope

This security policy applies to the Docker configurations and scripts provided in this repository. Vulnerabilities in Magento, PHP, or other third-party software should be reported to their respective maintainers, although we will do our best to update our configurations to mitigate such issues if possible.

## Security Best Practices for Users

- **Environment Variables:** Never commit sensitive information (like passwords or API keys) to the repository. Use `.env` files and ensure they are added to `.gitignore`.
- **Network Security:** Restrict access to exposed ports (e.g., using UFW or firewall rules) and do not expose sensitive services directly to the public internet without proper authentication and encryption.
- **Regular Updates:** Keep your Docker images, Magento installation, and server OS updated with the latest security patches.

## Contact Information

| Purpose | Contact |
| :--- | :--- |
| Security Reports | <support@basantmandal.in> |
| General Inquiries | <support@basantmandal.in> |

## Acknowledgment

We deeply appreciate the efforts of the security community in helping us keep this project safe and secure.

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
