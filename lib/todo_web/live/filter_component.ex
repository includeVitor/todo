defmodule TodoWeb.FilterComponent do
  use TodoWeb, :live_component
  use Phoenix.HTML

  def is_filter_by_selected?(filter_by, label) do
    case filter_by == label do
      true ->
        "bg-blue-100"

      _ ->
        ""
    end
  end
end
