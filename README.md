1 - Clone o repo 
cd /opt        
git clone https://github.com/leandrojpg/packer-proxmox-criar-template_ubuntu_2204.git  
cd /opt/packer-proxmox-criar-template_ubuntu_2204/packer-proxmox-ubuntu/  

2 - Edite as credenciais abaixo no arquivo credentials.pkr.hcl de acordo com seu ambiente  
cat /opt/packer-proxmox-criar-template_ubuntu_2204/packer-proxmox-ubuntu/credentials.pkr.hcl  

proxmox_url = "https://192.168.18.31:8006/api2/json" 
proxmox_username = "root@pam"  
proxmox_password = ""  

3 - Não altere nada nas opões abaixo:  Os valores abaixo são Usuário e Senha definido no template  
template_so_password = "ubuntu@123"  
template_so_password_hash = "$6$leandrosaltfixo$spdJDrdWMycINQP5Phvysm0WtcwvCdOspJK7miEZqEUiei3hl1MPNZAgyeSXfBItwWmzdbBc8.tHXVCFsGz10."  


"Abaixo é apenas um exemplo de como foi gerada o Hash acima ( NÃO PRECISA FAZER NADA )"  
Gere a senha hasheada para ser usada na criacao do template usado no arquivo user-data.pkrtpl.hcl na linha password mkpasswd -m sha-512 -S leandrosaltfixo ubuntu@123, O resultado do comando cole na linha password no arquivo user-data.pkrtpl.hcl

4 - Executando a criação do template  
cd /opt/packer-proxmox-criar-template_ubuntu_2204/packer-proxmox-ubuntu  
packer build -var-file="credentials.pkr.hcl" ubuntu-22-template/ubuntu-22-raw-v1.pkr.hcl 

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
