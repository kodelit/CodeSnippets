# SwiftUI: body .setup() modifier methods implementations
- **shortcut**: `bodySetupMethods`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
    private func contentViewLayout(_ view: some View) -> some View {
        view
            //.frame(maxHeight: .infinity)
            //.padding(.bottom, 16)
            //.hideTabbar()
            //.containerStyle(<#...#>)
    }

    private func observers(_ view: some View) -> some View {
        view
            // .onAppear(perform: viewModel.onAppear)
            // .onReceive
            // .loadingScreen(isPresented: $viewModel.isLoading)
            //.overlayAll(
            //    isPresented: $viewModel.<#flag#>,
            //    size: .custom(375),
            //    overlay: {
            //        <#content_view#>
            //    }
            //)
    }
```