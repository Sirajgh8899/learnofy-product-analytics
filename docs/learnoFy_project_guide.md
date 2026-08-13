# LearnoFy Project Guide

## 1. What This Project Is

LearnoFy is a two-sided platform:

- Students use it to sign in, manage their study dashboard, upload notes, and manage a subscription plan.
- Cafes use it to sign in, view a cafe dashboard, and manage a cafe subscription plan.

The project is split into:

- a Vue 3 frontend
- a Django backend
- a PostgreSQL database

This guide explains the current project structure, data flow, and main business logic so a new developer can understand the system quickly.

## 2. Tech Stack

### Frontend

- Vue 3
- Vue Router
- Vite

Main frontend folder:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend)

### Backend

- Django 5
- Session-based authentication
- Django admin for admin users only

Main backend folder:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend)

### Database

- PostgreSQL
- App tables live mainly in schema `app_data`
- Django framework tables remain in schema `public`

## 3. High-Level Architecture

```text
Browser (Vue app)
    ->
Session-based HTTP requests with cookies
    ->
Django API
    ->
PostgreSQL
```

Important design decision:

- Students and cafes do not use `public.auth_user` for authentication.
- `public.auth_user` is kept for Django admin/framework use.
- Student auth is based on `app_data.student`.
- Cafe auth is based on `app_data.cafes`.

## 4. Main Folders

### Frontend

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/views`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/views)
  - page-level Vue views
- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/components`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/components)
  - shared UI pieces such as headers, sidebars, and language switcher
- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/router/index.js`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/router/index.js)
  - application routes and auth guards
- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/utils/sessionAuth.js`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/utils/sessionAuth.js)
  - frontend auth/session helper

### Backend

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/students`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/students)
  - student auth, notes, courses, subscriptions
- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/cafes`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/cafes)
  - cafe auth, dashboard metrics, subscriptions, promotions
- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/backend`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/backend)
  - project settings, root URLs, shared auth utilities

## 5. Frontend Route Flow

Main route file:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/router/index.js`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/router/index.js)

Important routes:

- `/landingpage`
  - public landing page
- `/landingpage/auth`
  - student auth page
- `/landingpage/cafe-auth`
  - cafe auth page
- `/landingpage/homepage`
  - student dashboard
- `/landingpage/cafe-dashboard`
  - cafe dashboard
- `/landingpage/courses`
  - student courses page
- `/landingpage/upload`
  - student upload/notes page
- `/landingpage/user-settings`
  - shared settings page

Route guard behavior:

- Public users can access the landing and auth pages.
- Protected routes require an authenticated session.
- Student-only routes reject cafe users.
- Cafe-only routes reject student users.
- On refresh, the frontend rehydrates auth state from the backend session using `/api/auth/me/`.

## 6. App Shell and Headers

Main app shell:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/App.vue`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/App.vue)

How it works:

- If the route is public, the top dashboard header is hidden.
- If the route is a cafe dashboard route, it shows the cafe header.
- Otherwise it shows the student header for authenticated student pages.

Role-specific headers:

- Student: [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/components/StudentHeader.vue`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/components/StudentHeader.vue)
- Cafe: [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/components/CafeHeader.vue`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/components/CafeHeader.vue)

Role-specific sidebars:

- Student: [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/components/StudentSidebar.vue`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/components/StudentSidebar.vue)
- Cafe: [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/components/CafeSidebar.vue`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/components/CafeSidebar.vue)

## 7. Authentication Design

### Backend session logic

Shared auth utility:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/backend/auth_utils.py`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/backend/auth_utils.py)

It provides:

- JSON body parsing
- consistent error responses
- session creation
- session clearing
- session identity lookup

Session keys:

- `learnoFy_role`
- `learnoFy_uid`

Supported roles:

- `student`
- `cafe`

### Frontend session logic

