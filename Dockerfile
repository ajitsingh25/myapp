FROM python:3.8.1-buster AS builder
RUN apt-get update && apt-get install -y --no-install-recommends --yes python3-venv gcc libpython3-dev && \
    python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip

FROM builder AS builder-venv

COPY requirements.txt /requirements.txt
RUN /venv/bin/pip install --disable-pip-version-check -r /requirements.txt
COPY . /app
WORKDIR /app
EXPOSE 5000 27017
ENTRYPOINT ["/venv/bin/python3", "-m", "flask", "run", "--host=0.0.0.0"]
#CMD /venv/bin/python3 app.py run -h 0.0.0.0
