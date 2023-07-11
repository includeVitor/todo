defmodule TodoWeb.ItemsLive do
  use TodoWeb, :live_view

  alias Todo.Items
  alias Todo.Items.Item

  @items_topic "items"

  def mount(_param, _session, socket) do
    if connected?(socket), do: TodoWeb.Endpoint.subscribe(@items_topic)

    {:ok, assign(socket, items: Items.list_items()) |> assign_items()}
  end

  def assign_items(socket) do
    socket |> assign(:item, %Item{})
  end

  def handle_info(%{event: "items_updated", payload: %{items: items}}, socket) do
    {:noreply, assign(socket, items: items)}
  end
end
