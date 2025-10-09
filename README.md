1 - Crie um pasta na raiz pode ser qualquer nome mas aqui foi /data mkdir -p /data/data

2 - Crie os arquivos dentro de e /data/data touch /data/data/meta-data touch /data/data/user-data.pkrtpl.hcl

3 - Crie o arquivo template.pkr.hcl dentro de /data touch /data/template.pkr.hcl

4 - Gere a senha hasheada para ser usada na criacao do template usado no arquivo user-data.pkrtpl.hcl na linha password openssl passwd -6 -salt xyz ubuntu@123 O resulta do comando cole na linha password no arquivo user-data.pkrtpl.hcl

5 - Execute o packer passando as variáveis da seguinte maneira packer build -var "vcenter_server=192.168.18.31" -var "vcenter_username=administrator@vsphere.local" -var "vcenter_password=Brasil.123" -var "image_name=template-server" -var "template_cluster=Cluster" template.pkr.hcl

6 -############## PULO DO GATO ################# Depois de criado o template a tentativa de criar uma vm pode falhar por que o packer deixa a interface de rede desconectada. E se criada uma vm a partir dele ele herda tudo inclusive a ausencia da rede. Precisa de alguma forma de persistir a rede marcada como connect power on. Esse é o verdadeiro problema tenha isso em mente. 7 - Sempre que depois que ele fizer a primeira instalacao e depois reiniciar e parar no Shell é por conta da senha criptografada no user-data que nao bate com a do arquivo principal gere outra
