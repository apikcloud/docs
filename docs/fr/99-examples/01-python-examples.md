<!--
© 2025 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 01-examples
Project: aikcloud/docs
Last update: 2025-12-08
Status: Draft
Reviewer:
-->

# Exemples Python

Ce document répertorie les modèles de codage courants avec de **Mauvais** et de **Bons** exemples.<br> Chaque exemple comprend une brève explication des raisons pour lesquelles la bonne version est préférable.

## 1. Nommage clair des variables

**Ne pas faire**

```python
x = 12
y = 24
z = x + y
print(z)
```

**Faire**

```python
width = 12
height = 24
area = width + height
print(area)
```

**Explication:**<br> Les noms de variables doivent être explicites. Le lecteur ne doit pas avoir à deviner la signification de `x` .

## 2. Évitez le code dupliqué

**Ne pas faire**

```python
if status == "done":
    print("Task done")
if status == "pending":
    print("Task pending")
```

**Faire**

```python
messages = {"done": "Task done", "pending": "Task pending"}
print(messages.get(status, "Unknown"))
```

**Explication:**<br> La duplication des logiques augmente les coûts de maintenance. Utilisez des structures de données pour centraliser le comportement.

## 3. Utiliser des gestionnaires de contexte

**Ne pas faire**

```python
file = open("data.txt", "r")
data = file.read()
file.close()
```

**Faire**

```python
with open("data.txt", "r") as file:
    data = file.read()
```

**Explication:**<br> `with` garantit que le fichier est correctement fermé même en cas d'exception.

## 4. L'explicite vaut mieux que l'implicite

**Ne pas faire**

```python
def calc(a, b, op="+"):
    return eval(f"{a}{op}{b}")
```

**Faire**

```python
def calc(a, b, op="+"):
    if op == "+":
        return a + b
    if op == "-":
        return a - b
    raise ValueError("Unsupported operator")
```

**Explication:**<br> Évitez `eval()` et les comportements implicites. Une logique explicite améliore la lisibilité et la sécurité.

## Règle générale

> Privilégiez **la clarté à l'ingéniosité** .<br> Un bon code s'explique de lui-même ; un mauvais code a besoin d'un interpréteur.
