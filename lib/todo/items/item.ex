defmodule Todo.Items.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :completed, :boolean, default: false
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:text, :completed])
    |> validate_required([:text, :completed])
  end
end
