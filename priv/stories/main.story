---
type: title
---

### Process Oriented Programming in Elixir
#### Chris Nelson
![](images/gaslight_horz.png)
\\\\\\\\\\\

## Agenda

* Introducing Elixir
* What even is OOP?
* Processes
* An Elixir AdVenture
* POD (Process Oriented Design)
\\\\\\\\\\\
---
class: dark
align: left top
background:
  image: inception.jpg
  size: cover
---
## This is a meta-talk
### http://codemash.dev.builders
\\\\\\\\\\\
---
type: poll
options:
  - Heard of it
  - Read about it
  - Written some code
  - Shipped projects
---
Have you Elixired?
\\\\\\\\\\\
---

---
## Elixir
* Created by Jose Valim in 2012
* Functional
* Immutable
* Erlang VM (BEAM)
* Approachable syntax
\\\\\\\\\\\
---

---
## Erlang
* Ericcson circa 1987
* Designed to run Telco systems
* Very high concurrency
* Very high availability
* Prolog inspired syntax
\\\\\\\\\\\
---

---
## Basic Types
```
1                  # integer
0x1F               # integer
1.0                # float
true               # boolean
:atom              # atom / symbol
"elixir"           # string
[1, 2, 3]          # list
{1, 2, 3}          # tuple
%{a: "b", c: "d"}  # map
%{"&*!" => "foo"}  # map
```
\\\\\\\\\\\
---

---
## Hello Elixir
```elixir
defmodule ElixirExample do

  def simple_function(number) do
    number + number
  end

end
```
\\\\\\\\\\\
---
type: fork
paths:
  - pipeline
  - pattern_matching
---
## What shall we learn first?
\\\\\\\\\\\
---

---
## The `|` operator
```elixir
1 | [2, 3]
# [1, 2, 3]
[h | t] = [1, 2, 3]
# h = 1
# t = [2, 3]
```
\\\\\\\\\\\
---

---
## The `|` operator with maps
```
map = %{a: 1, b: 2}
updated = %{ map | b: 3 }
# map = %{a: 1, b: 3}
```
### Only updates, cannot add new keys
\\\\\\\\\\\
## A brief history of OOP
* Simula2
* Alan Kay
* Smalltalk
* 1970s
\\\\\\\\\\\
---

---
"I thought of objects being like biological cells and/or individual
computers on a network, only able to communicate with messages..."

"OOP to me means only messaging, local retention and protection and
hiding of state-process..."

### --Alan Kay
\\\\\\\\\\\

## Key features of OOP
* State encapsulation
* Message passing

\\\\\\\\\\\
## What isn't in here?
* Classes
* Interfaces
* Inheritance
\\\\\\\\\\\
---

---
## Processes
* Incredibly light (1k)
* No shared anything
* Communicate via message passing
\\\\\\\\\\\
## Process primitives
* spawn
* send
* receive
\\\\\\\\\\\
## Mailboxes etc
![15x11](images/process_mailboxes.png)
\\\\\\\\\\\
## OTP
* Open Telecom Platform
* Developed over 20 years of Telco systems in Erlang
* Patterns, libraries and tools
* Zero downtime, high traffic distributed systems
* Extremely large
* Not the greatest docs
\\\\\\\\\\\
## OTP in Elixir
* Implemented as behaviours
* Kind of like inheritance
* The most useful bits
* Well documented
\\\\\\\\\\\
## GenServer
Allows a module to implement a stateful server process
\\\\\\\\\\\
---

---
## State? You mean the mutable kind?
\\\\\\\\\\\
---

---
## Get a state. Return a state.
\\\\\\\\\\\
---

---
```
defmodule Stack do
  use GenServer

  # Callbacks

  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  def handle_cast({:push, item}, state) do
    {:noreply, [item | state]}
  end
end
```
\\\\\\\\\\\
---

