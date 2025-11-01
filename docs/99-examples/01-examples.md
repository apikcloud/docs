# Python Examples

This document lists common coding patterns with **Bad** and **Good** examples.  
Each example includes a short explanation of why the good version is preferred.


## 1. Clear variable naming

**Don't**
```python
x = 12
y = 24
z = x + y
print(z)
```

**Do**
```python
width = 12
height = 24
area = width + height
print(area)
```

**Explanation:**  
Variable names should describe intent. Readers should not have to guess what `x` means.


## 2. Avoid duplicated code

 **Don't**
```python
if status == "done":
    print("Task done")
if status == "pending":
    print("Task pending")
```

 **Do**
```python
messages = {"done": "Task done", "pending": "Task pending"}
print(messages.get(status, "Unknown"))
```

**Explanation:**  
Duplicated logic increases maintenance cost. Use data structures to centralize behavior.


## 3. Use context managers

 **Don't**
```python
file = open("data.txt", "r")
data = file.read()
file.close()
```

 **Do**
```python
with open("data.txt", "r") as file:
    data = file.read()
```

**Explanation:**  
`with` ensures the file is properly closed even if an exception occurs.


## 4. Explicit is better than implicit

 **Don't**
```python
def calc(a, b, op="+"):
    return eval(f"{a}{op}{b}")
```

 **Do**
```python
def calc(a, b, op="+"):
    if op == "+":
        return a + b
    if op == "-":
        return a - b
    raise ValueError("Unsupported operator")
```

**Explanation:**  
Avoid `eval()` and implicit behavior. Explicit logic improves readability and security.


## Rule of thumb

> Prefer **clarity over cleverness**.  
> Good code explains itself — bad code needs an interpreter.
