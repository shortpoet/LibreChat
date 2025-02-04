---
title: 🔥 Firebase CDN Setup
description: This document provides instructions for setting up Firebase CDN for LibreChat
weight: -6
---

# Firebase CDN Setup

## Steps to Set Up Firebase

1. Open the [Firebase website](https://firebase.google.com/).
2. Click on "Get started."
3. Sign in with your Google account.

### Create a New Project

- Name your project (you can use the same project as Google OAuth).

![Project Name](https://github.com/danny-avila/LibreChat/assets/81851188/dccce3e0-b639-41ef-8142-19d24911c65c)

- Optionally, you can disable Google Analytics.

![Google Analytics](https://github.com/danny-avila/LibreChat/assets/81851188/5d4d58c5-451c-498b-97c0-f123fda79514)

- Wait for 20/30 seconds for the project to be ready, then click on "Continue."

![Continue](https://github.com/danny-avila/LibreChat/assets/81851188/6929802e-a30b-4b1e-b124-1d4b281d0403)

- Click on "All Products."

![All Products](https://github.com/danny-avila/LibreChat/assets/81851188/92866c82-2b03-4ebe-807e-73a0ccce695e)

- Select "Storage."

![Storage](https://github.com/danny-avila/LibreChat/assets/81851188/b22dcda1-256b-494b-a835-a05aeea02e89)

- Click on "Get Started."

![Get Started](https://github.com/danny-avila/LibreChat/assets/81851188/c3f0550f-8184-4c79-bb84-fa79655b7978)

- Click on "Next."

![Next](https://github.com/danny-avila/LibreChat/assets/81851188/2a65632d-fe22-4c71-b8f1-aac53ee74fb6)

- Select your "Cloud Storage location."

![Cloud Storage Location](https://github.com/danny-avila/LibreChat/assets/81851188/c094d4bc-8e5b-43c7-96d9-a05bcf4e2af6)

- Return to the Project Overview.

![Project Overview](https://github.com/danny-avila/LibreChat/assets/81851188/c425f4bb-a494-42f2-9fdc-ff2c8ce005e1)

- Click on "+ Add app" under your project name, then click on "Web."

![Web](https://github.com/danny-avila/LibreChat/assets/81851188/22dab877-93cb-4828-9436-10e14374e57e)

- Register the app.

![Register App](https://github.com/danny-avila/LibreChat/assets/81851188/0a1b0a75-7285-4f03-95cf-bf971bd7d874)

- Save all this information in a text file.

![Save Information](https://github.com/danny-avila/LibreChat/assets/81851188/056754ad-9d36-4662-888e-f189ddb38fd3)

- Fill all the `firebaseConfig` variables in the `.env` file.

```bash
FIREBASE_API_KEY=api_key #apiKey
FIREBASE_AUTH_DOMAIN=auth_domain #authDomain
FIREBASE_PROJECT_ID=project_id #projectId
FIREBASE_STORAGE_BUCKET=storage_bucket #storageBucket
FIREBASE_MESSAGING_SENDER_ID=messaging_sender_id #messagingSenderId
FIREBASE_APP_ID=1:your_app_id #appId
```