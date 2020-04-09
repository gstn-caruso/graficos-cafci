Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: 'application#index'
  get '/api/fondos', to: 'fondo_comun_de_inversion#index'
end
