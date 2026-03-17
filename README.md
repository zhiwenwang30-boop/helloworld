# HelloWorld + Docker + Jenkins + Static Scan

This repository provides a minimal runnable example with:
- Python HelloWorld
- Docker image build and run
- Jenkins pipeline
- Static code scan (ruff + bandit)
- Automatic push to GitHub from Jenkins (via credentials)

## Project Structure

```text
.
|-- .dockerignore
|-- .gitignore
|-- Dockerfile
|-- Jenkinsfile
|-- docker-compose.yml
|-- jenkins
|   |-- Dockerfile
|   `-- plugins.txt
|-- main.py
`-- README.md
```

## 1. Run HelloWorld Locally

```bash
python main.py
```

Expected output:

```text
Hello, World!
```

## 2. Start Jenkins with Docker

```bash
docker compose up -d --build
```

Access Jenkins at:
- <http://localhost:8080>

## 3. Create a Pipeline Job in Jenkins

1. Create a new item of type `Pipeline`.
2. In pipeline config, choose `Pipeline script from SCM`.
3. Choose `Git` and set repository URL:
   - `https://github.com/zhiwenwang30-boop/helloworld.git`
4. Set Script Path:
   - `Jenkinsfile`

## 4. Configure GitHub Push Credentials

To allow Jenkins to run `git push`, add credentials in Jenkins:

1. Go to `Manage Jenkins` -> `Credentials`.
2. Add `Username with password`:
   - `Username`: your GitHub username
   - `Password`: your GitHub Personal Access Token (PAT)
3. Set credentials `ID` exactly as:
   - `github-push-cred`

## 5. Pipeline Stages

`Jenkinsfile` runs these stages:

1. `Checkout`: checkout source code
2. `Static Code Scan`: runs in `python:3.12-slim`
   - `ruff check main.py`
   - `bandit -q -r main.py`
3. `Build Image`: `docker build`
4. `Run HelloWorld`: run the built image and print `Hello, World!`
5. `Push To GitHub`: run `git push` only on `main`

## 6. Optional Manual Push

You can still commit and push manually:

```bash
git add .
git commit -m "init: hello world with docker jenkins static scan"
git push origin main
```

## 7. Notes

- For simplicity, Jenkins runs as root in `docker-compose.yml`.
- For production, use stricter permissions and credential handling.
