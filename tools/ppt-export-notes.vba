' Export presenter notes from PowerPoint.
' From http://www.pptfaq.com/FAQ00481.htm
' To use:
' 1. Tools... Macro... Security.
' 2. Select Medium security.

Sub ExportNotesText()

    Dim oSlides As Slides
    Dim oSl As Slide
    Dim oSh As Shape
    Dim strNotesText As String
    Dim strFileName As String
    Dim intFileNum As Integer
    Dim lngReturn As Long

    ' Get a filename to store the collected text
    strFileName = InputBox("Enter the full path and name of file to extract notes text to", "Output file?")

    ' did user cancel?
    If strFileName = "" Then
        Exit Sub
    End If

    ' is the path valid?  crude but effective test:  try to create the file.
    intFileNum = FreeFile()
    On Error Resume Next
    Open strFileName For Output As intFileNum
    If Err.Number <> 0 Then     ' we have a problem
        MsgBox "Couldn't create the file: " & strFileName & vbCrLf _
            & "Please try again."
        Exit Sub
    End If
    Close #intFileNum  ' temporarily

    ' Get the notes text
    Set oSlides = ActivePresentation.Slides
    For Each oSl In oSlides
        For Each oSh In oSl.NotesPage.Shapes
        If oSh.PlaceholderFormat.Type = ppPlaceholderBody Then
            If oSh.HasTextFrame Then
                If oSh.TextFrame.HasText Then
                    strNotesText = strNotesText & "Slide: " & CStr(oSl.SlideIndex) & vbCrLf _
                    & oSh.TextFrame.TextRange.Text & vbCrLf & vbCrLf
                End If
            End If
        End If
        Next oSh
    Next oSl

    ' now write the text to file
    Open strFileName For Output As intFileNum
    Print #intFileNum, strNotesText
    Close #intFileNum

    ' show what we've done
    lngReturn = Shell("NOTEPAD.EXE " & strFileName, vbNormalFocus)

End Sub
