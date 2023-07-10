defmodule TodoWeb.ItemsLive do
  use TodoWeb, :live_view

  alias Todo.Items
  alias Todo.Items.Item

  def mount(_param, _session, socket) do
    {:ok, assign(socket, items: Items.list_items()) |> assign_items()}
  end

  def assign_items(socket) do
    socket |> assign(:item, %Item{})
  end
end
