cd ..

docker stop api
docker rm api
docker rmi api
docker build -t api -f API\Dockerfile .
docker run -d -p 5555:8080 --name=api -v /repo/AccSol/AccSol.EF/Data:/Data api

Log "Browse API Page in Microsoft Edge"
Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList "http://localhost:5555/swagger/index.html"

cd Api