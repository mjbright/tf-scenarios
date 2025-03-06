
echo
echo "Before import:"
echo "- docker container is running outside Terraform"
echo "- There is no terraform.tfstate file"
echo
docker ps

ls -altr terraform.tfstate

echo
read -p "Press <enter>"

terraform apply
echo
echo "Import complete"
read -p "Press <enter>"

echo
echo "Before import:"
echo "- docker container is unchanged"
echo "- There is a terraform.tfstate file, showing that Terraform is now managing the container"
echo
docker ps
ls -altr terraform.tfstate

echo
echo "---- terraform state list"
terraform state list

echo
echo "---- terraform state show docker_container.legacy"
read -p "Press <enter>"
terraform state show docker_container.legacy
