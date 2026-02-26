---
title: "Rust GUI Development - egui/eframe, Tauri, and Iced Comparison"
date: 2026-02-24
topic: "Rust GUI Frameworks"
category: "Development Tools"
tags: ["rust", "gui", "egui", "tauri", "iced", "eframe", "desktop-app", "cross-platform"]
status: "complete"
source: "Yuzhe Research"
type: "investigation"
---

# Rust GUI Development - Framework Comparison

**Research Date:** 2026-02-24  
**Investigation Topic:** GUI Development Options in Rust  
**Focus Areas:** egui/eframe, Tauri, Iced - Comparison and Documentation

---

## 1. Executive Summary

Rust GUI development has matured significantly, with three main approaches:

| Framework | Architecture | Best For | Learning Curve |
|-----------|--------------|----------|----------------|
| **egui/eframe** | Immediate mode | Tools, games, quick prototypes | ⭐ Easy |
| **Tauri** | Web frontend + Rust backend | Desktop apps with web tech skills | ⭐⭐ Medium |
| **Iced** | Retained mode (Elm-style) | Type-safe, structured apps | ⭐⭐⭐ Moderate |

---

## 2. egui/eframe

### What is egui?

**egui** (pronounced "e-gooey") is an **immediate mode GUI library** written in pure Rust. **eframe** is the official framework that provides the application wrapper for web and native platforms.

**Key Concept:** Immediate mode means the UI is redrawn every frame. There's no persistent widget state - you describe the UI fresh each frame.

### Architecture

```
┌─────────────────────────────────────────┐
│ Your Application Code                   │
│ (Immediate mode - redraw every frame)   │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│ egui (Core GUI library)                 │
│ - Widget definitions                    │
│ - Layout engine                         │
│ - Input handling                        │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│ eframe (Framework)                      │
│ - Platform abstraction                  │
│ - Window management                     │
│ - Rendering (wgpu/glow)                 │
└─────────────────────────────────────────┘
```

### Example Code

```rust
use eframe::egui;

fn main() -> eframe::Result {
    let options = eframe::NativeOptions::default();
    eframe::run_native(
        "My egui App",
        options,
        Box::new(|cc| Ok(Box::new(MyApp::new(cc)))),
    )
}

struct MyApp {
    name: String,
    age: u32,
}

impl eframe::App for MyApp {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        egui::CentralPanel::default().show(ctx, |ui| {
            ui.heading("My egui Application");
            ui.horizontal(|ui| {
                ui.label("Your name: ");
                ui.text_edit_singleline(&mut self.name);
            });
            ui.add(egui::Slider::new(&mut self.age, 0..=120).text("age"));
            if ui.button("Click each year").clicked() {
                self.age += 1;
            }
            ui.label(format!("Hello '{}', age {}", self.name, self.age));
        });
    }
}
```

### Features

- **Widgets:** Labels, buttons, sliders, text inputs, color pickers, spinners
- **Layouts:** Horizontal, vertical, columns, grids, automatic wrapping
- **Windows:** Movable, resizable, collapsible
- **Rendering:** Anti-aliased 2D graphics via wgpu or glow
- **Platforms:** Web (Wasm), native (Windows, macOS, Linux, Android)
- **Accessibility:** AccessKit integration for screen readers

### Pros

| Advantage | Description |
|-----------|-------------|
| ✅ **Easy to learn** | Simple API, no callbacks, intuitive |
| ✅ **Fast iteration** | Immediate feedback, easy prototyping |
| ✅ **Portable** | Same code runs on web and native |
| ✅ **Lightweight** | Minimal dependencies |
| ✅ **No callbacks** | Linear code flow, easier to reason about |
| ✅ **Safe** | No unsafe code in egui core |
| ✅ **WebAssembly** | Excellent web support |

### Cons

| Disadvantage | Description |
|--------------|-------------|
| ⚠️ **Not native-looking** | Custom styling, doesn't match OS theme |
| ⚠️ **Layout limitations** | Complex layouts can be challenging |
| ⚠️ **CPU usage** | Redraws every frame (can be optimized) |
| ⚠️ **ID management** | Need unique IDs for some widgets |
| ⚠️ **Breaking changes** | Still evolving, APIs may change |

