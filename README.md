# ⚡ Serverless REST API — AWS Lambda + API Gateway + DynamoDB

A fully serverless CRUD REST API built on AWS with zero idle infrastructure cost.

---

## 🏗️ Architecture
```
Client (curl / browser / Postman)
         │
         ▼
┌─────────────────────────┐
│      API Gateway         │
│  Resource: /users        │
│  Methods: GET POST       │
│           PUT DELETE     │
│  Stage: dev              │
└────────────┬─────────────┘
             │
             ▼
┌─────────────────────────┐
│    Lambda Function       │
│    Runtime: Python 3.12  │
│    Memory: 128 MB        │
│    Timeout: 30 seconds   │
└────────────┬─────────────┘
             │
             ▼
┌─────────────────────────┐
│    DynamoDB Table        │
│    Name: users           │
│    Partition key: id     │
│    Capacity: On-demand   │
└─────────────────────────┘
```

---

## 🛠️ Tech Stack

| Layer | Service | Purpose |
|---|---|---|
| HTTP Entry | API Gateway (REST) | Routes requests, handles HTTPS |
| Logic | AWS Lambda (Python 3.12) | CRUD handler, runs on-demand only |
| Database | DynamoDB (On-demand) | NoSQL, auto-scaling |
| Security | IAM Least Privilege Role | Lambda scoped to users table only |
| Logging | CloudWatch Logs | All Lambda logs captured automatically |

---

## 📡 API Endpoints

| Method | Endpoint | Description | Body / Params |
|---|---|---|---|
| POST | /users | Create a user | JSON body with `id`, `name`, `email`, `info` |
| GET | /users?id={id} | Get a user by ID | Query param: `id` |
| PUT | /users | Update a user | JSON body with `id`, `name`, `info` |
| DELETE | /users?id={id} | Delete a user | Query param: `id` |

---

## 🔐 Security Design

- Custom IAM policy scoped to **only 6 DynamoDB actions** needed by Lambda
- Permission limited to the **`users` table only** — not all DynamoDB tables
- No hardcoded credentials anywhere in the code
- boto3 uses the IAM role automatically at runtime
```json
{
  "Effect": "Allow",
  "Action": [
    "dynamodb:PutItem",
    "dynamodb:GetItem",
    "dynamodb:UpdateItem",
    "dynamodb:DeleteItem",
    "dynamodb:Scan",
    "dynamodb:Query"
  ],
  "Resource": "arn:aws:dynamodb:us-east-1:*:table/users"
}
```

---

## 💸 Cost Model

| Service | Pricing |
|---|---|
| Lambda | First 1M requests/month free, then $0.20 per 1M |
| DynamoDB | On-demand — pay per read/write, scales to zero |
| API Gateway | First 1M calls/month free |

**At low traffic = effectively $0/month**

---

## 🚀 How to Deploy This Yourself

### Step 1 — Create DynamoDB Table
- Go to AWS Console → DynamoDB → Create table
- Table name: `users`
- Partition key: `id` (String)
- Capacity mode: On-demand

### Step 2 — Create IAM Role
- Go to IAM → Roles → Create role
- Use case: Lambda
- Attach: `AWSLambdaBasicExecutionRole`
- Create and attach custom policy from `iam_policy.json`
- Role name: `lambda-dynamodb-role`

### Step 3 — Create Lambda Function
- Go to Lambda → Create function
- Runtime: Python 3.12
- Assign role: `lambda-dynamodb-role`
- Paste code from `lambda_function.py`
- Click Deploy
- Set timeout to 30 seconds

### Step 4 — Create API Gateway
- Go to API Gateway → Create API → REST API
- Create resource: `/users`
- Create methods: GET, POST, PUT, DELETE
- Enable **Lambda Proxy Integration** on all methods
- Enable **CORS** on `/users` resource
- Deploy to new stage: `dev`
- Copy the Invoke URL

### Step 5 — Test
- Open `test_commands.sh`
- Replace `YOUR-API-URL` with your actual Invoke URL
- Run the file in your terminal

---

## 📸 Proof of Working Build

![DynamoDB Table with real data](screenshots/dynamodb-proof.png)

---

## 📝 Key Concepts Demonstrated

- **Serverless architecture** — no EC2, no idle cost, no server management
- **IAM least privilege** — Lambda scoped to minimum permissions required
- **Lambda Proxy Integration** — full HTTP event routing inside the function
- **On-demand DynamoDB** — scales to zero, scales to millions automatically
- **CORS** — API accessible from any browser frontend
- **CloudWatch logging** — every request and error logged automatically

---

## 💼 Resume Line

> Built a serverless REST API on AWS using API Gateway, Lambda (Python), and DynamoDB
> supporting full CRUD operations. Implemented IAM least-privilege roles for Lambda
> execution, Lambda Proxy Integration for request routing, and CORS configuration
> for browser accessibility. Achieved $0 infrastructure cost at low traffic volumes
> leveraging on-demand pricing.
```

---

## YOUR FOLDER STRUCTURE

When you're done, your folder should look exactly like this before uploading:
```
serverless-users-api/
│
├── lambda_function.py
├── iam_policy.json
├── test_commands.sh
├── README.md
└── screenshots/
    └── dynamodb-proof.png        ← your screenshot goes here
