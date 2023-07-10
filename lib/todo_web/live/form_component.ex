defmodule TodoWeb.FormComponent do
  use TodoWeb, :live_component
  use Phoenix.HTML
  alias Todo.Items

  @impl true
  def update(%{item: item} = assigns, socket) do
    changeset = Items.change_item(item)
    {:ok, socket |> assign(assigns) |> assign(:changeset, changeset)}
  end
end
