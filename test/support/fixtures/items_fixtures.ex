defmodule Todo.ItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.Items` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        completed: true,
        text: "some text"
      })
      |> Todo.Items.create_item()

    item
  end
end
