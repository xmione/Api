cd ..

docker stop api
docker rm api
docker rmi api

docker run -d -p 5555:8080 --name=api -v /repo/AccSol/AccSol.EF/Data:/Data solomiosisante/api:0.1.0
cd Api