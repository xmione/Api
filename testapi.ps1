
  <# test yaml
  
    cd /repo/Api/Api


    Build-Run-And-Deploy-Kubernetes
    
    Delete-Existing-SQL-Deployment accsol-sqlserver

    
    kubectl create secret generic mssql --from-literal=SA_PASSWORD=P@ssw0rd123
    kubectl apply -f sql.yaml
    Get-Deployment-info $true $false
    kubectl describe pod mssql-pod 
    kubectl logs mssql-pod

    kubectl delete deployment mssql-deployment 
    kubectl delete service mssql-service 
    kubectl delete pod mssql-pod 

    kubectl apply -f api.cluster.yaml
    kubectl apply -f api.yaml
    kubectl apply -f api.node.yaml

    cls
    kubectl get deployments
    kubectl get services
    kubectl get pods

    kubectl describe service api-service

    kubectl delete pod accsol-sqlserver-0
    
    kubectl delete statefulset accsol-sqlserver


    kubectl delete deployment api-deployment
    kubectl delete service api-service

    kubectl describe pod accsol-sqlserver-0 

    kubectl logs api-deployment-55dcd86d7-tbzr4 -c api

    kubectl port-forward api-deployment-55dcd86d7-tbzr4 7777:80
    
    netsh advfirewall firewall add rule name = DockerApiPort7777 dir = in protocol = tcp action = allow localport = 7777 remoteip = localsubnet profile = DOMAIN

    kubectl exec -it api-deployment-55dcd86d7-tbzr4 -- curl -v localhost:80

    #==================================================================
    # Browse api
    #==================================================================
    
    docker ps --filter name=api-deployment-55dcd86d7-mpjjx  
    docker ps --filter "image=solomiosisante/api"
    
    docker run --rm -p 7040:8081 --name=api --network accsolnet -v /repo/AccSol/AccSol.EF/Data:/Data api

    docker run --rm -p 7040:8081 --name=api -v /repo/AccSol/AccSol.EF/Data:/Data api

    
    docker run --rm -p 5555:8080 --name=api -v /repo/AccSol/AccSol.EF/Data:/Data solomiosisante/api:0.1.0

    docker stop b4e779c5d883454e19acdec5b2a99b4248c0feb4450c54b2d8399a4fa9112bab
    docker rm  b4e779c5d883454e19acdec5b2a99b4248c0feb4450c54b2d8399a4fa9112bab


    docker stop container api
    docker rm container api
    docker system prune -f
     
    docker container naughty_allen

    docker ps --filter "status=exited"
    docker ps --filter "ancestor=901a79a9b62a"

    docker ps --filter "reference=901a79a9b62a"

    
  #>