# 🎓 Course Management - React Frontend

- [🎓 Course Management - React Frontend](#-course-management---react-frontend)
  - [🌐 Live URL](#-live-url)
  - [🧾 Features](#-features)
  - [🚀 Project Structure](#-project-structure)
    - [What's done](#whats-done)
    - [Tech Stack](#tech-stack)
    - [Setup \& Development](#setup--development)
    - [Production Build](#production-build)
    - [Automated using](#automated-using)
  - [Resource React + Vite](#resource-react--vite)


This is the frontend for the Course Management Serverless App, built with **React + Vite** and deployed via **S3 + CloudFront** for high availability and performance.

---

## 🌐 Live URL

Access the deployed app here:  
🔗 [https://course.alhagiebaicham.com](https://course.alhagiebaicham.com)

---

## 🧾 Features

- View all courses
- View course by ID
- Create, update, delete courses
- Integrated with Spring Boot Lambda backend (via API Gateway)
- Responsive UI with Material UI
- Environment-based configuration
- GitHub Actions CI/CD ready

---

## 🚀 Project Structure

```bash
web-s3/
├── public/
├── src/
│   ├── pages/
│   ├── components/
│   ├── config/
│   └── App.jsx
├── index.html
├── vite.config.js
└── .env
```

### What's done

- Host frontend via S3 + CloudFront
- Deploy backend on Lambda + API Gateway
- Use Route53 custom domain
- Enable HTTPS with ACM
- CORS support

### Tech Stack

- Vite
- React
- React Router
- Material UI
- Axios
- AWS S3
- AWS CloudFront
- Terraform

### Setup & Development

- cd web-s3
- npm install
- npm run dev

### Production Build

- npm install
- npm run build
- aws s3 sync dist/ s3://course.alhagiebaicham.com --delete
- aws cloudfront create-invalidation --distribution-id <dist-id> --paths "/*"

### Automated using

- cham207388/github-custom-actions/vite-node@main
- jakejarvis/s3-sync-action
- chetan/invalidate-cloudfront-action

## Resource React + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react/README.md) uses [Babel](https://babeljs.io/) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh
If you are developing a production application, we recommend using TypeScript and enable type-aware lint rules. Check out the [TS template](https://github.com/vitejs/vite/tree/main/packages/create-vite/template-react-ts) to integrate TypeScript and [`typescript-eslint`](https://typescript-eslint.io) in your project.
