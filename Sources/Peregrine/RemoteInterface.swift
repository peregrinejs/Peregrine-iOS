import Combine

/// The signature for remote functions.
public typealias RemoteFunction = (_: Call) -> Void

/// A dictionary of function names -> functions.
public typealias RemoteFunctions = [String: RemoteFunction]

/// A publisher of events.
public typealias RemoteObservable = AnyPublisher<Event?, Never>

/// A dictionary of observable names -> observables.
public typealias RemoteObservables = [String: RemoteObservable]
