defmodule Hyde.Helpers do

  @moduledoc """
    require Hyde.Helpers, as: H  # the cool way
  """
  @doc """
    Convenience to get environment bits. Avoid all that repetitive
    `Application.get_env( :myapp, :blah, :blah)` noise.

    Use it as `H.env(:anyapp, :key, default)`

    You can add the default app to your config file:

    ```
      config :alfred, app: :myapp
    ```

    Then you can use it as `H.env(:key)` instead of `H.env(:myapp, :key)`
  """
  def env(key, default \\ nil), do: env(:hyde, key, default)
  def env(app, key, default), do: Application.get_env(app, key, default)

  @doc """
  Spit to output any passed variable, with location information.

  If `sample` option is given, it should be a float between 0.0 and 1.0.
  Output will be produced randomly with that probability.

  Given `opts` will be fed straight into `inspect`. Any option accepted by it should work.
  """
  defmacro spit(obj \\ "", opts \\ []) do
    quote do
      opts = unquote(opts)
      obj = unquote(obj)
      opts = Keyword.put(opts, :env, __ENV__)

      Hyde.Helpers.maybe_spit(obj, opts, opts[:sample])
      obj  # chainable
    end
  end

  @doc false
  def maybe_spit(obj, opts, nil), do: do_spit(obj, opts)
  def maybe_spit(obj, opts, prob) when is_float(prob) do
    if :rand.uniform <= prob, do: do_spit(obj, opts)
  end
  def maybe_spit(obj, opts, prob) when is_function(prob) do
    case prob.(obj) do
      true -> do_spit(obj, opts)
      _ -> obj
    end
  end

  defp do_spit(obj, opts) do
    opts = Keyword.merge([pretty: true], opts)

    %{file: file, line: line} = opts[:env]
    name = Process.info(self())[:registered_name]
    chain = [:bright, :red, "\n\n#{file}:#{line}", :green,
        "\n   #{DateTime.utc_now |> DateTime.to_string}",
        :red, :normal, "  #{inspect self()}", :green, " #{name}"]

    msg = inspect(obj, opts)
    chain = chain ++ [:red, "\n\n#{msg}"]

    chain = chain ++ ["\n\n", :reset]

    chain |> IO.ANSI.format(true) |> IO.puts
  end

  @doc """
    Print to stdout a to-do message, with location information.
  """
  defmacro todo(msg \\ "") do
    quote do
      %{file: file, line: line} = __ENV__
      [:yellow, "\nTODO: #{file}:#{line} #{unquote(msg)}\n", :reset]
      |> IO.ANSI.format(true)
      |> IO.puts
      :todo
    end
  end

  @doc """
    Tell the world outside we're alive
  """
  def alive_loop(app_name, opts \\ []) do
    # register the name if asked
    if opts[:name], do: Process.register(self(), opts[:name])

    :timer.sleep 5_000
    tmp_path = :tmp_path |> env("tmp") |> Path.expand
    {_, _, version} = Application.started_applications |> Enum.find(&(match?({^app_name, _, _}, &1)))
    "echo '#{version}' > #{tmp_path}/alive" |> to_charlist |> :os.cmd
    alive_loop(app_name)
  end

end
