# Keep image small while still easy to debug.
# Use a reachable mirror in regions where Docker Hub is unstable.
FROM docker.m.daocloud.io/library/python:3.12-slim

WORKDIR /app
COPY main.py /app/main.py

CMD ["python", "main.py"]
