defmodule Bagger do
  use Application

  @grocery_list "lib/bagger/grocery_lists/whole_foods.csv"

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Bagger.Supervisors.LayerOne, []),
      worker(Bagger.Workers.Output, [])
    ]

    opts = [strategy: :one_for_one, name: Bagger.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def bag(list \\ @grocery_list) do
     CSVLixir.read(list)
     |> Enum.to_list
     |> tl
     |> parse
     |> Enum.map(&Bagger.Workers.Neuron.add_inputs(&1))

     Bagger.Workers.Output.show()
  end

  defp parse(data) when is_list(data) do
    Stream.map(data, fn(contents) ->
      item = hd(contents)
      inputs = tl(contents)
      [item, Enum.map(inputs, &String.to_integer/1)]
     end)
     |> Enum.to_list
  end
end
