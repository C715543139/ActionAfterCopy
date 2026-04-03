#Requires AutoHotkey v2.0

; Ctrl + Alt + C to copy and transform the clipboard text before pasting.
^!c:: HandleCopyAndTransform()

HandleCopyAndTransform() {
    A_Clipboard := ""
    Send "^c"

    if !ClipWait(0.5) {
        return
    }

    if !IsTextInClipboard() {
        return
    }

    text := A_Clipboard
    A_Clipboard := TransformClipboardText(text)
}

IsTextInClipboard() {
    ; 13 = CF_UNICODETEXT
    return DllCall("IsClipboardFormatAvailable", "UInt", 13, "Int") != 0
}

TransformClipboardText(text) {
    ; Define a list of transformation operations to apply to the clipboard text.
    operations := [
        ReplaceDashWithUnderscore
    ]

    for operation in operations {
        text := operation(text)
    }

    return text
}

ReplaceDashWithUnderscore(text) {
    return StrReplace(text, "-", "_")
}
