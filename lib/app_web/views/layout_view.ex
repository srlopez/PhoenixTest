defmodule AppWeb.LayoutView do
  use AppWeb, :view

  def js_view_name(module, template) do
    (to_string(module) <> "_" <> to_string(template))
    |> to_string
    |> String.replace("View", "")
    |> String.replace(".html", "")
    |> String.downcase()
    |> String.split(".")
    |> Enum.slice(-1, 1)
    |> to_string
  end
end
