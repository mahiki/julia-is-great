# OOP Python Blog on Inheritance Problems
[hacker news link](https://news.ycombinator.com/item?id=31870955)
[2020 blog post about Gang of Four approach](https://python-patterns.guide/gang-of-four/composition-over-inheritance/)

## SUMMARY
I learned a lot from this OOP blog showing the subclass explosion problem with inheritance. Basically classes need for 𝘮×𝘯 classes to implement all use-cases.

[Posted to Discourse](https://discourse.julialang.org/t/oop-composition-inheritance-vs-julia-paradigm/83548)

## JULIA SOLUTION
What does this look like as a julia toy example? 

* syslog is handled by some packages Syslogs.jl/SyslogLogging.jl
* Base module Logging is designed to be composable, not getting into that
* The `log_message` function will dispatch depending on the type of the target sink

```julia
function log_message(message::String, sink::T) where {T <: AbstractPath}
    io = open(sink, "a")        # open in append mode, not truncate
    write(io, message * "\n")
    close(io)
end

function log_message(message::String, sink::TCPSocket)
    send(socket::UDPSocket, message)
end

function log_message(message::String, sink::SysLog)
    write(sink, message)
end

function message_filter(pattern::Vector{String}, message::String)
    for x in pattern
        if  occursin(x, message)
            return message
        end
    end
end
```

So base library text filtering is applied to the message before passing to log_message, there is no need for objects and methods, or for separately named methods for LogSocket LogFile, etc.

```julia
# TEST: log_message function
using FilePathsBase
msg1 = "Error: Its a bad bad problem here"
msg2 = "Warn: eh ok fine"
file = Path("./test-logger.txt")

log_message(message_filter(["Error"], msg1), file)
# or via pipe to a 
message_filter(["Warn"], msg2) |> (x -> log_message(x, file))

shell> cat test-logger.txt
    # Error: Its a bad bad problem here
    # Warn: eh ok fine
```

Looks great, exactly what I was hoping. We'll just assume socket and syslog works fine.

```julia
# TEST FILTER
filt1 = ["Error"]
filt2 = ["Error", "Warn"]
filt3 = ["Warn"]

m = [msg1, msg2]
f = [filt1, filt2, filt3]
test = collect(Base.product(f, m))

for i in test
    println(i[1], "\t\t\t", i[2])
    println(message_filter(i[1], i[2]), "\n")
end
    # Error			            Error: its bad
    # Error: its bad

    # ["Error", "Warn"]			Error: its bad
    # Error: its bad
    
    # ["Warn"]			        Error: its bad
    # nothing
    
    # Error			            Warn: eh ok
    # Warn: eh ok
    
    # ["Error", "Warn"]			Warn: eh ok
    # Warn: eh ok
    
    # ["Warn"]			        Warn: eh ok
    # Warn: eh ok

# TEST: log_message function
using FilePathsBase
msg1 = "Error: Its a bad bad problem here"
file = Path("./test-logger.txt")

log_message(message_filter(["Error"], msg1), file)

# or via pipe to a 
message_filter(["Error"], msg1) |> (x -> log_message(x, file))
```

### An issue overlooked by author
NOTE: well if we need to handle an array of error types, then excepting a single one as a string requires another function definition, becaouse the for loop splits open the string elements:

```julia
filt1 = "Error"     # the type demands a vector for this reason.
for x in filt1
    println(x)
end
E
r
r
o
r
```

So I just required the argument to be a vector of strings, which is what the python example does.


## PYTHON COMPOSITION PATTERN SOLUTION
```python
# There is now only one logger.

class Logger:
    def __init__(self, filters, handlers):
        self.filters = filters
        self.handlers = handlers

    def log(self, message):
        if all(f.match(message) for f in self.filters):
            for h in self.handlers:
                h.emit(message)

# Filters now know only about strings!

class TextFilter:
    def __init__(self, pattern):
        self.pattern = pattern

    def match(self, text):
        return self.pattern in text

# Handlers look like “loggers” did in the previous solution.

class FileHandler:
    def __init__(self, file):
        self.file = file

    def emit(self, message):
        self.file.write(message + '\n')
        self.file.flush()

class SocketHandler:
    def __init__(self, sock):
        self.sock = sock

    def emit(self, message):
        self.sock.sendall((message + '\n').encode('ascii'))

class SyslogHandler:
    def __init__(self, priority):
        self.priority = priority

    def emit(self, message):
        syslog.syslog(self.priority, message)
```


## POST TO DISCOURSE
I learned a lot about Object Oriented Programming from [this blog article from 2020 about "Gang of Four" design patterns.](https://python-patterns.guide/gang-of-four/composition-over-inheritance/). I should say that I learned about OOP long ago via a Java book but as a data professional I have never needed to know much about these things.

**How would we properly write idiomatic (non-OOP) Julia version of the solution?** The python for the blog author's preferred solution is pasted far below.

Here is my attempt in Julia to respond to the author's preferred solution to a toy implementation of Logger in python, using the "Composition over Inheritance" principle from "Design Patterns: Elements of Reusable Object-Oriented Software". Their solution avoids the explosion of subclasses problem that can happen with inheritance in OOP.

```julia
function log_message(message::String, sink::T) where {T <: AbstractPath}
    io = open(sink, "a")        # open in append mode, not truncate
    write(io, message * "\n")
    close(io)
end

function log_message(message::String, sink::TCPSocket)
    send(socket::UDPSocket, message)
end

function log_message(message::String, sink::SysLog)
    write(sink, message)
end

function message_filter(pattern::Vector{String}, message::String)
    for x in pattern
        if  occursin(x, message)
            return message
        end
    end
end

# TEST: log_message function
using FilePathsBase
msg1 = "Error: Its a bad bad problem here"
msg2 = "Warn: eh ok fine"
file = Path("./test-logger.txt")

log_message(message_filter(["Error"], msg1), file)
# or pipe the filtered message
message_filter(["Warn"], msg2) |> (x -> log_message(x, file))

shell> cat test-logger.txt
    # Error: Its a bad bad problem here
    # Warn: eh ok fine
```

#### From "Solution #4: Beyond the Gang of Four patterns", the python from the post is copied below.
This is the blog author's favored solution in python using Composition instead of Inheritance.

```python
class Logger:
    def __init__(self, filters, handlers):
        self.filters = filters
        self.handlers = handlers

    def log(self, message):
        if all(f.match(message) for f in self.filters):
            for h in self.handlers:
                h.emit(message)

# Filters now know only about strings!

class TextFilter:
    def __init__(self, pattern):
        self.pattern = pattern

    def match(self, text):
        return self.pattern in text

# Handlers look like “loggers” did in the previous solution.

class FileHandler:
    def __init__(self, file):
        self.file = file

    def emit(self, message):
        self.file.write(message + '\n')
        self.file.flush()

class SocketHandler:
    def __init__(self, sock):
        self.sock = sock

    def emit(self, message):
        self.sock.sendall((message + '\n').encode('ascii'))

class SyslogHandler:
    def __init__(self, priority):
        self.priority = priority

    def emit(self, message):
        syslog.syslog(self.priority, message)

# results
f = TextFilter('Error')
h = FileHandler(sys.stdout)
logger = Logger([f], [h])

logger.log('Ignored: this will not be logged')
logger.log('Error: this is important')
# Error: this is important
```
