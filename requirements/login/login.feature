Feature: Login
Como um cliente
Quero poder acessar minha conta e me manter logado
Para que eu possa ver e responder enquetes

Cenário: Credenciais Válidas
Dado que o cliente informou credenciais Válidas
Quando solicitar para fazer Login
Então o sistema deve enviar o usuário par a tela de pesquisas
E manter o usuário conectado

Cenário: Credenciais inválidas
Dado que o cliente informou credenciais inválidas
Quando solicitar para fazer Login
Então o sistema deve retornar uma mensagem de erro