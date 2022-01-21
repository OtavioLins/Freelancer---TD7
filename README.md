# README

Olá! Esse é um projeto desenvolvido para a primeira etapa da sétima turma do programa TreinaDev. Essa aplicação é baseada num sistema de divulgação de projetos e busca de profissionais para compor os times desses projetos. Nele, você pode se cadastrar tanto como um usuário, dono de um projeto, ou como profissional visando integrar o time desses projetos. 

No momento, você pode:
- Entrar como usuário, cadastrar um projeto, filtrar profissionais de acordo com sua área de ocupação, receber propostas em seus projetos, aceitar ou recusá-las, fechar e encerrar seu projeto. 
- Entrar como um profissional, cadastrar e divulgar seu perfil, filtrar projetos de acordo com suas preferências e fazer uma aplicação para um projeto e receber um feedback dessa aplicação.

No futuro, teremos:
- Sistema de feedback para depois que o projeto for encerrado, tanto por parte do profissional como do dono do projeto;
- Marcar profissionais e donos de projeto como favoritos;
- Adicionar fotos ao perfil tanto do profissional quando do usuário.

No momento, a API ainda não está funcionando 100% naturalmente; por algum motivo, ao tentar consumir a API pela Freelancerconsumer, ela não reconhece o nome do container. A API só funciona pelo IP ou pelo nome específico acessado via terminal, mas o alias não. Estamos trabalhando em resolver isso!

Setup:

Para rodar a aplicação:
1. Clone o repositório, usando, em seu terminal, o comando: 
  - git clone git@github.com:OtavioLins/Freelancer---TD7.git

2. Migre para a pasta do repositório, com o comando:
  - cd Freelancer---TD7

3. Crie um conteiner com docker, usando o comando:
  - docker-compose build

4. Para interagir usando o terminal, rode o comando:
  - docker-compose run --rm --service-ports rails bash

5. A partir daí:
  5.1 Para rodar os testes, use o comando rspec
  5.2 Para subir o servidos, use o comando rails s -b 0.0.0.0
  5.3 Para acessar a página da web com a aplicação, cole no navegador localhost:3000/

6. Se quiser subir a aplicação e não interagir com o internal, basta usar o seguinte comando logo após criar o container (para acessar a página da web, ver 5.3):
  - docker-compose up