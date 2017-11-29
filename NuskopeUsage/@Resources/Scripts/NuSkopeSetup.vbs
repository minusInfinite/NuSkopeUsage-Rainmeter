Option Explicit

Dim wInput, fs, f, shell, wAppDir, Encrypted, Key, wToken, wTokenDetails
Const ApplicationFolder = "Rainmeter-minusInfinite"

set shell = WScript.CreateObject( "WScript.Shell" )
wAppDir = (shell.ExpandEnvironmentStrings("%APPDATA%")) & "\"& ApplicationFolder
Set fs = CreateObject ("Scripting.FileSystemObject")

If NOT fs.FolderExists(wAppDir) Then
 fs.CreateFolder(wAppDir)
End If

wToken = ""

If fs.FileExists(wAppDir & "\NuSkope-Configuration.txt") Then
  Set f = fs.OpenTextFile(wAppDir & "\NuSkope-Configuration.txt")
  wTokenDetails = f.readall
  f.close
  
  wToken = parse_item (wTokenDetails, " API Token =", "<<<")
  
End If

wToken = InputBox("Please enter your NuSkope API Token" & vbCRLF & _
                     "(Fetch this from the Members Usage Area)", "minusInfinite NuSkope Setup", wToken)

If wToken = "" Then wScript.Quit
                     

key = LCase(shell.ExpandEnvironmentStrings("%COMPUTERNAME%"))


Set f = fs.CreateTextFile(wAppDir & "\NuSkope-Configuration.txt", True)
f.writeline "Token API Name = " & wToken & " <<< Your API NuSkope Token"
f.close

Function encrypt(Str)
 
Dim Newstr, LenStr, LenKey, x

  Newstr = ""
  LenStr = Len(Str)
  LenKey = Len(Key)

  if Len(Key)<Len(Str) Then
    For x = 1 to Ceiling(LenStr/LenKey)
      Key = Key & Key
    Next
  End If

  For x = 1 To LenStr
    Newstr = Newstr & chr(Int(asc(Mid(str,x,1))) + Int(asc(Mid(key,x,1)))-20)
  Next

 encrypt = Newstr

End Function

Private Function parse_item (ByRef contents, start_tag, end_tag)

  Dim position, item
	
  position = InStr (1, contents, start_tag, vbTextCompare)
  
  If position > 0 Then
  ' Trim the html information.
    contents = mid (contents, position + len (start_tag))
    position = InStr (1, contents, end_tag, vbTextCompare)
		
    If position > 0 Then
      item = mid (contents, 1, position - 1)
    Else
      Item = ""
    End If
  Else
    item = ""
  End If

  parse_item = Trim(Item)

End Function

Private Function Ceiling(byval n)
	Dim iTmp, f
	n = cdbl(n)
	f = Floor(n)
	if f = n then
		Ceiling = n
		Exit Function
	End If
	Ceiling = cInt(f + 1)
End Function

Private Function Floor(byval n)
	Dim iTmp
	n = cdbl(n)
	iTmp = Round(n)
	if iTmp > n then iTmp = iTmp - 1
	Floor = cInt(iTmp)
End Function
