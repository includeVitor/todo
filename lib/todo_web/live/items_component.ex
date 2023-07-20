defmodule TodoWeb.ItemsComponent do
  use TodoWeb, :live_component
  use Phoenix.HTML
  alias Todo.Items

  @items_topic "items"

  def handle_event("toggle_item", %{"id" => id}, socket) do
    item = Items.get_item!(id)
    Items.update_item(item, %{completed: !item.completed})

    socket = assign(socket, items: Items.list_items())
    TodoWeb.Endpoint.broadcast(@items_topic, "items_updated", socket.assigns)
    {:noreply, socket}
  end

  def handle_event("delete_item", %{"id" => id}, socket) do
    item = Items.get_item!(id)
    Items.delete_item(item)

    socket = assign(socket, items: Items.list_items())
    TodoWeb.Endpoint.broadcast(@items_topic, "items_updated", socket.assigns)
    {:noreply, socket}
  end

  @spec item_completed?(any) :: <<_::_*72>>
  def item_completed?(true), do: "completed"
  def item_completed?(_), do: ""
end
