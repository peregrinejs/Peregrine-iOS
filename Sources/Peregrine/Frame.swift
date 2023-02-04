import Foundation
import SwiftUI

public protocol Frame {
    associatedtype FrameView: View

    var view: FrameView { get }
}
