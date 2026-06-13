docker compose down

docker rmi -f $(docker images -a)

docker compose up --build -d