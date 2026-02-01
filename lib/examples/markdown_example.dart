import 'package:flutter/material.dart';
import '../widgets/markdown_message.dart';

/// Example of markdown rendering with code highlighting
class MarkdownExample extends StatelessWidget {
  const MarkdownExample({super.key});

  @override
  Widget build(BuildContext context) {
    const exampleMarkdown = '''
# Goroutines in Go

A goroutine is a lightweight thread managed by the Go runtime.

## Key Features:
- Extremely lightweight (starts with ~2KB stack)
- Managed by Go runtime, not OS
- Communicates via channels

## Example Code:

```go
package main

import (
    "fmt"
    "time"
)

func sayHello() {
    fmt.Println("Hello from goroutine!")
}

func main() {
    go sayHello()  // Start goroutine
    time.Sleep(time.Second)
    fmt.Println("Main function")
}
```

You can also use anonymous functions:

```go
go func() {
    fmt.Println("Anonymous goroutine")
}()
```

## JavaScript Comparison:

```javascript
// Similar to async/await in JS
async function fetchData() {
    const response = await fetch('/api/data');
    return response.json();
}
```

> **Note:** Goroutines are much more efficient than OS threads!
''';

    return Scaffold(
      appBar: AppBar(title: const Text('Markdown Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MarkdownMessage(data: exampleMarkdown),
      ),
    );
  }
}
