defmodule Mex.Mixfile do
  use Mix.Project

  def project do
    [app: :mex,
     version: "0.0.3",
     elixir: "> 1.0.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package,
     description: description
    ]
  end

  def package do
    [ # These are the default files included in the package
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Luc Fueston"],
      contributors: ["Luc Fueston"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mrluc/mex",}]
  end

  def description do
    """
    Macro-expansion display helper for IEx.
    """
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    []
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    []
  end
end
