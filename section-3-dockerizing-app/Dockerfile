FROM python:3.10-slim


RUN apt-get update && \
    apt-get install -y python3 python3-pip 

WORKDIR /app

COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 5001

CMD ["python", "main.py"]
