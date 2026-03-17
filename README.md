# HelloWorld + Docker + Jenkins + 闈欐€佷唬鐮佹壂鎻?
杩欎釜浠撳簱鎻愪緵浜嗕竴涓渶灏忓彲杩愯绀轰緥锛屽寘鍚細
- Python HelloWorld
- Docker 闀滃儚鏋勫缓涓庤繍琛?- Jenkins 娴佹按绾?- 闈欐€佷唬鐮佹壂鎻忥紙ruff + bandit锛?- Jenkins 閫氳繃鍑嵁鑷姩 push 鍒?GitHub

## 椤圭洰缁撴瀯

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

## 1. 鏈湴杩愯 HelloWorld

```bash
python main.py
```

鏈熸湜杈撳嚭锛?
```text
Hello, World!
```

## 2. 浣跨敤 Docker 鍚姩 Jenkins

```bash
docker compose up -d --build
```

璁块棶鍦板潃锛?- <http://localhost:18080>

## 3. 鍦?Jenkins 鍒涘缓 Pipeline 浠诲姟

1. 鏂板缓浠诲姟锛岀被鍨嬮€夋嫨 `Pipeline`銆?2. 鍦?Pipeline 閰嶇疆涓€夋嫨 `Pipeline script from SCM`銆?3. SCM 閫夋嫨 `Git`锛屼粨搴撳湴鍧€濉啓锛?   - `https://github.com/zhiwenwang30-boop/helloworld.git`
4. Script Path 濉啓锛?   - `Jenkinsfile`

## 4. 閰嶇疆 GitHub 鎺ㄩ€佸嚟鎹?
涓轰簡璁?Jenkins 鍙互鎵ц `git push`锛岃鍦?Jenkins 涓坊鍔犲嚟鎹細

1. 杩涘叆 `Manage Jenkins` -> `Credentials`銆?2. 鏂板缓 `Username with password`锛?   - `Username`锛氫綘鐨?GitHub 鐢ㄦ埛鍚?   - `Password`锛氫綘鐨?GitHub Personal Access Token锛圥AT锛?3. 鍑嵁 `ID` 蹇呴』璁剧疆涓猴細
   - `github-push-cred`

## 5. 娴佹按绾块樁娈佃鏄?
`Jenkinsfile` 榛樿鎵ц浠ヤ笅闃舵锛?
1. `Checkout`锛氭媺鍙栦唬鐮?2. `Static Code Scan`锛氬湪 `docker.m.daocloud.io/library/python:3.12-slim` 瀹瑰櫒涓墽琛?   - `ruff check main.py`
   - `bandit -q -r main.py`
3. `Build Image`锛氭墽琛?`docker build`
4. `Run HelloWorld`锛氳繍琛岄暅鍍忓苟鎵撳嵃 `Hello, World!`
5. `Push To GitHub`锛氫粎鍦?`main` 鍒嗘敮鎵ц `git push`

## 6. 鍙€夛細鎵嬪伐鎺ㄩ€?
浣犱篃鍙互鎵嬪伐鎻愪氦骞舵帹閫侊細

```bash
git add .
git commit -m "init: hello world with docker jenkins static scan"
git push origin main
```

## 7. Docker Hub 鏃犳硶璁块棶鏃剁殑澶勭悊

濡傛灉鍑虹幇鎷夊彇澶辫触锛堜緥濡?`registry-1.docker.io:443` 瓒呮椂锛夛紝鏈」鐩凡榛樿浣跨敤闀滃儚绔欙細
- `docker.m.daocloud.io/jenkins/jenkins:lts-jdk17`
- `docker.m.daocloud.io/library/python:3.12-slim`

濡傛灉浠嶅け璐ワ紝鍙噸璇曪細

```bash
docker compose down
docker compose up -d --build
```

## 8. 娉ㄦ剰浜嬮」

- 涓虹畝鍖栫ず渚嬶紝`docker-compose.yml` 涓?Jenkins 浠?root 鐢ㄦ埛杩愯銆?- 鐢熶骇鐜寤鸿浣跨敤鏇翠弗鏍肩殑鏉冮檺鎺у埗鍜屽嚟鎹鐞嗙瓥鐣ャ€?

