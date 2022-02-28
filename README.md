# Snackbar

Introduce the Material Design Snack Bar to iOS.


## Using

### Only Text

```swift
Snackbar.shared.showMessage(SnackbarMessage(message: "Snackbar message"),
                            presentationHostView: view)
```

### With Action

```swift
let action = SnackbarAction(title: "ACTION", handler: { })
Snackbar.shared.showMessage(SnackbarMessage(message: "Snackbar message",
                                            action: action),
                            presentationHostView: view)
```

### Styling

```swift
let style = SnackbarStyle(backgroundColor: .black, // default `#323232`
                          cornerRadius: 8, // default `4`
                          shadowColor: .black, // default `.clear`
                          shadowOpacity: 0.15, // default `0`
                          shadowOffset: .init(width: 0, height: 0), // default `.zero`  
                          shadowRadius: 15) // default `0`
let action = SnackbarAction(title: "ACTION",
                            font: .boldSystemFont(ofSize: 12), // default `.systemFont(ofSize: 14)`
                            textColor: .red, // default `.white.withAlphaComponent(0.6)`
                            handler: { })
SnackbarMessage(message: "Snackbar message",
                font: .boldSystemFont(ofSize: 14), // default `.systemFont(ofSize: 14)`
                textColor: .white, // default `.white`
                style: style,
                duration: .indefinite, // default `.long`
                action: action)
```