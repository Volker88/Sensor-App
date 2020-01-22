

struct ChildView: View {
    var function: () -> Void

    var body: some View {
        Button(action: {
            self.function()
        }, label: {
            Text("Button")
        })
    }
}

struct ContentView: View {
    var body: some View {
        ChildView(function: { self.setViewBackToNil() })
    }

    func setViewBackToNil() {
        print("I am the parent")
    }
}
