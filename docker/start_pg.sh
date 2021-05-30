#/bin/bash 

img=postgres:11
app=postgres-dev
username=rubydev
secret=rubydevpass

docker run --name $app -it -e POSTGRES_USER=$username -e POSTGRES_PASSWORD=$secret -p 5432:5432 -d $img
