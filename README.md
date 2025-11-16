1 - Crie um pasta na raiz  

mkdir -p /data/data  

2 - Crie os arquivos 

touch /data/template.pkr.hcl  

touch /data/data/meta-data 

touch /data/data/user-data.pkrtpl.hcl  

3 - Gere a senha hasheada para ser usada na criacao do template usado no arquivo user-data.pkrtpl.hcl na linha password openssl passwd -6 -salt xyz ubuntu@123, O resultado do comando cole na linha password no arquivo user-data.pkrtpl.hcl

4 - Execute o packer
packer init .  

packer build template.pkr.hcl  

5-############## PULO DO GATO APENAS PARA VMWARE #################  
Depois de criado o template a tentativa de criar uma vm pode falhar por que o packer deixa a interface de rede desconectada. E se criada uma vm a partir dele ele herda tudo inclusive a ausencia da rede. Precisa de alguma forma de persistir a rede marcada como connect power on. Esse é o verdadeiro problema tenha isso em mente. 7 - Sempre que depois que ele fizer a primeira instalacao e depois reiniciar e parar no Shell é por conta da senha criptografada no user-data que nao bate com a do arquivo principal gere outra


📥 ISO Download  
    ↓  
🖥️  Cria VM Temporária  
    ↓  
🚀 Boot Live + user-data (instalação)  
    ↓  
💾 Primeiro Boot (sistema instalado)  
    ↓  
🔧 Provisioners (personalização via SSH)  
    ↓  
📦 Convert to Template  
    ↓  
✅ PRONTO para Terraform!  
