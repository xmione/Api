cd ..

docker stop api
docker rm api
docker rmi api

docker run -d -p 5555:8080 --name=api -v /repo/AccSol/AccSol.EF/Data:/Data solomiosisante/api:0.1.0

Log "Browse API Page in Microsoft Edge"
Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList "http://localhost:5555/swagger/index.html"

cd Api