---
```
# Start the server
{:ok, pid} = GenServer.start_link(Stack, [:hello])

# This is the client
GenServer.call(pid, :pop)
#=> :hello

GenServer.cast(pid, {:push, :world})
#=> :ok

GenServer.call(pid, :pop)
#=> :world
```
\\\\\\\\\\\
---

---
## Let's play with it.
until it breaks...
\\\\\\\\\\\
---

---
## Let it crash
\\\\\\\\\\\
---

---
## Supervisors
* Clean up the mess
* Multiple strategies
* Can form supervision trees
\\\\\\\\\\\
---

---
## OTP Applications
* A set of processes that do something
* Easy to share
* Distributed components
\\\\\\\\\\\
---

---
## Supervised Stack
```
defmodule SupervisedStack do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Stack, [])
    ]

    opts = [strategy: :one_for_one, name: :stack_supervisor]
    Supervisor.start_link(children, opts)
  end
end
```
\\\\\\\\\\\
---

---
## Introducing Venture
* You're watching it now!
* React front end
* Phoenix back end
* Slides are markdown (with YAML)
* Supports polls, forks, chat
\\\\\\\\\\\
---

---
## Phoenix
* Default web mvc framework for Elixir
* Easy to grok
* Channels
\\\\\\\\\\\
---

---
## The main processes
* Presentation
* Deck
* Selection
\\\\\\\\\\\
---

---
## Let's see it with `:observer.start`
\\\\\\\\\\\
---

---
## What happens when a user connects?
\\\\\\\\\\\
---

---
## PresentationChannel
```
  def join("presentation:attendee", _, socket ) do
    slide = Venture.Presentation.current_slide
    selections = Venture.Selections.current
    {
      :ok,
      %{slide: slide, selections: selections},
      socket
    }
  end
```
\\\\\\\\\\\
---

---
## Presentation GenServer
```elixir
  def handle_call({:current_slide}, _from, state) do
    {:reply, Deck.slide_at(state.current), state}
  end
```
\\\\\\\\\\\
---

---
## Deck GenServer
location: `%{story: "main", index: 2}`
```elixir
  def handle_call({:slide_at, location}, _from, state) do
    slide = Dict.get(state.stories, location.story, [])
            |> Enum.at(location.index)
    { :reply, slide, state }
  end
```
\\\\\\\\\\\
---

---
## What happens when the presenter advances the slide?
\\\\\\\\\\\
---

---
## PresentationChannel
```
  def handle_in("next", _, socket) do
    case Venture.Presentation.next do
      nil -> nil
      slide -> broadcast_slide! slide
    end
    {:noreply, socket}
  end
```
\\\\\\\\\\\
---

---
## PresentationServer
```
  def handle_call({:next}, _from, state) do
    current_slide = Deck.slide_at(state.current)
    case current_slide.next do
      nil -> {:reply, nil, state}
      next_slide ->
        reset_selections_for_slide(next_slide)
        {
          :reply,
          Deck.slide_at(next_slide.location),
          next_slide_state(current_slide, next_slide, state)
        }
    end
  end
```
\\\\\\\\\\\
---

---
```
  defp next_slide_state(current, next, state) do
    %{ state |
       current: next.location,
       history: [current.location | state.history] }
  end
```
\\\\\\\\\\\
---

---
## How do we design systems like this?
\\\\\\\\\\\
---

---
## Everything is ~~an object~~ a process?
\\\\\\\\\\\
---

---
## No.
\\\\\\\\\\\
---

---
## What makes a good process
* Has a Single Responsibility
* Has State
* Managing finite resources
* Concurrency
\\\\\\\\\\\
---

---
## When not to use processes
* when a POEM will do
* to avoid passing extra parameters
* to simulate [OO](https://github.com/wojtekmach/oop)
\\\\\\\\\\\
---

---
## What's not a process in Venture?
* Story
* Slide
\\\\\\\\\\\
---

---
## Questions?
\\\\\\\\\\\