### Best Use Cases

- **Developer tools** (debuggers, profilers, data visualization)
- **Game engines** (integrated into Bevy, macroquad, etc.)
- **Quick prototypes** and experiments
- **Scientific applications** (data plotting, simulation controls)
- **Cross-platform tools** needing web support

### Documentation Links

| Resource | URL |
|----------|-----|
| **Official Website** | https://www.egui.rs/ |
| **GitHub Repository** | https://github.com/emilk/egui |
| **Documentation** | https://docs.rs/egui |
| **Web Demo** | https://www.egui.rs/#demo |
| **Template** | https://github.com/emilk/eframe_template |
| **Chinese Docs** | https://github.com/Re-Ch-Love/egui-doc-cn |

---

## 3. Tauri

### What is Tauri?

**Tauri** is a framework for building desktop and mobile applications using **web frontend technologies** (HTML/CSS/JS) with a **Rust backend**. Think of it as a much lighter alternative to Electron.

**Key Concept:** Use web tech for UI, Rust for logic. Tauri uses the OS's native webview instead of bundling Chromium.

### Architecture

```
┌─────────────────────────────────────────┐
│ Frontend (HTML/CSS/JS/TS)               │
│ React, Vue, Svelte, vanilla JS, etc.    │
└─────────────────┬───────────────────────┘
                  │ IPC
┌─────────────────▼───────────────────────┐
│ Tauri Core (Rust)                       │
│ - Commands (Rust functions callable     │
│   from frontend)                        │
│ - State management                      │
│ - Security sandbox                      │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│ System WebView                          │
│ - macOS: WKWebView                      │
│ - Windows: WebView2                     │
│ - Linux: WebKitGTK                      │
│ - Android: System WebView               │
└─────────────────────────────────────────┘
```

### Example Code

**Frontend (JavaScript/TypeScript):**
```typescript
// Invoke Rust command from frontend
import { invoke } from '@tauri-apps/api/core';

async function greet() {
    const result = await invoke('greet', { name: 'World' });
    console.log(result); // "Hello, World!"
}
```

**Backend (Rust):**
```rust
// src-tauri/src/lib.rs
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![greet])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
```

### Features

- **Cross-platform:** Windows, macOS, Linux, iOS, Android
- **Small binaries:** ~600KB vs Electron's ~150MB
- **System webview:** Uses OS's built-in webview
- **Security:** Sandboxed by default, CSP enforced
- **Auto-updater:** Built-in update mechanism
- **Native APIs:** File system, notifications, system tray, etc.
- **Hot reload:** Development server with HMR support

### Pros

| Advantage | Description |
|-----------|-------------|
| ✅ **Tiny binaries** | 10-100x smaller than Electron |
| ✅ **Native performance** | Uses OS webview, low memory |
| ✅ **Web ecosystem** | Use React, Vue, Svelte, etc. |
| ✅ **Security-first** | Sandboxed, CSP, secure IPC |
| ✅ **Rich features** | Auto-update, tray, notifications |
| ✅ **Mobile support** | iOS and Android (Tauri 2.0) |
| ✅ **Active community** | Large ecosystem, good docs |

### Cons

| Disadvantage | Description |
|--------------|-------------|
| ⚠️ **Webview differences** | Rendering may vary across platforms |
| ⚠️ **Two languages** | Need Rust + JS/TS knowledge |
| ⚠️ **Async complexity** | IPC is async, requires handling |
| ⚠️ **Not pure Rust** | Frontend is web-based |
| ⚠️ **Native UI limitations** | Can't do true native widgets |

### Best Use Cases

- **Desktop apps** with web development skills
- **Cross-platform apps** needing web-like UI
- **Applications requiring small binary size**
- **Apps with complex UI** (using React/Vue ecosystem)
- **Teams with JavaScript/TypeScript expertise**

### Documentation Links

| Resource | URL |
|----------|-----|
| **Official Website** | https://tauri.app/ |
| **GitHub Repository** | https://github.com/tauri-apps/tauri |
| **Documentation** | https://v2.tauri.app/start/ |
| **Create App** | `npm create tauri-app@latest` |
| **Discord** | https://discord.gg/tauri |

---

## 4. Iced

### What is Iced?

