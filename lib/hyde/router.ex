defmodule Hyde.Router do
  use Plug.Router
  if Mix.env == :dev, do: use Plug.Debugger, otp_app: :hyde
  use Plug.ErrorHandler

  plug Plug.Logger, log: :debug

  plug Plug.Static,
    at: "/static",
    from: {:hyde, "priv/static"}

  plug :match
  plug :dispatch

  get "/ping", do: send_resp(conn, 200, "OK")

  post "/render", do: Hyde.Controller.render(conn)

  match _, do: send_resp(conn, 404, "Not Found")

  @doc """
  Callback for `Plug.ErrorHandler`
  """
  def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    send_resp(conn, conn.status, "Something went wrong")
  end
end
