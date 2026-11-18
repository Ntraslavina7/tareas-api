Rails.application.routes.draw do
  # GET /tasks, POST /tasks, GET/PATCH/PUT/DELETE /tasks/:id
  resources :tasks, only: %i[index show create update destroy]

  # Health check: responde 200 si la app arrancó bien (útil para Docker y Jenkins)
  get "up" => "rails/health#show", as: :rails_health_check
end
