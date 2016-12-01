# Bagger

## This Project is for Educational Purposes Only

It is designed to illustrate the
Single Layer Perceptron in Elixir. It accompanies the Post on
[Automating The Future](http://www.automatingthefuture.com)
called `Training Elixir Processes To Learn Like Neurons`. This repo can be downloaded
and copied as much as you like. The main thing here is to illustrate to the readers
how this type of Neural Network works in a down to earth easy to grasp example.

### The Story of The Bagger

The `Bagger` is an automated system that looks at any grocery list and classifies
the list's items into two distinct categories. The categories are hot items and cold items.
The `Bagger's` job is to put these items in the appropriate bag on its own.

#### Getting Started

Getting started is easy the whole point of this project is to give an `Elixir` based
example of the Single Layer Perceptron and how it can be used to Classify items on its own. To
get started just run the following command.

```Elixir
  #after cloning
  mix deps.get
  #start console
  iex -S mix
```
The entry point into the project is...

```Elixir
  Bagger.bag(<optionaly grocery list>)
  # SEE how bagger automatically packs the groceries in the correct bag
```

For a greater understanding of whats happening here read the post [here](http://www.automatingthefuture.com)
