# HelloWorld + Docker + Jenkins + 静态代码扫描

这个仓库提供了一个最小可运行示例，包含：
- Python HelloWorld
- Docker 镜像构建与运行
- Jenkins 流水线
- 静态代码扫描（ruff + bandit）
- Jenkins 通过凭据自动 push 到 GitHub

## 项目结构

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

## 1. 本地运行 HelloWorld

```bash
python main.py
```

期望输出：

```text
Hello, World!
```

## 2. 使用 Docker 启动 Jenkins

```bash
docker compose up -d --build
```

访问地址：
- <http://localhost:8080>

## 3. 在 Jenkins 创建 Pipeline 任务

1. 新建任务，类型选择 `Pipeline`。
2. 在 Pipeline 配置中选择 `Pipeline script from SCM`。
3. SCM 选择 `Git`，仓库地址填写：
   - `https://github.com/zhiwenwang30-boop/helloworld.git`
4. Script Path 填写：
   - `Jenkinsfile`

## 4. 配置 GitHub 推送凭据

为了让 Jenkins 可以执行 `git push`，请在 Jenkins 中添加凭据：

1. 进入 `Manage Jenkins` -> `Credentials`。
2. 新建 `Username with password`：
   - `Username`：你的 GitHub 用户名
   - `Password`：你的 GitHub Personal Access Token（PAT）
3. 凭据 `ID` 必须设置为：
   - `github-push-cred`

## 5. 流水线阶段说明

`Jenkinsfile` 默认执行以下阶段：

1. `Checkout`：拉取代码
2. `Static Code Scan`：在 `python:3.12-slim` 容器中执行
   - `ruff check main.py`
   - `bandit -q -r main.py`
3. `Build Image`：执行 `docker build`
4. `Run HelloWorld`：运行镜像并打印 `Hello, World!`
5. `Push To GitHub`：仅在 `main` 分支执行 `git push`

## 6. 可选：手工推送

你也可以手工提交并推送：

```bash
git add .
git commit -m "init: hello world with docker jenkins static scan"
git push origin main
```

## 7. 注意事项

- 为简化示例，`docker-compose.yml` 中 Jenkins 以 root 用户运行。
- 生产环境建议使用更严格的权限控制和凭据管理策略。
