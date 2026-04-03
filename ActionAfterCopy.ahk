#Requires AutoHotkey v2.0

; Ctrl + Alt + C to copy and transform the clipboard text before pasting.
^!c:: HandleCopyAndTransform()
^!v:: HandlePasteAndTransform()

;;; Operations
ReplaceDashWithUnderscore(text) {
    return StrReplace(text, "-", "_")
}

RemoveCppSuffix(text) {
    return RegExReplace(text, "\.cpp$", "")
}
;;; Operations

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
    A_Clipboard := TransformTextAfterCopy(text)
}

HandlePasteAndTransform() {
    if !IsTextInClipboard() {
        Send "^v"
        return
    }

    text := A_Clipboard
    A_Clipboard := TransformTextBeforePaste(text)
    Send "^v"
}

IsTextInClipboard() {
    ; 13 = CF_UNICODETEXT
    return DllCall("IsClipboardFormatAvailable", "UInt", 13, "Int") != 0
}

TransformTextAfterCopy(text) {
    ; Define a list of transformation operations to apply to the clipboard text.
    operations := [
        ReplaceDashWithUnderscore
    ]

    for operation in operations {
        text := operation(text)
    }

    return text
}

TransformTextBeforePaste(text) {
    ; Define a list of transformation operations to apply before paste.
    operations := [
        RemoveCppSuffix
    ]

    for operation in operations {
        text := operation(text)
    }

    return text
}
