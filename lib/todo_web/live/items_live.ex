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

  def handle_params(params, _url, socket) do
    items = Items.list_items()

    case params["filter_by"] do
      "completed" ->
        completed_items = Enum.filter(items, &(&1.completed == true))
        {:noreply, assign(socket, items: completed_items)}

      "active" ->
        active_items = Enum.filter(items, &(&1.completed == false))
        {:noreply, assign(socket, items: active_items)}

      _ ->
        {:noreply, assign(socket, items: items)}
    end
  end
end
