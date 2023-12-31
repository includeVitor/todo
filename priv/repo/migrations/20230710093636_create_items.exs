defmodule Todo.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :text, :string
      add :completed, :boolean, default: false, null: false

      timestamps()
    end
  end
end
