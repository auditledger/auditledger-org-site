# Audit Ledger Documentation Site

Public documentation site for Audit Ledger, built with MkDocs and Material for MkDocs, deployed to GitHub Pages.

## 🚀 Overview

This repository hosts the complete documentation for Audit Ledger, including:

- Getting started guides and quick start
- Complete API reference (.NET SDK)
- Framework Helpers (SOC 2, HIPAA, PCI DSS)
- Deployment guides and configuration
- Storage provider integrations (AWS S3, Azure Blob)
- Monitoring and observability

**Live Site**: [https://auditledger.github.io](https://auditledger.github.io)

## 📋 Prerequisites

- Python 3.11 or higher
- pip (Python package manager)
- Git

## 🛠️ Local Development

### Installation

1. Clone the repository:

```bash
git clone https://github.com/auditledger/auditledger.git
cd auditledger
```

2. Set up Python virtual environment and install dependencies:

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Running Locally

#### Option 1: Using the Management Script (Recommended)

The project includes a management script that handles virtual environment activation, process management, and logging:

```bash
# Make script executable (first time only)
chmod +x start-mkdocs.sh

# Start the server
./start-mkdocs.sh start

# Check server status
./start-mkdocs.sh status

# View logs
./start-mkdocs.sh logs

# Stop the server
./start-mkdocs.sh stop

# Restart the server
./start-mkdocs.sh restart

# Get help
./start-mkdocs.sh help
```

The server will run in the background on [http://127.0.0.1:8000](http://127.0.0.1:8000)

#### Option 2: Manual MkDocs Command

Activate the virtual environment and start the development server:

```bash
source venv/bin/activate
mkdocs serve
```

The site will be available at [http://127.0.0.1:8000](http://127.0.0.1:8000)

Changes to documentation files will automatically reload in your browser.

### Building

Build the static site:

```bash
source venv/bin/activate
mkdocs build
```

The built site will be in the `site/` directory (ignored by git).

For strict building (fails on warnings):

```bash
source venv/bin/activate
mkdocs build --strict
```

## 📁 Repository Structure

```
.
├── docs/                      # Documentation source files
│   ├── index.md              # Homepage
│   ├── getting-started/      # Getting started guides
│   │   ├── overview.md      # Overview and concepts
│   │   ├── concepts.md       # Core concepts
│   │   └── quick-start.md    # Quick start guide
│   ├── api/                  # API reference
│   │   ├── overview.md       # API overview
│   │   ├── classes.md        # Classes and types
│   │   ├── soc2-events.md   # SOC 2 Framework Helpers
│   │   ├── hipaa-events.md  # HIPAA Framework Helpers
│   │   └── pcidss-events.md # PCI DSS Framework Helpers
│   ├── deployment/           # Deployment guides
│   │   ├── overview.md      # Deployment overview
│   │   ├── configuration.md # Configuration guide
│   │   └── integrations.md  # Storage integrations
│   ├── dashboards/           # Monitoring documentation
│   │   └── overview.md      # Monitoring and observability
│   ├── assets/               # Images and other assets
│   │   └── logo.png         # Site logo
│   └── stylesheets/          # Custom CSS
│       └── extra.css        # Custom styling
├── .github/
│   └── workflows/            # GitHub Actions workflows
├── .plans/                   # Planning documents
├── mkdocs.yml                # MkDocs configuration
├── requirements.txt          # Python dependencies
├── start-mkdocs.sh          # Development server script
└── README.md                 # This file
```

## 📝 Documentation Updates

This documentation site is maintained by the Audit Ledger team. For feedback, bug reports, or feature suggestions:

- Open an issue in the relevant repository
- Provide clear descriptions and examples
- Include steps to reproduce for bugs

### Local Testing

Before submitting feedback, you can test documentation changes locally:

1. Clone this repository
2. Set up the development environment (see Local Development above)
3. Make your changes
4. Test locally (`mkdocs serve` or `./start-mkdocs.sh start`)
5. Verify the changes render correctly

## 🔄 Deployment

The site is automatically built and deployed to GitHub Pages when changes are pushed to the `main` branch via GitHub Actions.

### Deployment Workflow

1. Push to `main` branch
2. GitHub Actions builds the site using MkDocs
3. Site is deployed to GitHub Pages
4. Changes are live at the configured domain

## 📦 Tech Stack

- **[MkDocs](https://www.mkdocs.org/)** - Static site generator
- **[Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)** - Modern documentation theme
- **Python 3.11+** - Runtime environment
- **GitHub Actions** - CI/CD automation
- **GitHub Pages** - Static site hosting

### Key Features

- Modern Material Design UI
- Tabbed content for API documentation
- Code syntax highlighting
- Responsive mobile design
- Search functionality
- Custom branding and styling

## 🔗 Related Resources

- [Audit Ledger GitHub Organization](https://github.com/auditledger)
- [Audit Ledger .NET SDK](https://github.com/auditledger/auditledger-dotnet)
- [Product Website](https://auditledger.io)

## 📞 Support & Feedback

- **Issues**: [GitHub Issues](https://github.com/auditledger/auditledger/issues) - Report documentation bugs or suggest improvements
- **Discussions**: [GitHub Discussions](https://github.com/auditledger/auditledger/discussions) - Ask questions and share feedback

## 📄 License

This documentation site is part of the Audit Ledger project. See the main repository for license details.

---

**Note**: This is a public repository. Please ensure no sensitive internal information is included in documentation.
