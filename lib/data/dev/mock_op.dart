/// The kinds of operation a mock repository call can be, so the dev menu
/// can target latency and failure injection at a specific slice of the app
/// (e.g. "fail payments" without also breaking every plain read).
enum MockOp { read, write, payment, sync, print, auth }
