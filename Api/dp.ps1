#============================================================================================================
# FileName	: dp.ps1 - This script is used to commit the changes in the container to the same image 
#             and push it to the dockerhub repository.
# Created By: Solomio S. Sisante
# Created On: January 18,2024
#============================================================================================================

Write-Output "#============================================================================================================"
Write-Output "# FileName  : dp.ps1 - This script is used to commit the changes in the container to the same image "
Write-Output "#             and push it to the dockerhub repository."
Write-Output "# Created By: Solomio S. Sisante"
Write-Output "# Created On: January 18,2024"
Write-Output "#============================================================================================================"

<# original codes without the comments

    docker stop accsol
    docker commit accsol solomiosisante/accsol:blazor-1.0
    docker tag accsol:latest solomiosisante/accsol:blazor-1.0
    docker push solomiosisante/accsol:blazor-1.0

    docker stop accsol.api
    docker commit accsol.api solomiosisante/accsol:api-1.0
    docker tag accsol.api:latest solomiosisante/accsol:api-1.0
    docker push solomiosisante/accsol:api-1.0

    docker stop accsolsqlserver
    #docker rmi solomiosisante/accsol:sqlserver-1.0
    docker commit accsolsqlserver accsol:sqlserver-1.0
    docker tag accsolsqlserver:latest solomiosisante/accsol:sqlserver-1.0
    docker push solomiosisante/accsol:sqlserver-1.0

#>


#=======================================================================================================
#Write-Output "Stop the container named api"
#docker stop api

Write-Output "Do Not Stop the container so that you will save all the changes in the container to the new image"
Write-Output "Create a new image from the container with the author and message"
docker commit -a "Solomio S. Sisante" -m "Updated api:0.1.0" api solomiosisante/api:0.1.0

Write-Output "Tag the image with the latest tag and force overwrite the existing image"
docker tag api:latest solomiosisante/api:0.1.0

Write-Output "Push the image to the Docker Hub repository"
docker push solomiosisante/api:0.1.0

#=======================================================================================================

