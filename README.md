1 - Crie um pasta na raiz  
mkdir -p /opt/packer-proxmox-ubuntu  
mkdir -p /opt/ubuntu-22-template  
mkdir -p /opt/packer-proxmox-ubuntu/ubuntu-22-template/files  
mkdir -p /opt/packer-proxmox-ubuntu/ubuntu-22-template/http  

2 - Crie os arquivos 
touch /opt/packer-proxmox-ubuntu/ubuntu-22-raw.pkr.hcl  
touch /opt/packer-proxmox-ubuntu/ubuntu-22-template/files/99-pve.cfg  
touch /opt/packer-proxmox-ubuntu/ubuntu-22-template/http/meta-data  
touch /opt/packer-proxmox-ubuntu/ubuntu-22-template/http/user-data  
touch /opt/packer-proxmox-ubuntu/ubuntu-22-template/ubuntu-22-raw.pkr.hcl  

3 - Gere a senha hasheada para ser usada na criacao do template usado no arquivo user-data.pkrtpl.hcl na linha password mkpasswd -m sha-512 -S leandrosaltfixo ubuntu@123, O resultado do comando cole na linha password no arquivo user-data.pkrtpl.hcl

cd /opt/packer-proxmox-ubuntu  
4 - Execute o packer
packer init .  

packer build -var-file="credentials.pkr.hcl" ubuntu-22-template/ubuntu-22-raw.pkr.hcl

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
