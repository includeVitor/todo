defmodule TodoWeb.ItemsComponent do
  use TodoWeb, :live_component
  use Phoenix.HTML
  alias Todo.Items

  @items_topic "items"

  @impl true
  def handle_event("toggle_item", %{"id" => id}, socket) do
    item = Items.get_item!(id)
    Items.update_item(item, %{completed: !item.completed})

    TodoWeb.Endpoint.broadcast(@items_topic, "items_updated", socket.assigns)
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_item", %{"id" => id}, socket) do
    item = Items.get_item!(id)
    Items.delete_item(item)

    TodoWeb.Endpoint.broadcast(@items_topic, "items_updated", socket.assigns)
    {:noreply, socket}
  end

  def item_completed?(true), do: "line-through"
  def item_completed?(_), do: ""
end