**Iced** is a **cross-platform GUI library** inspired by **The Elm Architecture**. It provides a **retained mode**, type-safe, reactive programming model.

**Key Concept:** Split your UI into four parts: State, Messages, View logic, and Update logic. This creates predictable, testable applications.

### Architecture (The Elm Architecture)

```
┌─────────────────────────────────────────┐
│ State (Application State)               │
│ - The data your app needs               │
└─────────────────────────────────────────┘
        │                       ▲
        │                       │
        ▼                       │
┌─────────────────┐    ┌─────────────────┐
│ View Logic      │    │ Update Logic    │
│ - Display state │    │ - React to      │
│ - Produce       │───▶│   messages      │
│   messages      │    │ - Update state  │
└─────────────────┘    └─────────────────┘
        │                       │
        └─────────── Messages ──┘
```

### Example Code

```rust
use iced::widget::{button, column, text, Column};
use iced::{Element, Sandbox, Settings};

// 1. STATE
#[derive(Default)]
struct Counter {
    value: i32,
}

// 2. MESSAGES
#[derive(Debug, Clone, Copy)]
enum Message {
    Increment,
    Decrement,
}

// 3. VIEW LOGIC
impl Sandbox for Counter {
    type Message = Message;

    fn view(&self) -> Element<Message> {
        column![
            button("+").on_press(Message::Increment),
            text(self.value).size(50),
            button("-").on_press(Message::Decrement),
        ]
        .into()
    }

    // 4. UPDATE LOGIC
    fn update(&mut self, message: Message) {
        match message {
            Message::Increment => self.value += 1,
            Message::Decrement => self.value -= 1,
        }
    }

    fn title(&self) -> String {
        String::from("Counter - Iced")
    }
}

fn main() -> iced::Result {
    Counter::run(Settings::default())
}
```

### Features

- **Type-safe:** Leverages Rust's type system for UI
- **Reactive:** Message-driven updates
- **Cross-platform:** Windows, macOS, Linux, Web
- **Responsive layout:** Flexbox-like system
- **Built-in widgets:** Buttons, text inputs, scrollables, etc.
- **Custom widgets:** Easy to create your own
- **Debug tooling:** Time-traveling debugger
- **Async support:** First-class futures support
- **Modular:** Renderer-agnostic design

### Pros

| Advantage | Description |
|-----------|-------------|
| ✅ **Type-safe** | Compile-time UI correctness |
| ✅ **Predictable** | Elm Architecture is well-tested |
| ✅ **Testable** | Easy to unit test update logic |
| ✅ **Pure Rust** | No web technologies required |
| ✅ **Good performance** | Efficient rendering with wgpu |
| ✅ **Clean separation** | State, view, update are separate |
| ✅ **Debugging** | Time-travel debugging support |

### Cons

| Disadvantage | Description |
|--------------|-------------|
| ⚠️ **Learning curve** | Elm Architecture takes time to learn |
| ⚠️ **Experimental** | Still in development, APIs may change |
| ⚠️ **Smaller ecosystem** | Fewer widgets and integrations |
| ⚠️ **Less mature** | Not as battle-tested as egui/Tauri |
| ⚠️ **Verbosity** | More boilerplate than egui |

### Best Use Cases

- **Structured applications** with complex state
- **Type-critical** applications where safety matters
- **Teams familiar with Elm/functional programming**
- **Applications requiring testability**
- **Long-lived codebases** needing maintainability

### Documentation Links

| Resource | URL |
|----------|-----|
| **Official Website** | https://iced.rs/ |
| **GitHub Repository** | https://github.com/iced-rs/iced |
| **Book (Tutorial)** | https://book.iced.rs/ |
| **Documentation** | https://docs.rs/iced |
| **Examples** | https://github.com/iced-rs/iced/tree/master/examples |
| **Discord** | https://discord.gg/3xZJ65GAhd |
| **Zulip** | https://iced.zulipchat.com/ |

---

## 5. Comparison Matrix

### Feature Comparison

