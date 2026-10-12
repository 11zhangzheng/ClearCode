# Example: avoid speculative design

Request: start a local task service with in-memory storage.

Good behavior: implement the task model, service, in-memory repository, and one
executable or tested path. Use a small boundary only where storage is actually
substituted in tests.

Avoid: provider registries, dynamic plugins, abstract factories, and remote
storage configuration before any second implementation is requested.