Frontend helper:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/utils/sessionAuth.js`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/utils/sessionAuth.js)

Important behavior:

- every API request is sent with `credentials: 'include'`
- the browser stores the real auth session in cookies
- localStorage is used only as lightweight frontend state for route handling
- on logout, frontend local auth state is cleared even if the network request fails

### Why sessions were chosen

Sessions allow each browser/device to have its own login session independently. That matches the requirement that a user can access the same account from different devices.

## 8. Student Flow

### Main student API routes

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/students/urls.py`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/students/urls.py)

Endpoints:

- `POST /api/auth/signup/`
- `POST /api/auth/login/`
- `POST /api/auth/logout/`
- `GET /api/auth/me/`
- `POST /api/auth/subscription/`
- `GET /api/notes/`
- `POST /api/notes/`

### Student login/signup flow

1. Student opens landing page.
2. Student clicks the student role card.
3. Frontend routes to the student auth page.
4. Login or signup request is sent to Django.
5. Backend validates credentials against `app_data.student`.
6. Backend writes session identity into the Django session.
7. Frontend stores the role as `student`.
8. Router sends the user to the student dashboard.

### Student dashboard flow

Student dashboard:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/views/HomePage.vue`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/views/HomePage.vue)

It loads the current user from:

- `GET /api/auth/me/`

The page displays a welcome message based on:

- first name + last name if available
- otherwise username/email fallback

### Student subscription flow

Subscription UI:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/components/StudentHeader.vue`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/components/StudentHeader.vue)

Plans:

- `basic`
- `learner`

Behavior:

- The current plan is displayed as a badge beside `LearnoFy`.
- Clicking the badge opens a modal.
- The modal allows upgrading to `learner`.
- If already on `learner`, it allows canceling back to `basic`.

### Student note upload flow

Upload page:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/views/UploadPage.vue`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/views/UploadPage.vue)

Backend logic:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/students/views.py`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/students/views.py)

What happens on note upload:

1. Student submits a PDF and metadata.
2. Backend validates file presence, file type, and size.
3. Backend parses the course label.
4. Backend creates or reuses a `Course`.
5. Backend creates or reuses a `StudentCourse`.
6. Backend creates a `Note`.
7. Backend returns serialized note data to the frontend.

## 9. Cafe Flow

### Main cafe API routes

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/cafes/urls.py`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/cafes/urls.py)

Endpoints:

- `POST /api/cafe/auth/login/`
- `POST /api/cafe/auth/logout/`
- `GET /api/cafe/auth/me/`
- `POST /api/cafe/auth/subscription/`
- `GET /api/cafe/dashboard/`

### Cafe login flow

1. User opens landing page.
2. User clicks the cafe role card.
3. Frontend routes to the cafe auth page.
4. Login request is sent to Django.
5. Backend validates credentials against `app_data.cafes`.
6. Backend writes session identity with role `cafe`.
7. Frontend stores the role as `cafe`.
8. Router sends the user to the cafe dashboard.

### Cafe dashboard flow

Cafe dashboard view:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/views/CafeDashboard.vue`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/views/CafeDashboard.vue)

Cafe dashboard metrics API:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/cafes/views.py`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/cafes/views.py)

Current dashboard behavior:

- the page loads the cafe name from `GET /api/cafe/auth/me/`
- the main body is intentionally simple
- the header contains the cafe subscription modal and sidebar
- the backend also exposes dashboard metrics for promotions and activity

### Cafe subscription flow

Subscription UI:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/components/CafeHeader.vue`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/src/components/CafeHeader.vue)

Plans:

- `basic`
- `booster`
- `ultimate`

Behavior:

- The current plan appears beside `LearnoFy`.
- Clicking it opens a 3-card pricing modal.
- The user can upgrade, switch, or cancel back to `basic`.

## 10. Database Model

### Student-side tables

