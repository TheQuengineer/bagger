defmodule Bagger.Workers.Neuron do
  @moduledoc """
  All Neural Networks need neurons to get their work done. `Bagger` needs
  neurons as well in order to bag items in the grocery list. The neruon
  will take inputs and generate random weights for each input. Then it will
  train itself toward the target until it converges on the right answer.
  """

  alias Bagger.Workers.Activations

  defstruct [
    pid: nil,
    bias: nil,
    inputs: nil,
    weights: nil,
    output: nil
  ]

  @doc """
  Creates a new neuron for `Bagger` which is essentially represented as an
  Agent.
  """
  def new do
     Agent.start_link(fn() ->
       %Bagger.Workers.Neuron{
         pid: self(),
         bias: 1
       }
     end, [name: __MODULE__])
  end

  @doc """
  Shows the current state of the given Neuron.
  """
  def get do
    Agent.get(__MODULE__, &(&1))
  end

  @doc """
   Add inputs to neuron so that it can classify the item.
   takes a list of
  """
  def add_inputs(data) when is_list(data) do
    [item, input_data] = data
    target = List.last(input_data)
    inputs = List.delete_at(input_data, -1)

    Agent.update(__MODULE__, fn(map) ->
      Map.put(map, :inputs, inputs)
      |> Map.put(:weights, 1..length(inputs)
      |> Enum.map(fn(_) -> :rand.uniform() end))
    end)

    calculate_output()
    neuron = get()
    Activations.adjust(neuron, target, item)
  end

  def update(new_weights, new_bias, target, item) do
    Agent.update(__MODULE__, fn(map) ->
      Map.put(map, :weights, new_weights)
      |> Map.put(:bias, new_bias)
    end)
    calculate_output()
    Activations.adjust(get(), target, item)
  end

  @doc """
  Calculates the output of the Neuron using the `hard_limit` transfer function
  """
  def calculate_output do
    new_output = Activations.calculate(:hard_limit, get())
     Agent.update(__MODULE__, fn(map) ->
       Map.put(map, :output, new_output)
     end)
  end
end
