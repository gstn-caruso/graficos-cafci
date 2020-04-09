# graficos-cafci
Visualizar rendimientos de fondos de inversión obtenidos de la Cámara Argentina de Fondos Comunes de Inversión (CAFCI)

## Setup
1. `docker-compose up`
2. `docker-compose run backend scripts/wait-for-it.sh db:5432 -- "rails db:setup"`
3. `docker-compose run backend scripts/wait-for-it.sh db:5432 -- "rake descargar:historico"`
