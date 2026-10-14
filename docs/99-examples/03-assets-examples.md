<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 99-examples/03-assets-examples
Project: apikcloud/docs
Last update: 2026-10-13
Status: Draft
Reviewer: 
-->

# Assets Examples

This document lists common coding patterns with **Bad** and **Good** examples.  
Each example includes a short explanation of why the good version is preferred.

## 1. JavaScript

### 1.1. Use aliases for imports

**Don't**

```javascript
import {DynamicSnippet} from "../../../../../snippets/s_dynamic_snippet/dynamic_snippet";
```

**Do**

```javascript
import {DynamicSnippet} from "@website/snippets/s_dynamic_snippet/dynamic_snippet";
```

**Why:**
Imports should be readable and consistent. It should be easy to identify dependencies. Aliases help avoid long relative
paths, reduce ambiguity between modules with similar names, and facilitate refactoring as the project structure evolves.

### 1.2. Give preference to async/await over then

**Don't**

```javascript
class AComponent extends Component {
    // Some stuff...

    loadOrders() {
        getUser()
            .then((user) => {
                return getOrders(user.id);
            })
            .then((orders) => {
                this.state.orders = orders;
            })
            .catch((error) => {
                this.handleError(error);
            });
    }
}
```

**Do**

```javascript
class AComponent extends Component {
    // Some stuff...

    async loadOrders() {
        try {
            const user = await getUser();
            const orders = await getOrders(user.id);

            this.state.orders = orders;
        } catch (error) {
            this.handleError(error);
        }
    }
}
```

**Why:**
Improve readability, simplify asynchronous control flow, and make error handling more consistent with try/catch.

## 2. SCSS

### 2.1. One file per feature

**Don't**

```
static/
├── src/
    └── scss/
        └── report.scss
```

**Do**

```
static/
├── src/
    └── scss/
        └── delivery_report.scss
        └── invoice_report.scss
        └── sale_report.scss
```

**Why:**  
SCSS is a language that quickly takes up a lot of space. The reader needs to be able to quickly find which style is
where.

### 2.2. Avoid generic names and selectors

**Don't**

```CSS
/* Would apply to all the elements of the bundle that have the o_input class. */
.o_input {
    border: none;
}

/* Would override Bootstrap. */
.btn {
    background-color: #0c4237;
}

/* Too generic: big to do what ? */
.text-big {
    font-size: 2rem;
}
```

**Do**

```CSS
.o_my_form {
    .o_my_form_title {
        /* Some styles... */
    }

    .o_my_form_input {
        /* Some styles... */
    }

    .o_my_form_button {
        /* Some styles... */
    }
}
```

**Why:**
Avoid conflicts that would override existing styles in the standard or Bootstrap. Avoid wasting a lot of time
trying to figure out why a new class isn't working as expected.
