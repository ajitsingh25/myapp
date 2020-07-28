FROM python:3.7-slim AS compile-image
RUN apt-get update && apt-get install -y --no-install-recommends --yes python3-venv gcc libpython3-dev && \
    python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip

COPY requirements.txt /requirements.txt
RUN /venv/bin/pip install --disable-pip-version-check -r /requirements.txt

FROM python:3.7-slim AS build-image
COPY --from=compile-image /venv /venv
ENV PATH="/venv/bin:$PATH"
COPY . /app
WORKDIR /app
EXPOSE 5000
ENTRYPOINT ["python3", "-m", "flask", "run", "--host=0.0.0.0"]