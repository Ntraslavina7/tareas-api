class Task < ApplicationRecord
  TITLE_MAX_LENGTH = 100

  validates :title, presence: true, length: { maximum: TITLE_MAX_LENGTH }
  validates :completed, inclusion: { in: [ true, false ] }

  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :recent_first, -> { order(created_at: :desc) }

  # Filtra según el parámetro ?completed= de la URL ("true" / "false").
  # Cualquier otro valor (o ninguno) devuelve todas las tareas.
  def self.filter_by_status(value)
    case value
    when "true" then completed
    when "false" then pending
    else all
    end
  end
end