| Feature | egui/eframe | Tauri | Iced |
|---------|-------------|-------|------|
| **Architecture** | Immediate mode | Web + Rust | Retained (Elm) |
| **Language** | Pure Rust | Rust + JS/TS | Pure Rust |
| **Binary size** | Medium (~10MB) | Small (~1MB) | Medium (~10MB) |
| **Learning curve** | ⭐ Easy | ⭐⭐ Medium | ⭐⭐⭐ Moderate |
| **Native look** | ❌ Custom | ⚠️ Web-based | ❌ Custom |
| **Performance** | Good | Excellent | Good |
| **Web support** | ✅ Wasm | ✅ PWA possible | ✅ Wasm |
| **Mobile** | ⚠️ Android | ✅ iOS/Android | ❌ Desktop only |
| **Maturity** | High | High | Medium |
| **Ecosystem** | Large | Very large | Growing |
| **Debugging** | Basic | Browser DevTools | Time-travel |

### When to Choose Which

```
                    Need web skills?
                         │
            ┌────────────┼────────────┐
            │ Yes        │            │ No
            ▼            │            ▼
        ┌───────┐        │       Quick prototype
        │ Tauri │        │       or tooling?
        └───────┘        │            │
                         │     ┌──────┼──────┐
                         │     │ Yes  │      │ No
                         │     ▼      │      ▼
                         │  ┌───────┐ │  ┌───────┐
                         │  │ egui  │ │  │ Iced  │
                         │  └───────┘ │  └───────┘
                         │            │
                         │    Complex state,
                         │    need type safety?
                         │            │
                         │     ┌──────┼──────┐
                         │     │ Yes  │      │ No
                         │     ▼      │      ▼
                         │  ┌───────┐ │  ┌───────┐
                         │  │ Iced  │ │  │ egui  │
                         │  └───────┘ │  └───────┘
```

---

## 6. Other Notable Frameworks

### Slint

- **Website:** https://slint.dev/
- **Description:** Declarative UI language with Rust backend
- **Best for:** Embedded devices, professional desktop apps
- **License:** Commercial-friendly (royalty-free)

### Druid

- **Website:** https://github.com/linebender/druid
- **Description:** Data-oriented Rust GUI
- **Status:** Less active, mostly superseded by other frameworks

### Dioxus

- **Website:** https://dioxuslabs.com/
- **Description:** React-like syntax for Rust
- **Best for:** Web developers transitioning to Rust
- **Platforms:** Web, Desktop, Mobile, TUI

---

## 7. Quick Start Commands

### egui/eframe

```bash
# Clone template
git clone https://github.com/emilk/eframe_template.git my_app
cd my_app

# Run natively
cargo run

# Build for web
trunk serve
```

### Tauri

```bash
# Create new project (interactive)
npm create tauri-app@latest

# Or with specific frontend
npm create tauri-app@latest -- --template react-ts

# Run development
npm run tauri dev

# Build release
npm run tauri build
```

### Iced

```bash
# Add to Cargo.toml
cargo add iced

# Create main.rs with basic app
# (see example code above)

# Run
cargo run
```

---

## 8. Summary

### Quick Recommendations

| Your Situation | Recommendation |
|----------------|----------------|
| **Rust beginner, want quick results** | egui/eframe |
| **Web developer, want desktop app** | Tauri |
| **Experienced Rust, want type safety** | Iced |
| **Need native-looking UI** | Tauri (with native styling) |
| **Building game tools/debuggers** | egui |
| **Need smallest binary** | Tauri |
| **Complex state management** | Iced |
| **Cross-platform including mobile** | Tauri 2.0 |

### Learning Path

1. **Start with egui** if you're new to Rust GUIs
2. **Try Tauri** if you have web development experience
3. **Explore Iced** for structured, type-safe applications

---

## 9. Resources

### egui/eframe
- Website: https://www.egui.rs/
- GitHub: https://github.com/emilk/egui
- Docs: https://docs.rs/egui

### Tauri
- Website: https://tauri.app/
- GitHub: https://github.com/tauri-apps/tauri
- Docs: https://v2.tauri.app/

### Iced
- Website: https://iced.rs/
- GitHub: https://github.com/iced-rs/iced
- Book: https://book.iced.rs/

### Community
- r/rust on Reddit
- Rust Discord servers
- Framework-specific Discords/GitHub Discussions

---

*Report compiled by Yuzhe | Research Assistant*  
*Date: 2026-02-24*
