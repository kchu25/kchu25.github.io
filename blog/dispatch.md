@def title = "Julia's multple dispatch"
@def published = "27 September 2025"
@def tags = ["Julia"]

## Julia's multiple dispatch

I've been using Julia for programming since graduate school, and most of the time I just "go with the flow" - never really thinking deeply about the reasons why I use Julia. It was perhaps only with a sense of nice syntax, speed, and a package management system that usually gave me much less headache compared to Python.

But recently I have more appreciation for multiple dispatch. When the codebase becomes large, naturally there will be certain behaviors that distinct groups of objects need to define. Combined with duck typing, this becomes quite powerful. For example, I can have a function that defines behavior for a primitive type and another function that defines behavior for my user-defined type. Sometimes the user-defined type resides in another package, and it can become messy and hard to maintain down the road if I want to add package dependencies to the current working package. The solution then is to define a function for the primitive type first, and let the duck typing approach specify what other packages require when they extend the behavior.

### Solution to my problem

For example, I can design the interface in my base package:
```julia
# In my base package - no external dependencies
extract_features(x::Vector{Int}) = tuple(x...)

# Duck typing fallback for any iterable with feature_index
extract_features(data) = tuple(item.feature_index for item in data)
```
The first function `extract_features(x::Vector{Int})` specializes. The second function is used for the more general "duck typing" case. This way, I do not have to make the dependency of another package -- I just have to assume the object has the required property `feature_index`. This is nice, as I now don't have to worry about the unnecessary coupling of different packages.

### It's easier to code interaction behavior among objects with multiple dispatch 

To consider the difference between single dispatch and multiple dispatch, consider Python which by default uses single dispatch. Here's an example with a `Car` class:

```
class Car:
    def drive(self, road):
        if isinstance(road, IceRoad):
            return "slipping and sliding"
        elif isinstance(road, RaceTrack):
            return "zooming at high speed"
        else:
            return "driving normally"
```

Here the `drive` method only dispatches on self (the `Car`), so I have to manually check the type of road and handle each case with isinstance checks. If I want different cars to behave differently on the same road, I'd need separate classes with their own type checking logic.

But in Julia with multiple dispatch:
```
drive(car::Car, road::IceRoad) = "slipping and sliding"
drive(car::Car, road::RaceTrack) = "zooming at high speed" 
drive(car::Car, road::Road) = "driving normally"

# Easy to add new car types without modifying existing code
drive(car::SportsCar, road::RaceTrack) = "blazing past everyone"
drive(car::Truck, road::IceRoad) = "steady with chains on"
```
This "focused" view on the interactions among different objects makes coding much more manageable in the sense that I don't have to look at each object's blueprint, which itself can be a noisy process, e.g. navigating the subroutines, create another `elif`, etc. This gives the benefit of **seeing the big picture** on the code -- the interactions among similar objects can now be concentrated altogether in a single code file. 

There are other benefits too -- like the **extensibility without modifying old code**. I can just define new methods for new types without touching anything that already works. And performance-wise, Julia compiles specialized versions for each type combination, so I avoid all the runtime type checking and branching that comes with traditional object-oriented approaches.
