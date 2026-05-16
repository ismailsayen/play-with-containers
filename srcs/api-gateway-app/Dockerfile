FROM python:3.12-alpine

WORKDIR /api-gateway-app

COPY requirements.txt .

RUN python3 -m venv venv

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt 

COPY . .

CMD ["python3","server.py"]

