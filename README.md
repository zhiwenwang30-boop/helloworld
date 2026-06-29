# HelloWorld + Docker + Jenkins 双仓库 CI/CD

这个仓库是业务代码仓库，只保存应用代码、Dockerfile 和本机 Jenkins 启动配置。实际流水线脚本已经迁移到独立仓库：

- 业务仓库：`https://github.com/zhiwenwang30-boop/helloworld.git`
- 流水线仓库：`https://github.com/zhiwenwang30-boop/jenkins-pipelines.git`
- Docker Hub 镜像：`zhiwenwang30-boop/helloworld`

每次业务仓库 `main` 分支收到 push 后，Jenkins 会自动执行静态扫描、构建 Docker 镜像、运行冒烟验证、创建 Git Tag，并推送 Git Tag 和 Docker Hub 镜像。

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

`Jenkinsfile` 仅保留迁移提示，不再作为实际流水线入口。Jenkins Job 应读取独立流水线仓库中的 `pipelines/helloworld.Jenkinsfile`。

## 本地运行

```bash
python main.py
```

期望输出：

```text
Hello, World!
```

## 启动 Jenkins

```bash
docker compose up -d --build
```

访问地址：

- <http://localhost:18080>

Jenkins 镜像会安装以下核心插件：

- `workflow-aggregator`
- `git`
- `github`
- `credentials-binding`
- `docker-workflow`
- `pipeline-stage-view`
- `generic-webhook-trigger`

## Jenkins 凭据

在 Jenkins 中添加两个 `Username with password` 凭据：

| ID | Username | Password |
| --- | --- | --- |
| `github-push-cred` | GitHub 用户名 | GitHub Personal Access Token |
| `dockerhub-cred` | Docker Hub 用户名 | Docker Hub Access Token |

GitHub Token 需要能读取业务仓库、读取流水线仓库，并向业务仓库推送 tag。Docker Hub Token 需要能推送 `zhiwenwang30-boop/helloworld` 镜像。

## Jenkins Job 配置

1. 新建 Jenkins 任务，类型选择 `Pipeline`。
2. 勾选 `Generic Webhook Trigger`，token 填写：

```text
helloworld-ci-token
```

3. Pipeline Definition 选择 `Pipeline script from SCM`。
4. SCM 选择 `Git`，仓库地址填写：

```text
https://github.com/zhiwenwang30-boop/jenkins-pipelines.git
```

5. Branch 填写：

```text
*/main
```

6. Script Path 填写：

```text
pipelines/helloworld.Jenkinsfile
```

## GitHub Webhook

在业务仓库 `helloworld` 中配置 webhook：

```text
http://localhost:18080/generic-webhook-trigger/invoke?token=helloworld-ci-token
```

事件选择 `push`。流水线只处理 `refs/heads/main`，tag push 会被忽略，避免循环触发。

如果 Jenkins 运行在本机且 GitHub 无法直接访问 `localhost`，可以先使用内网穿透工具把 `18080` 暴露成公网 HTTPS 地址，再把 webhook URL 换成该公网地址。

## 流水线阶段

实际流水线在 `jenkins-pipelines/pipelines/helloworld.Jenkinsfile`，固定执行：

1. 校验 webhook ref，只允许 `refs/heads/main`。
2. checkout 业务仓库指定 commit。
3. 执行 `ruff check main.py` 和 `bandit -q -r main.py`。
4. 生成版本号：`ci-yyyyMMdd-HHmmss-短commit`。
5. 构建镜像：`zhiwenwang30-boop/helloworld:${VERSION_TAG}`。
6. 标记 latest：`zhiwenwang30-boop/helloworld:latest`。
7. 运行镜像并验证输出必须是 `Hello, World!`。
8. 创建并推送 Git tag。
9. 登录 Docker Hub 并推送版本镜像和 `latest`。

## 迁移运行

在任意安装 Docker 的机器上执行：

```bash
docker pull zhiwenwang30-boop/helloworld:latest
docker run --rm zhiwenwang30-boop/helloworld:latest
```

期望输出：

```text
Hello, World!
```

## Docker Hub 无法访问时

Jenkins 和 Python 基础镜像默认使用可访问性更好的镜像源：

- `docker.m.daocloud.io/jenkins/jenkins:lts-jdk17`
- `docker.m.daocloud.io/library/python:3.12-slim`

如果仍拉取失败，可重试：

```bash
docker compose down
docker compose up -d --build
```

## 注意事项

- 为简化本机演示，`docker-compose.yml` 中 Jenkins 以 root 用户运行。
- `jenkins_home/` 是 Jenkins 本地数据目录，已经被 `.gitignore` 忽略。
- 生产环境建议使用更严格的权限控制、凭据隔离和 HTTPS webhook 入口。
