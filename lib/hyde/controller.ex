alias Plug.Conn, as: C

defmodule Hyde.Controller do
  @moduledoc false

  def render(conn) do
    :os.cmd('dot -O -Tpng')

    conn
    |> C.send_file(200, "render.png")
  end
end
