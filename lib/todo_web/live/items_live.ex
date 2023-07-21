defmodule TodoWeb.ItemsLive do
  use TodoWeb, :live_view
  alias Todo.Items
  alias Todo.Items.Item

  @items_topic "items"

  @impl true
  def mount(_param, _session, socket) do
    if connected?(socket), do: TodoWeb.Endpoint.subscribe(@items_topic)

    {:ok, assign(socket, items: Items.list_items(), filter_by: "all") |> assign_items()}
  end

  @impl true
  def handle_info(%{event: "items_updated", payload: %{items: items}}, socket) do
    {:noreply, assign(socket, items: items)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    items = Items.list_items()

    case params["filter_by"] do
      "completed" ->
        {:noreply,
         assign(socket, items: Enum.filter(items, &(&1.completed == true)), filter_by: "completed")}

      "active" ->
        {:noreply,
         assign(socket, items: Enum.filter(items, &(&1.completed == false)), filter_by: "active")}

      _ ->
        {:noreply, assign(socket, items: items, filter_by: "all")}
    end
  end

  def assign_items(socket) do
    socket |> assign(:item, %Item{})
  end
end
