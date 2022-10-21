FROM registry.hub.docker.com/library/python:3.9.15

WORKDIR /opt/app-root

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY . . 

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
