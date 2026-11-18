require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:comprar_pan)
  end

  # Atajo para leer el cuerpo JSON de la respuesta
  def json
    response.parsed_body
  end

  # --- index ---------------------------------------------------------------

  test "GET /tasks lista todas las tareas" do
    get tasks_url, as: :json

    assert_response :success
    assert_equal 2, json.size
    assert_equal "Estudiar Ruby", json.first["title"] # la más reciente primero
  end

  test "GET /tasks?completed=true filtra las completadas" do
    get tasks_url(completed: "true"), as: :json

    assert_response :success
    assert_equal [ "Estudiar Ruby" ], json.map { |t| t["title"] }
  end

  test "GET /tasks?completed=false filtra las pendientes" do
    get tasks_url(completed: "false"), as: :json

    assert_equal [ "Comprar pan" ], json.map { |t| t["title"] }
  end

  # --- show ----------------------------------------------------------------

  test "GET /tasks/:id muestra una tarea" do
    get task_url(@task), as: :json

    assert_response :success
    assert_equal @task.title, json["title"]
    assert_equal false, json["completed"]
  end

  test "GET /tasks/:id con id inexistente responde 404" do
    get task_url(id: 999_999), as: :json

    assert_response :not_found
    assert_match "No encontrado", json["error"]
  end

  # --- create --------------------------------------------------------------

  test "POST /tasks crea una tarea" do
    assert_difference("Task.count", 1) do
      post tasks_url, params: { task: { title: "Nueva", description: "Desc" } }, as: :json
    end

    assert_response :created
    assert_equal "Nueva", json["title"]
    assert_equal false, json["completed"]
  end

  test "POST /tasks sin título responde 422 con errores" do
    assert_no_difference("Task.count") do
      post tasks_url, params: { task: { title: "" } }, as: :json
    end

    assert_response :unprocessable_content
    assert json["errors"]["title"].any?
  end

  test "POST /tasks acepta JSON sin la clave task (wrap_parameters)" do
    # Rails envuelve solo los atributos del modelo dentro de "task"
    post tasks_url, params: { title: "Sin envoltorio" }, as: :json

    assert_response :created
    assert_equal "Sin envoltorio", json["title"]
  end

  test "POST /tasks sin ningún atributo de tarea responde 400" do
    post tasks_url, params: { otra_cosa: "x" }, as: :json

    assert_response :bad_request
  end

  # --- update --------------------------------------------------------------

  test "PATCH /tasks/:id actualiza y marca como completada" do
    patch task_url(@task), params: { task: { completed: true } }, as: :json

    assert_response :success
    assert_equal true, json["completed"]
    assert @task.reload.completed
  end

  test "PATCH /tasks/:id con datos inválidos responde 422" do
    patch task_url(@task), params: { task: { title: "" } }, as: :json

    assert_response :unprocessable_content
    assert_equal "Comprar pan", @task.reload.title
  end

  # --- destroy -------------------------------------------------------------

  test "DELETE /tasks/:id elimina la tarea" do
    assert_difference("Task.count", -1) do
      delete task_url(@task), as: :json
    end

    assert_response :no_content
  end

  test "DELETE /tasks/:id con id inexistente responde 404" do
    delete task_url(id: 999_999), as: :json

    assert_response :not_found
  end

  # --- health check --------------------------------------------------------

  test "GET /up responde 200" do
    get rails_health_check_url

    assert_response :success
  end
end
