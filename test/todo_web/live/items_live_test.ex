defmodule TodoWeb.ItemsLiveTest do
  alias Todo.Items
  use TodoWeb.ConnCase
  import Phoenix.LiveViewTest

  @valid_item_attrs %{text: "first item"}
  @invalid_item_attrs %{text: nil}

  test "create item", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert view
           |> form("#item-form", item: @invalid_item_attrs)
           |> render_change() =~ "can&#39;t be blank"

    view
    |> form("#item-form", item: @valid_item_attrs)
    |> render_submit()

    assert render(view) =~ "first item"
  end

  test "toggle item", %{conn: conn} do
    {:ok, item} = Items.create_item(%{"text" => "first item"})
    assert item.completed == false

    {:ok, view, _html} = live(conn, "/")
    assert view |> element("#item_completed-#{item.id}") |> render_click() =~ "completed"

    update_item = Items.get_item!(item.id)
    assert update_item.completed == true
  end

  test "delete item", %{conn: conn} do
    {:ok, item} = Items.create_item(%{"text" => "first item"})

    {:ok, view, _html} = live(conn, "/")
    assert has_element?(view, "#item-#{item.id}")

    view |> element("button", "Delete") |> render_click()
    refute has_element?(view, "#item-#{item.id}")
  end

  test "filter items", %{conn: conn} do
    {:ok, _first} = Items.create_item(%{"text" => "first item"})
    {:ok, _second} = Items.create_item(%{"text" => "second item"})

    {:ok, view, _html} = live(conn, "/")

    assert view |> element("p", "first item") |> render_click() =~ "completed"

    {:ok, view, _html} = live(conn, "/?filter_by=completed")
    assert render(view) =~ "first item"
    refute render(view) =~ "second item"

    {:ok, view, _html} = live(conn, "/?filter_by=active")
    refute render(view) =~ "first item"
    assert render(view) =~ "second item"

    {:ok, view, _html} = live(conn, "/?filter_by=all")
    assert render(view) =~ "first item"
    assert render(view) =~ "second item"
  end
end
