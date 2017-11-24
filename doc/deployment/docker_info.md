

#connect to container
docker exec -it ee783a68f695  bash
sudo docker exec -i -t 665b4a1e17b6 /bin/bash #by ID
sudo docker exec -i -t loving_heisenberg /bin/bash #by Name

#attach docker container
sudo docker attach ee783a68f695