# JWT Authentication API with Rails

A simple and secure JWT-based authentication system built with Ruby on Rails. This project demonstrates how to implement login, signup, access token, and refresh token functionality following RESTful conventions.

---

## 🔐 Features

- ✅ Account Signup & Login
- 🔐 JWT-based **Access Token** & **Refresh Token**
- 🚫 Token Expiration Handling
- 🔄 Refresh Token Endpoint
- ⚙️ Modular Token Service (`JsonWebToken`)
- 🚧 Note: ActionCable (WebSocket) support for token refresh is not yet implemented. Planned for a future release.

### This app is designed to support automatic token refresh via ActionCable (similar to Firebase behavior) in the future.
---

## 📦 Tech Stack

- Ruby 3.2.2
- Rails 7.1.5
- JWT (`jwt` gem)
- SQLite (default DB)
- `bcrypt` for secure password hashing
- `dotenv-rails` for environment variables

---

## 🚀 Setup

### 1. Clone the Repo

```bash
- Install Dependencies
    bundle install
- Set Up Environment Variables

- Set Up the Database
    rails db:create db:migrate
- Run the Server
    rails server
🛠️ API Endpoints
    Method	Path	Description
    POST	/signup	Create new account
    POST	/login	Login with credentials
    GET	/refresh-token	Generate new access token
    GET	/dashboard	Protected route (auth)
