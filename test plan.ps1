<#=============================================================================================================
 File Name : test plan.ps1 - Test plan for testing API web application. 
 Created By: Solomio S. Sisante
 Created On: February 2, 2024
===============================================================================================================
 
 Pre-requisite: 
 1. Run getImports.ps1 first located in the Docker folder.
 
 Usage: Just run steps 1 by 1
 
===============================================================================================================#>

function Build-And-Run-Api{
    docker stop api
    docker rm api
    docker rmi api
    docker build -t api -f API\Dockerfile .
    docker run -d -p 5555:8080 --name=api -v /repo/AccSol/AccSol.EF/Data:/Data api

    Log "Browse API Page in Microsoft Edge"
    Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList "http://localhost:5555/swagger/index.html"
}   

function Update-Dockerhub{
    #Write-Output "Stop the container named api"
    #docker stop api

    Write-Output "Do Not Stop the container so that you will save all the changes in the container to the new image"
    Write-Output "Create a new image from the container with the author and message"
    docker commit -a "Solomio S. Sisante" -m "Updated api:0.1.0" api solomiosisante/api:0.1.0

    Write-Output "Tag the image with the latest tag and force overwrite the existing image"
    docker tag api:latest solomiosisante/api:0.1.0

    Write-Output "Push the image to the Docker Hub repository"
    docker push solomiosisante/api:0.1.0
} 

function Pull-And-Run-Dockerhub{
    docker stop api
    docker rm api
    docker rmi api

    docker run -d -p 5555:8080 --name=api -v /repo/AccSol/AccSol.EF/Data:/Data solomiosisante/api:0.1.0

    Log "Browse API Page in Microsoft Edge"
    Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList "http://localhost:5555/swagger/index.html"
}

function Build-Run-And-Deploy-Kubernetes-Api{
    cd Api
    kubectl apply -f api.cluster.yaml
    kubectl apply -f api.yaml
    kubectl apply -f api.node.yaml

    cls
    kubectl get deployments
    kubectl get services
    kubectl get pods

    kubectl describe service api-service
    cd ..
}

function Delete-Api-Deployment{
    kubectl delete deployment api-deployment
    kubectl delete service api-service
    kubectl delete service api-clusterip-srv
}

    # Important: Always change directory to the location of the getImports.ps1 script file
    Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force
    $scriptPath = Split-Path -parent $MyInvocation.MyCommand.Path
    cd $scriptPath
        
    Log "1. Build, run and test web api in both http/https protocol. Just run Api project in Visual Studio by pressing F5."

    dotnet build "./API/API.csproj" -c Release 
    cd ./Api/bin/Release/net8.0/
    
    $curDir = Get-Location

    $env:ASPNETCORE_URLS="http://localhost:7167"
    Start-Process cmd -ArgumentList "/k dotnet API.dll" -Verb RunAs -WorkingDirectory $curDir  

    Log "Browse API Page in Microsoft Edge"
    Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList "http://localhost:7167/swagger/index.html"
    Log "2. Test in browser if it displays."
    Pause
    
    Log "3. Build and run docker containers."
    # go back to app root path
    cd $scriptPath
    Build-And-Run-Api
    Log "4. Test in browser if it displays."
    Pause

    Log "5. Update repo in Dockerhub."
    cd $scriptPath
    Update-Dockerhub
    Pause

    Log "6. Pull image from repo and run."
    Pull-And-Run-Dockerhub
    Log "7. Test in browser if it displays."
    Pause

    Log "8. Build, run and deploy Api to kubernetes."
    cd $scriptPath
    Build-Run-And-Deploy-Kubernetes-Api
    Log "9. Test in browser if it displays."
    Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList "http://localhost:30011/swagger/index.html"
    Pause

    Log "10. Delete Api Deployment."
    Delete-Api-Deployment