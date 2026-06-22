FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

# 預設啟動 adapter；灌資料時用：docker compose run --rm graphrag python ingest.py
CMD ["uvicorn", "dify_retrieval_adapter:app", "--host", "0.0.0.0", "--port", "8000"]