Main model file:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/students/models.py`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/students/models.py)

Key tables:

- `app_data.student`
  - student credentials and profile
- `app_data.courses`
  - normalized course master data
- `app_data.student_courses`
  - links a student to a course for a specific term
- `app_data.notes`
  - uploaded notes and metadata

### Cafe-side tables

Main model file:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/cafes/models.py`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/cafes/models.py)

Key tables:

- `app_data.cafes`
  - cafe credentials, profile, subscription
- `app_data.promotions`
  - promotions owned by cafes
- `app_data.student_promotions`
  - relationship between students and promotions

### About Django public tables

The `public` schema still contains normal Django tables such as:

- `auth_user`
- `django_migrations`
- `django_session`

These are still important because:

- Django admin depends on them
- migration tracking depends on them
- Django session storage depends on them

But business auth for students/cafes no longer depends on `auth_user`.

## 11. Subscription Model

### Student plans

- `basic`
- `learner`

### Cafe plans

- `basic`
- `booster`
- `ultimate`

Each role stores its subscription directly on its own main table:

- students on `app_data.student.subscription_status`
- cafes on `app_data.cafes.subscription_status`

## 12. Important Backend Settings

Settings file:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/backend/settings.py`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/backend/settings.py)

Important behaviors:

- PostgreSQL is the active database backend
- CORS is enabled for local dev and LAN access
- session cookies are enabled for 14 days
- media uploads are stored under `backend/media`

Root backend URL file:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/backend/urls.py`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/backend/backend/urls.py)

Mounted route groups:

- `/api/` for student endpoints
- `/api/cafe/` for cafe endpoints
- `/admin/` for Django admin

## 13. Local Development

### Frontend

Package file:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/package.json`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/frontend/package.json)

Useful commands:

```bash
cd company-portfolio/frontend
npm install
npm run dev
```

The frontend dev server is configured with:

- `vite --host 0.0.0.0`

That allows access from other devices on the same network.

### Backend

Useful commands:

```bash
cd company-portfolio/backend
./venv310/bin/python manage.py migrate
./venv310/bin/python manage.py runserver 0.0.0.0:8000 --noreload
```

### Build/test commands

Frontend:

```bash
cd company-portfolio/frontend
./node_modules/.bin/vite build
```

Backend:

```bash
cd company-portfolio/backend
./venv310/bin/python manage.py test students cafes
```

## 14. Current Product Behavior Summary

What works today:

- student signup/login/logout with session auth
- cafe login/logout with session auth
- route protection by role
- student dashboard with welcome message
- cafe dashboard with welcome message
- role-specific headers and sidebars
- student subscription modal with upgrade/cancel
- cafe subscription modal with plan switching/cancel
- PDF note upload flow
- normalized course and student-course relationships
- cafe metrics endpoint
- local network access for frontend and backend

## 15. Main Tradeoffs in the Current Codebase

- The project mixes polished UI work with an evolving backend schema, so some areas are still intentionally simple.
- `Note` still keeps some legacy text fields for compatibility even though the newer normalized relationship exists through `StudentCourse`.
- Cafe dashboard metrics exist in the backend, but the current cafe page UI is intentionally minimal.
- Django admin/auth tables still exist because they are framework infrastructure, even though student/cafe business auth is custom.

## 16. Recommended Next Steps

If a new developer continues this project, the best next steps are:

1. Build full course management pages around `Course` and `StudentCourse`.
2. Add proper promotion CRUD screens for cafes.
3. Decide whether to fully remove legacy note text fields after migration.
4. Add more backend validation and API tests.
5. Document environment variables in a dedicated setup file like `.env.example`.
6. Add a deployment guide for production.

## 17. Related Docs

Database ERD:

- [`/Users/abdosallabi/LearnoFy.AI/company-portfolio/docs/learnoFy_erd_v2.md`](/Users/abdosallabi/LearnoFy.AI/company-portfolio/docs/learnoFy_erd_v2.md)

---

This file is intended to be the quick onboarding document for teammates and friends who want to understand how LearnoFy is structured before making changes.
