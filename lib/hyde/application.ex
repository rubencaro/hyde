defmodule Hyde.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    greeting()

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Hyde.Router, [],
                          [port: 4001, acceptors: 5,
                           protocol_options: [max_keepalive: :infinity]])
    ]

    opts = [strategy: :one_for_one, name: Hyde.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp greeting do
    [:bright, :red, """

      @@@  @@@  @@@ @@@  @@@@@@@   @@@@@@@@
      @@@  @@@  @@@ @@@  @@@@@@@@  @@@@@@@@
      @@!  @@@  @@! !@@  @@!  @@@  @@!
      !@!  @!@  !@! @!!  !@!  @!@  !@!
      @!@!@!@!   !@!@!   @!@  !@!  @!!!:!
      !!!@!!!!    @!!!   !@!  !!!  !!!!!:
      !!:  !!!    !!:    !!:  !!!  !!:
      :!:  !:!    :!:    :!:  !:!  :!:
      ::   :::     ::     :::: ::   :: ::::
       :   : :     :     :: :  :   : :: ::

      """, :reset,
      " is listening on port ", :bright, "4001...\n\n", :reset]
    |> IO.ANSI.format |> IO.puts
  end
end
