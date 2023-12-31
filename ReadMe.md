# to run locally

docker build -f ./dockerfiles/.Dockerfile -t sample_project .
docker run sample_project

# to run mypy with dj plugin locally

docker build -f ./dockerfiles/.mypy.Dockerfile -t sample_mypy_check .
docker run sample_mypy_check


# to collect deps locally
python3.11 -m venv venv
source venv/bin/activate
pip install poetry==1.7.1

# to create lock file 
poetry lock

# to install deps
poetry install --no-root