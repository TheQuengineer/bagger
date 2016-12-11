defmodule Bagger.Mixfile do
  use Mix.Project

  def project do
    [app: :bagger,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :exmatrix, :csvlixir, :sfmt],
     mod: {Bagger, []}]
  end

  defp deps do
    [
      {:csvlixir, "~> 2.0"},
      {:exmatrix, "~> 0.0.1"},
      {:sfmt, git: "https://github.com/jj1bdx/sfmt-erlang.git"}
    ]
  end
end
