defmodule TodoWeb.ItemsLiveTest do
  use TodoWeb.ConnCase
  import Phoenix.LiveViewTest

  @valid_item_attrs %{text: "first item"}
  @invalid_item_attrs %{text: nil}

  test "create_item", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert view
           |> form("#item-form", item: @invalid_item_attrs)
           |> render_change() =~ "can&#39;t be blank"

    view
    |> form("#item-form", item: @valid_item_attrs)
    |> render_submit()

    assert render(view) =~ "first item"
  end
end
