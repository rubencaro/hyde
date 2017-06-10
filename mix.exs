defmodule Hyde.Mixfile do
  use Mix.Project

  def project do
    [app: :hyde,
     version: get_version_number(),
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: Hyde.Helpers.Cover,
                     verbose: false,
                     ignored: [Hyde.Helpers, Hyde.Helpers.Test]],
     deps: deps(),
     aliases: aliases()]
  end

  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger, :cowboy, :plug],
     mod: {Hyde.Application, []}]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Type "mix help deps" for more examples and options
  defp deps do
    [{:cowboy, "~> 1.1"},
     {:plug, "~> 1.3"},
     {:credo, "~> 0.8", only: [:dev, :test], runtime: false}]
  end

  # Get version number based on git commit
  #
  defp get_version_number do
    commit = :os.cmd('git rev-parse --short HEAD') |> to_string |> String.rstrip(?\n)
    v = "0.1.0+#{commit}"
    case Mix.env do
      :dev -> v <> "dev"
      _ -> v
    end
  end

  defp aliases do
    [test: ["credo", "test --cover"]] # to be able to test partially i.e.: `mix test test/inventory_scenario_test.exs:90`
  end

end
