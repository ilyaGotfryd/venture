---

---
## Pattern Matching
\\\\\\\\\\\
---

---
#### Here is code you would never write
```elixir
defmodule StupidFizzbuzz do
  def fizzbuzz(n) do
    cond do
      n == 3 ->
        :fizz
      n == 5 ->
        :buzz
      true ->
        n
    end
  end
end
```
\\\\\\\\\\\
## Pattern matching to the rescue
```
defmodule StupidFizzbuzz do
  def fizzbuzz(3), do: :fizz
  def fizzbuzz(5), do: :buzz
  def fizzbuzz(n), do: n
end
```
\\\\\\\\\\\
---
next: main:8
---
## With destructuring...
```elixir
defmodule AnimalSounds do
  def make_sound({:cat, name}) do
    IO.puts "#{name} the cat goes Meow."
  end

  def make_sound({:dog, name}) do
    IO.puts "#{name} the dog goes Woof."
  end

  def make_sound({animal, _}) do
    IO.puts "I don't know what sound a #{animal} makes."
  end
end
```
\\\\\\\\\\\
