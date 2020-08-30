# challenge

Aplicacion de Python

Primer caso:
/greetings: Se muesta un Hello World indicando la variable de entorno "HOSTNAME" del servidor.

Segundo caso:
/square: Se genera el cuadrado del valor indicado.

#######
Como usar
######
Cambiar el valor de IP_ADDRESS

Primer caso:
curl http://127.0.0.1:5000/greetings

Segundo caso:
curl -d '{"number":"10"}' -H "Content-Type: application/json" -X POST http://IP_ADDRESS:5000/square
Respuesta del servidor:

{
  "square": 100
}


curl -d '{"number":"25"}' -H "Content-Type: application/json" -X POST http://IP_ADDRESS:5000/square
Respuesta del servidor:

{
  "square": 625
}
