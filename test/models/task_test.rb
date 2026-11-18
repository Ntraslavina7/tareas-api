require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "es válida con título" do
    task = Task.new(title: "Lavar la loza")
    assert task.valid?
  end

  test "por defecto no está completada" do
    assert_equal false, Task.new(title: "Algo").completed
  end

  test "es inválida sin título" do
    task = Task.new(title: "")
    assert_not task.valid?
    assert_includes task.errors[:title], "can't be blank"
  end

  test "es inválida con un título demasiado largo" do
    task = Task.new(title: "a" * (Task::TITLE_MAX_LENGTH + 1))
    assert_not task.valid?
    assert task.errors[:title].any?
  end

  test "es inválida si completed es nil" do
    task = Task.new(title: "Algo", completed: nil)
    assert_not task.valid?
  end

  test "filter_by_status con 'true' devuelve solo completadas" do
    assert_equal [ tasks(:estudiar_ruby) ], Task.filter_by_status("true").to_a
  end

  test "filter_by_status con 'false' devuelve solo pendientes" do
    assert_equal [ tasks(:comprar_pan) ], Task.filter_by_status("false").to_a
  end

  test "filter_by_status con otro valor devuelve todas" do
    assert_equal 2, Task.filter_by_status(nil).count
    assert_equal 2, Task.filter_by_status("cualquier cosa").count
  end

  test "recent_first ordena de la más nueva a la más antigua" do
    assert_equal [ tasks(:estudiar_ruby), tasks(:comprar_pan) ], Task.recent_first.to_a
  end
end
