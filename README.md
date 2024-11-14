# Projeto-Terraform

## Descrição do Projeto

Este projeto utiliza *Terraform* para provisionar um projeto em nuvem na AWS.
## Corpo do Projeto

## VPC
Rede virtual onde os recursos são implementados, junto com um Gateway para comunicação externa.

## Subnets
Subnets públicas e privadas são definidas para segmentação de rede

## Grupos de Segurança
Grupos de segurança para controle de acesso à rede das instâncias EC2, RDS e Load Balancer.

## S3 e CloudFront
Bucket S3 para armazenamento de dados.

## RDS
Banco de dados RDS com usuário e senha gerados aleatoriamente.

## EC2
Configuração de instâncias EC2 com balanceamento de carga para suporte à aplicação.

## Load Balancer
Criação de Load Balancer para distribuir o tráfego entre as instâncias EC2.

## Como Executar o Projeto

1. **Instalar o Terraform** (versão >= 1.2.0)
2. **Configurar as Credenciais AWS** na máquina local.
3. **Clonar o Repositório**.
4. Executar os comandos a seguir:
   ```sh
   terraform init
   terraform validate
   terraform plan
   terraform apply
