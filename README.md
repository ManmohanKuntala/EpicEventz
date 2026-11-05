# 🎟️ EpicEventz – Salesforce Event Management Platform

A Salesforce-based event management platform designed to simplify event discovery, ticket booking, payment tracking, attendee management, and event operations through a unified experience.

EpicEventz connects event organizers and attendees using Salesforce Experience Cloud, Lightning Web Components (LWC), Apex, and Salesforce Flows.

## 🚀 Project Overview

Managing events often involves disconnected systems for registrations, ticket sales, payments, attendee verification, and feedback.

EpicEventz addresses these challenges by bringing important event management operations together on the Salesforce platform.

The project demonstrates how Salesforce CRM capabilities, automation, and custom development can be combined to create an integrated event management solution.
## 📸 Application Screenshots

### 🏠 Homepage
![EpicEventz Homepage](screenshots/homepage.png)

### 🎟️ Attendee Page
![EpicEventz Attendee Page](screenshots/attendeepage.png)

### 📊 Organizer Dashboard
![EpicEventz Organizer Page](screenshots/organizerpage.png)

## ✨ Key Features

### 1. Event Discovery
- Browse available events through a custom Lightning Web Component.
- View event information and available ticket options.
- Display event listings through the Experience Cloud interface.

### 2. Ticket Booking
- Select an event and ticket type.
- Enter attendee information.
- Create and manage attendee ticket records.
- Generate ticket confirmation details.

### 3. Simulated Payment Management
- Record payment information associated with tickets.
- Demonstrate payment success and status tracking.
- Support simulated payment methods for project demonstration.

**Note:** This project uses simulated payments. It does not process real financial transactions or connect to a live payment gateway.

### 4. Ticket Management and QR Verification
- Manage existing bookings and tickets.
- Support ticket cancellation.
- Generate QR-based ticket verification information.
- Validate ticket codes during entry verification.
- Prevent duplicate check-ins by recognizing tickets that have already been checked in.

### 5. Organizer Management
- Provide organizer-facing event management components.
- Track ticket sales and event-related information.
- Support event financial tracking through payment and expense records.

### 6. Feedback and Support Automation
- Collect attendee feedback and ratings.
- Categorize feedback based on sentiment.
- Automatically create high-priority support cases for negative feedback.

### 7. Reports and Analytics
- Track event performance and ticket sales.
- Monitor payment and expense information.
- Analyze attendee feedback through Salesforce reports.

## 🏗️ Technology Stack

| Technology | Purpose |
|---|---|
| Salesforce Platform | Application backend and CRM |
| Salesforce Experience Cloud | User-facing event experience |
| Lightning Web Components | Custom user interfaces |
| Apex | Server-side business logic |
| Salesforce Flows | Workflow automation |
| SOQL | Salesforce data retrieval |
| Salesforce Custom Objects | Structured event and ticket data |
| VS Code | Development environment |
| Salesforce CLI | Deployment and metadata management |
| Git and GitHub | Version control |

## 🗂️ Salesforce Data Model

The project includes the following custom objects:

| Object | Purpose |
|---|---|
| Event | Stores event details and performance information |
| Ticket | Stores attendee ticket and booking information |
| Ticket Type | Defines ticket categories, pricing, and quantities |
| Payment | Tracks payment records and statuses |
| Venue | Stores event venue information |
| Expense | Tracks event-related expenses |
| Feedback | Stores attendee ratings and comments |

## ⚙️ Project Architecture

EpicEventz uses Salesforce as its central application platform.

**Frontend**
- Salesforce Experience Cloud
- Lightning Web Components

**Business Logic**
- Apex controllers and services
- Salesforce Screen Flows
- Record-triggered automation

**Data Layer**
- Salesforce custom objects
- Custom fields and relationships
- SOQL queries

**Workflow**

Event Discovery → Ticket Selection → Attendee Registration → Ticket Creation → Simulated Payment → Booking Confirmation → Ticket Verification → Feedback Collection

## 📁 Project Structure

```text
EpicEventz/
│
├── config/
│   └── project-scratch-def.json
│
├── force-app/
│   └── main/
│       └── default/
│           ├── classes/
│           ├── flows/
│           ├── lwc/
│           └── objects/
│
├── manifest/
│   └── package.xml
│
├── scripts/
│   ├── apex/
│   └── soql/
│
├── .forceignore
├── .gitignore
├── package.json
├── sfdx-project.json
└── README.md
```

## 🛠️ Setup and Installation

### Prerequisites

- A Salesforce Developer Edition org.
- Salesforce CLI.
- Visual Studio Code.
- Salesforce Extension Pack.
- Git.

### 1. Clone the repository

```bash
git clone https://github.com/ManmohanKuntala/EpicEventz.git
```

### 2. Navigate to the project

```bash
cd EpicEventz
```

### 3. Authorize your Salesforce org

```bash
sf org login web --alias EpicEventzOrg
```

### 4. Set your target org

```bash
sf config set target-org=EpicEventzOrg
```

### 5. Deploy project metadata

```bash
sf project deploy start
```

After deployment, complete any required Salesforce org configuration, Experience Cloud site setup, permissions, and activation steps before testing the application.

## 🔒 Important Notes

- Payment functionality is simulated for demonstration purposes.
- A Salesforce development org is required to run the application.
- Access to application features depends on the configured Salesforce permissions and Experience Cloud settings.
- Deployment may require additional org-specific configuration.

## 🎯 Project Objective

The objective of EpicEventz is to demonstrate practical Salesforce development skills by combining CRM data management, custom user interfaces, Apex programming, and workflow automation into a unified event management application.

## 👨‍💻 Developer

**Manmohan Kuntala**

B.Tech – Computer Science and Engineering (Data Science)

Vidya Jyothi Institute of Technology

- GitHub: [ManmohanKuntala](https://github.com/ManmohanKuntala)
- Project Repository: [EpicEventz](https://github.com/ManmohanKuntala/EpicEventz)

---

⭐ If you find this project interesting, feel free to explore the repository and its implementation.
