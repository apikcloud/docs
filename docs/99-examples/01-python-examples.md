<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 99-examples/01-python-examples
Project: apikcloud/docs
Last update: 2026-03-02
Status: Draft
Reviewer: 
-->

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

**Why:**  
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

**Why:**  
Duplicated logic increases maintenance cost. Use data structures to centralize behaviour.

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

**Why:**  
`with` ensures the file is properly closed even if an exception occurs.

## 4. Explicit is better than implicit

**Don't**

```python
def calculate(a, b, operator="+"):
    return eval(f"{a}{operator}{b}")
```

**Do**

```python
def calculate(a, b, operator="+"):
    if operator == "+":
        return a + b
    if operator == "-":
        return a - b
    raise ValueError("Unsupported operator")
```

**Why:**  
Avoid `eval()` and implicit behaviour. Explicit logic improves readability and security.

## 5. Always prefer early exits

**Don't**

```python
def process(data):
    res = None
    if data:
        data.process()
        res = data.result
    return res
```

**Do**

```python
def process(data):
    if not data:
        return None

    return data.process()
```

**Why:**  
Early returns reduce nesting and improve readability.

## Rule of thumb

> Prefer **clarity to cleverness**.  
> Good code explains itself — bad code needs an interpreter.
