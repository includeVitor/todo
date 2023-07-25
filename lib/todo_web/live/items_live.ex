defmodule TodoWeb.ItemsLive do
  use TodoWeb, :live_view
  alias Todo.Items
  alias Todo.Items.Item

  @items_topic "items"

  @impl true
  def mount(_param, _session, socket) do
    case connected?(socket) do
      true ->
        TodoWeb.Endpoint.subscribe(@items_topic)
        {:ok, assign(socket, items: Items.list_items(), item: %Item{}, filter_by: "all")}

      _ ->
        {:ok, assign(socket, items: [], item: %Item{}, filter_by: "all")}
    end
  end

  @impl true
  def handle_info(%{event: "items_updated"}, socket) do
    [items, filter_by] = filter_items(socket.assigns[:filter_by])

    {:noreply, assign(socket, items: items, filter_by: filter_by)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    [items, filter_by] = filter_items(params["filter_by"])

    {:noreply, assign(socket, items: items, filter_by: filter_by)}
  end

  def filter_items(filter_by) do
    items = Items.list_items()

    case filter_by do
      "completed" ->
        [Enum.filter(items, &(&1.completed == true)), "completed"]

      "active" ->
        [Enum.filter(items, &(&1.completed == false)), "active"]

      _ ->
        [items, "all"]
    end
  end
end
