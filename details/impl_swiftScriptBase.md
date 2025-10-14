# Swift Script Base
- **shortcut**: `impl_swiftScriptBase`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
// MARK: - Scripting Helpers

// https://stackoverflow.com/questions/48333607/how-to-launch-an-external-process
// https://bash.0x1fff.com/na_poczatek/index.html
// How to include .swift file from other .swift file in an immediate mode?:
// https://stackoverflow.com/a/36265686/1776859
// https://stackoverflow.com/a/27437969/1776859

// https://nshipster.com/swift-sh/
// [Run swift script from Xcode iOS project as build phase](https://stackoverflow.com/a/30983482/1776859)
// [Issue: NSTask /bin/echo: /bin/echo: cannot execute binary file](https://stackoverflow.com/a/36827499/1776859)

//enum Shell {
//    /// `/usr/bin/env sh`
//    static let `default` = Env.sh
//
//    static let sh = "/usr/bin/sh"
//    static let bash = "/bin/bash"
//
//    // https://unix.stackexchange.com/q/29608
//    enum Env {
//        static let sh = "/usr/bin/env sh"
//    }
//}

struct Shell {
    /// `/usr/bin/env sh`
    static let `default` = Env.sh

    /// `/usr/bin/sh -l`
    static let sh = Shell(path: "/usr/bin/sh", args: ["-l"])

    /// `/bin/bash -l`
    static let bash = Shell(path: "/bin/bash", args: ["-l"])

    // https://unix.stackexchange.com/q/29608
    enum Env {
        /// `/usr/bin/env sh -l`
        static let sh = Shell(path: "/usr/bin/env", args: ["sh", "-l"])
    }

    let path: String
    let args: [String]
}

@discardableResult
private func startProcess(launchPath: String, arguments: [String]) -> (output: String?, exitCode: Int32) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: launchPath)
    task.arguments = arguments

    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe

    do {
        try task.run()
    } catch {
        // handle errors
        print("Error: \(error.localizedDescription)")
        return (nil, 1)
    }

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)
    task.waitUntilExit()
    
    let exitCode = task.terminationStatus
    print("Output:\n", output ?? "", "exit code:", exitCode)
    return (output, exitCode)
}

private func commandComponents(command: String) -> (path: String, args: [String])? {
    var components = command.components(separatedBy: " ")
    guard let launchPath = components.first else {
        return nil
    }
    components.removeFirst()
    return (launchPath, components)
}

/// Wrapper function for shell commands.
/// Wrapper function for shell commands.
/// Must provide full path to executable.
/// - parameter shell: executable path to the shell, can contain its arguments, default to `Shell.default`
/// - parameter arguments: command and its arguments
/// - returns: Tuple containing output and exit status
@discardableResult
func shell(shell: Shell = Shell.default, arguments: [String]) -> (output: String?, exitCode: Int32) {
    var arguments = arguments
    guard let command = arguments.first else {
        return (nil, 1)
    }
    arguments.removeFirst()

    let shellArgs = shell.args + ["-c", "which \(command)"]
    guard let (output, exitCode) = startProcess(launchPath: shell.path, arguments: shellArgs) else {
        return (nil, 1)
    }
    guard exitCode == 0 else { return exitCode }
    let commandPath = output.trimmingCharacters(in: .whitespacesAndNewlines)
    return startProcess(launchPath: command, arguments: arguments
}

@discardableResult
func shell(shell: String = Shell.default, arguments: String...) -> (output: String?, exitCode: Int32) {
    return shell(shell: shell, arguments: arguments)
}

/// Run sell command from string
///
/// Example: `shell("ls -la")`
/// - parameter shell: shell descriptior
/// - parameter command: command with parameters like `echo $PATH`, `ls -l`, etc.
func shell(shell config: Shell = Shell.default, command: String) -> (output: String?, exitCode: Int32) {
    return shell(shell: config, arguments: command.components(separatedBy: " "))
}

```