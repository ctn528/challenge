FROM python:3

RUN pip3 install flask --no-cache-dir

WORKDIR /app
RUN git clone https://github.com/ctn528/challenge-python.git .
WORKDIR /app/flask-python

CMD [ "python3", "./app.py" ]
