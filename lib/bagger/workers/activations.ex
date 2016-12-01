defmodule Bagger.Workers.Activations do
  @moduledoc """
  Does all the calculations for the neurons. It will adjust the weights
  and bias accordingly until it reaches the target that is set.
  """

  #use GenServer


  #######
  # API #
  #######

  def calculate(:hard_limit, neuron) when is_map(neuron) do
    summation(neuron.inputs, neuron.weights)
    |> add_bias(neuron)
    |> hard_limit
  end

  def adjust(neuron, target, item) do
    error = calculate_local_error(neuron.output, target)
    adjust(error, neuron, item, target)
  end

  ##################
  # IMPLEMENTATION #
  ##################

  defp add_bias(calc, neuron), do: calc + neuron.bias
  defp calculate_local_error(actual, target), do: target - actual
  defp hard_limit(calc) when calc < 0, do: 0
  defp hard_limit(calc) when calc >= 0, do: 1

  defp summation([], []), do: 0

  defp summation(inputs, weights) do
    ExMatrix.multiply([inputs], [weights])
    |> List.flatten
    |> Enum.sum
  end

  defp adjust(0, neuron, item, _) do
    Bagger.Workers.Output.classify(neuron.output, item)
  end

  defp adjust(error, neuron, item, target) do
    new_weights =
      ExMatrix.multiply([[error]],[neuron.weights])
      |> ExMatrix.add([neuron.inputs])
      |> List.flatten

    new_bias = neuron.bias +(error)
    Bagger.Workers.Neuron.update(new_weights, new_bias, target, item)
  end
end
