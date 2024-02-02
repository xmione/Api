cd ..

docker stop api
docker rm api
docker rmi api
docker build -t api -f API\Dockerfile .
docker run -d -p 5555:8080 --name=api -v /repo/AccSol/AccSol.EF/Data:/Data api

cd Api