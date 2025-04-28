# README

## Descripción

Crear un prototipo que permita registrar tiendas, las cuales podrán tener usuarios asociados. Además, el prototipo deberá contar con un cron que enviará mensajes diarios por WhatsApp a los dueños de las tiendas para preguntarles si abrirán ese día. El sistema deberá ser capaz de interpretar la respuesta y actualizar el estado de la tienda a "Abierta" o "Cerrada" según corresponda. Si el dueño responde "No" o no responde, el estado de la tienda se establecerá como "Cerrada". Adicionalmente, los usuarios disponen de un **mapa** que muestra **los negocios abiertos cercanos** a su ubicación.

## Requisitos para levantar el proyecto

**NOTA**: Tener instalado ruby(3.4.2), rails(8.0.2), blunde y ngrok(para desarrollo)

1. Tener el proyecto levantado

```bash
bundle install
rails db:create db:migrate
rails s
```

1. Exponer aplicación local con **ngrok**

```bash
ngrok http 3000
```

1. Agregar esta linea al archivo config/development.rb

```bash
#Al levantar el proyecto con ngrok te dara una url
#Esta url agregar al config.hosts.
#OJO que lo que deje es un ejemplo tu debes colocar la url ngrok te da
config.hosts << "3081-2800-300-66d1-51f0-4c93-1614-ae02-766.ngrok-free.app"
```

1. Tener configurado el token y weebhook en https://developers.facebook.com/

![Captura desde 2025-04-28 10-40-21.png](attachment:1f411458-415f-4842-819f-0b515265e4c9:Captura_desde_2025-04-28_10-40-21.png)