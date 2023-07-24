defmodule TodoWeb.FormComponent do
  use TodoWeb, :live_component
  use Phoenix.HTML
  alias Todo.Items

  @items_topic "items"

  @impl true
  def update(%{item: item} = assigns, socket) do
    changeset = Items.change_item(item)
    {:ok, socket |> assign(assigns) |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"item" => item_params}, socket) do
    changeset =
      socket.assigns.item |> Items.change_item(item_params) |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("create_item", %{"item" => item_params}, socket) do
    save_item(socket, item_params)
  end

  def save_item(socket, item_params) do
    case Items.create_item(item_params) do
      {:ok, _item} ->
        TodoWeb.Endpoint.broadcast(@items_topic, "items_updated", socket.assigns)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
