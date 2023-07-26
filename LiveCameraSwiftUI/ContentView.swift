import SwiftUI


struct ContentView: View {
    @StateObject private var frameHandler = FrameHandler()
    
    var body: some View {
        MetalView(frameHandler: frameHandler)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
