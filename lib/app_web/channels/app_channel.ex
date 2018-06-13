defmodule AppWeb.AppChannel do
  use AppWeb, :channel

  def join("app:view", payload, socket) do
    IO.inspect(payload)
    {:ok, socket}
  end

  def handle_in("enter_view", payload, socket) do
    IO.inspect(payload)
    broadcast(socket, "enter_view", payload)
    {:reply, :ok, socket}
  end
end
