'Version 0.1 (Nov 2017)
'Based on Kanine Bigpond Skin - https://forums.whirlpool.net.au/archive/1942079

Option Explicit

Dim Debug, FileTracking
Debug = False
FileTracking = False

Dim log_file, ItemCount, SkipFileCheck, UpdateStarted, UpdateTimeStamp, DayStart, WTempDir, Shell, wAppDir, wURLTemp
Dim contents, Item, parsed_data ()
Dim wshShell
Dim wToken, wQuota, wResetDay, wProductID

Const ForReading = 1, ForWriting = 2, ForAppending = 8 
Const ApplicationFolder = "Rainmeter-minusInfinite"
Const ColourBarYellow = "235,170,0,255", ColourBarGreen="0,175,0,255", ColourBarRed="175,0,0,255"

log_file = "NuSkope"
SkipFileCheck = False
DayStart=0

Set shell = WScript.CreateObject( "WScript.Shell" )
wAppDir = (shell.ExpandEnvironmentStrings("%APPDATA%")) & "\"& ApplicationFolder
wTempDir = (shell.ExpandEnvironmentStrings("%TEMP%")) & "\"& ApplicationFolder
Set Shell = Nothing

Private Function Get_Cache_Value (paramString, statfile)
  
  Dim fs, fp, f, fl, wshell, counter, InTime, wParam

  InTime = Now()
  wParam = LCase(Replace(paramString," ",""))

  Set fs = CreateObject ("Scripting.FileSystemObject")

  If (fs.FileExists (wTempDir & "/" & statfile & ".txt")) Then
	
    ' Don't read the file contents while the update is running
    Set f = fs.OpenTextFile (wTempDir & "/" & statfile & ".txt", ForReading)
    contents = f.readall
    f.Close
    
    If InStr(contents,"</endoffile>") > 0 Then
      item = parse_item (contents, "<" & wParam & ">", "</" & wParam & ">")
    Else
      item = "Lock or Bad Read"
    End If
 
    Set fs = Nothing
		
    contents = item

  Else
    contents = "Missing Update File - Check Updating Meter"
  End If

  Get_Cache_Value = contents

End Function

Function percent_thrumonth ()
	
  Dim resetday, startdate, enddate

  resetday = int(wResetDay)

  If resetday > Day(Now) Then
    startdate = DateAdd("m",-1,CDate(resetday & "/" & month(Now())))
    enddate = CDate(resetday & "/" & month(Now()))
  Else
    startdate = CDate(resetday & "/" & month(Now()))
    enddate = DateAdd("m",1,CDate(resetday & "/" & month(Now())))
  End If

  contents = ((Now() - startdate) / (enddate - startdate)) * 100

  percent_thrumonth = contents
	
End Function

Function percent_thrumonth_endtoday ()
	
  Dim resetday, startdate, enddate

  resetday = int(wResetDay)

  If resetday > Day(Now) Then
    startdate = DateAdd("m",-1,CDate(resetday & "/" & month(Now())))
    enddate = CDate(resetday & "/" & month(Now()))
  Else
    startdate = CDate(resetday & "/" & month(Now()))
    enddate = DateAdd("m",1,CDate(resetday & "/" & month(Now())))
  End If

  contents = (Ceiling((Now() - startdate)) / (enddate - startdate)) * 100
	
  percent_thrumonth_endtoday = contents
	
End Function

Private Function Floor(byval n)
	Dim iTmp
	n = cdbl(n)
	iTmp = Round(n)
	if iTmp > n then iTmp = iTmp - 1
	Floor = cInt(iTmp)
End Function

Function Ceiling(byval n)
	Dim iTmp, f
	n = cdbl(n)
	f = Floor(n)
	if f = n then
		Ceiling = n
		Exit Function
	End If
	Ceiling = cInt(f + 1)
End Function

Function DownloadRemaining ()

  DownloadRemaining = Get_Cache_Value("Download Remaining", log_file)

End Function

Function UploadRemaining ()

  UploadRemaining = Get_Cache_Value("Upload Remaining", log_file)

End Function

Function DownloadUsage ()

  DownloadUsage = Get_Cache_Value("Download Usage", log_file)

End Function

Function UploadUsage ()

  UploadUsage = Get_Cache_Value("Upload Usage", log_file)

End Function

Function UploadFormatted ()

  UploadsFormatted = Get_Cache_Value("Upload Usage Formatted", log_file)

End Function

Function TodaysDownloadUsage ()

  TodaysDownloadUsage = Get_Cache_Value("Todays Download Usage", log_file)
  
End Function

Function TodaysUploadUsage ()

  TodaysUploadUsage = Get_Cache_Value("Todays Upload Usage", log_file)

End Function

Function DownloadRemainingFormatted ()

  DownloadRemainingFormatted = Get_Cache_Value("Download Remaining Formatted", log_file)

End Function

Function UploadRemainingFormatted ()

  UploadRemainingFormatted = Get_Cache_Value("Upload Remaining Formatted", log_file)

End Function

Function Quota ()

  Quota = wQuota

End Function

Function DownloadUsagePercent ()

  If CDbl(DownloadUsage()) < CDbl(Quota()) Then
  	DownloadUsagePercent = DownloadUsage()/Quota()*100
  Else
    DownloadUsagePercent = 100
  End If

End Function

Function UploadUsagePercent ()

  If CDbl(UploadUsage()) < CDbl(Quota()) Then
  	UploadUsagePercent = UploadUsage()/Quota()*100
  Else
    UploadUsagePercent = 100
  End If

End Function

Function DownloadToday ()

  DownloadToday = (Quota() * (percent_thrumonth_endtoday ()/100)) - DownloadUsage()

End Function

Function UploadToday ()

  UploadToday = (Quota() * (percent_thrumonth_endtoday ()/100)) - UploadUsage()

End Function

Function DownloadAveragePerDay ()

  DownloadAveragePerDay = DownloadRemaining()/Floor(ResetRemainNumeric()+1)

End Function

Function UploadAveragePerDay ()

  UploadAveragePerDay = UploadRemaining()/Floor(ResetRemainNumeric()+1)

End Function

Function ResetRemain ()

  Dim TempResult, DaystoGo, HoursToGo

  TempResult = ResetRemainNumeric()
  
  If TempResult > 2 Then
    DaysToGo = Floor(TempResult)+1
    HoursToGo = 0
  Else
    DaysToGo = Floor(TempResult)
    HoursToGo = Round((TempResult - daystogo)*24,0)
  End If
	
  If HourstoGo = 24 Then
    DaystoGo = DaystoGo + 1
    HourstoGo = 0
  End If
	
  If DaysToGo > 0 and HourstoGo > 0 Then Contents = DaysToGo & "d" & HoursToGo & "h"
  If DaysToGo = 0 and HourstoGo > 0 Then Contents = HoursToGo & "h"
  If DaysToGo > 0 and HourstoGo = 0 Then Contents = DaysToGo & "d"
  If DaysToGo = 0 and HourstoGo = 0 Then Contents = "<1h"
	
  ResetRemain = contents

End Function

Function ResetRemainNumeric ()

  Dim resetday, resetdate, TempResult, DaystoGo, HoursToGo

  resetday = Int(wResetDay)
		
  If resetday <= Day(Now) Then
    resetdate = DateAdd("m",1,CDate(resetday & "/" & month(Now())))
  Else
    resetdate = CDate(resetday & "/" & month(Now()))
  End If
			
  'contents = DateDiff("D", Date(), resetdate)
  contents = resetdate - Now()
	
  ResetRemainNumeric = contents

End Function

Function DownloadAverageDaysToGo ()
  
  DownloadAverageDaysToGo = FormatNumber(Round(DownloadAveragePerDay()),0) & "GB/day " & ResetRemain() & " to go" 

End Function

Function UploadAverageDaysToGo ()
  
  UploadAverageDaysToGo = FormatNumber(Round(UploadAveragePerDay()),0) & "GB/day " & ResetRemain() & " to go" 

End Function

Function LastUpdate ()
  
  LastUpdate = Get_Cache_Value("Usage Updated", log_file)

End Function

Function UpdateStats ()

  Dim wxml, wxmlUsage, fs, f, wURL, wSendParams, wCookie, wHeaders, InTime, wUserDetails, NewFormat, objShell, wEtag
 
  InTime = Now()
  UpdateStarted = Now()
  UpdateTimeStamp = Year(UpdateStarted) & "-" & Month(UpdateStarted) & "-" & Day(UpdateStarted)
  NewFormat = False
  Set fs = CreateObject ("Scripting.FileSystemObject")

  If NOT (fs.FolderExists(wTempDir)) Then fs.CreateFolder(wTempDir)

  If NOT (fs.FolderExists(wAppDir) AND _
          fs.FileExists(wAppDir & "\" & log_file & "-Configuration.txt")) Then
    Set objShell = CreateObject("WScript.Shell")
    objShell.run("NuSkopeSetup.vbs")
    Set objShell = Nothing
    wScript.Quit
  End If
  
  Set f = fs.OpenTextFile(wAppDir & "\" & log_file & "-Configuration.txt")
  wUserDetails = f.readall
  f.close

  wToken = parse_item (wUserDetails, "Token API Name =", "<<<")
  
  Set f = fs.CreateTextFile(log_file & "-Updating.txt", True)
  f.write "NuSkope Meter is Updating"
  f.close

  Set wxml = CreateObject("MSXML2.ServerXMLHTTP.6.0")

  wURL = "https://api.nuskope.com.au/usage/?Token=" & wToken
  
  On Error Resume Next
      
  wxml.Open "GET", wURL, False
  wxml.send
  
  If  Err.Number <> 0 Then
    RaiseException "Load Daily Usage Page Response - " & wurl, Err.Number, Err.Description
  End If
  On Error GoTo 0

  contents = wxml.ResponseText
  
  If FileTracking Then
    Set f = fs.CreateTextFile (log_file & "Usage-" & UpdateTimeStamp & ".html", True)
    f.write (wURL & vbCRLF & contents )
    f.close
  End If

  ' Write out NuSkope Usage to a File
  Set f = fs.CreateTextFile (wTempDir & "\" & log_file & ".html", True)
  f.write contents
  f.close

  If InStr (1, contents, "}}", vbTextCompare) > 0 Then
    Set f = Nothing
    Set wxml = Nothing
    UpdateStats = parse_html("NewFormat")
  Else

    RaiseException "Bad Read - " & wurl, "K9-1", "Check File: " & wTempDir & "\" & log_file & ".html"

  End If
  
  Set fs = Nothing

End Function

Private Function parse_html (filetype)

  Dim fs, fp, f, parsed_data, contents, index

  Set fs = CreateObject ("Scripting.FileSystemObject")
	
  If (fs.FileExists (wTempDir & "\" & log_file & ".html")) Then
	
    Set fp = fs.GetFile (wTempDir & "\" & log_file & ".html")
    Set f = fp.OpenAsTextStream (1, -2)

    contents = f.readall
    f.Close
	
    Set fp = Nothing
    Set fs = Nothing
    Set f = Nothing
		
    If filetype = "Usage" Then parsed_data = parse_usage_data (contents)
    If filetype = "NewFormat" Then parsed_data = parse_usage_data_newformat (contents)

    contents = parsed_data (0)
	
    For index = 1 To Ubound (parsed_data)
      contents = contents & vbCrLf & parsed_data (index)
    Next
		
    ' Rewrite the parsed file contents
    Set fs = CreateObject ("Scripting.FileSystemObject")
    Set f = fs.CreateTextFile (wTempDir & "\" & log_file & ".txt", True)
    f.write (contents)
    f.close
    If fs.FileExists(log_file & "-errors.txt") Then fs.DeleteFile(log_file & "-errors.txt") 
    If fs.FileExists(log_file & "-Updating.txt") Then fs.DeleteFile(log_file & "-Updating.txt") 
    Set f = Nothing
    Set fs = Nothing
		
    contents = parsed_data (0)
  
  Else
    contents = "No Data"
  End If
	
  parse_html = contents

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
      Item = "Invalid Data"
    End If
  Else
    item = "Invalid Data"
  End If

  parse_item = Trim(Item)

End Function

Private Sub AddItem (Element, NewItem)

  itemCount = itemCount + 1
  ReDim Preserve parsed_data (itemCount)
  
  NewItem = Replace(NewItem,Chr(10)," ")
  NewItem = Replace(NewItem,Chr(13)," ")
  NewItem = Replace(NewItem,Chr(34)," ")
  NewItem = Replace(NewItem,"  "," ")
  NewItem = Replace(NewItem,"  "," ")
  NewItem = Replace(NewItem,"  "," ")
  NewItem = Replace(NewItem,Chr(9)," ")
  NewItem = Trim(NewItem)
  
  parsed_data (itemCount) = "<" & lcase(Replace(Element," ","")) & ">" & NewItem & "</" & lcase(Replace(Element," ","")) & ">"

End Sub

Private Function parse_usage_data_newformat (ByRef contents)

  Dim wDownload, wTotalsStartPos, wStartPos, wTempContent, wRatedUwsage, wNuSkopeDate, wTodayDate
  Dim wTodayDownload, wTodayUpload, wUpload, f, fs, wJunk, wResetDate, tempDate

  Set fs = CreateObject ("Scripting.FileSystemObject")

  AddItem "Usage Updated", UpdateStarted

  'Grab Total Usage and Quota

  wResetDate = parse_item (contents, "LastReset"":",",")
  wQuota = parse_item (contents, "PlanQuotaGB"":",",")
  wUpload = parse_item (contents, "UploadsGB"":",",")
  wDownload = parse_item (contents, "DownloadsGB"":",",")

  'Todays Information

  wTodayUpload = parse_item (contents, "UploadsGB"":",",")
  wTodayDownload = parse_item (contents, "DownloadsGB"":",",")
  


  If FileTracking Then
    Set f = fs.CreateTextFile (log_file & "Dim2-" & UpdateTimeStamp & ".html", True)
    f.write ( wResetDate & vbCRLF & wQuota & vbCRLF & wUpload & vbCRLF &  wDownload & vbCRLF & wTodayDownload & vbCRLF & wTodayUpload & vbCRLF & contents )
    f.close
  End If

  wResetDate = Replace(wResetDate,Chr(34)," ")
  AddItem "Todays Download Usage", wTodayDownload
  AddItem "Todays Upload Usage", wTodayUpload

  tempDate = CDate(wResetDate)
  
  wResetDay = Day(tempDate)
  
  AddItem "Reset Date", wResetDay
  AddItem "Quota", wQuota
  AddItem "Upload Usage", wUpload
  AddItem "Download Usage", wDownload
  AddItem "Download Remaining", CDbl(wQuota) - CDbl(wDownload)
  AddItem "Upload Remaining", CDbl(wQuota) - CDbl(wUpload)
  AddItem "End of File", Now()

  parse_usage_data_newformat = parsed_data

End Function

Sub RaiseException (pErrorSection, pErrorCode, pErrorMessage)

    Dim errfs, errf, errContent
    
    Set errfs = CreateObject ("Scripting.FileSystemObject")
    Set errf = errfs.CreateTextFile(log_file & "-errors.txt", True)
    
    errContent = Now() & vbCRLF & vbCRLF & _
                 pErrorSection & vbCRLF & _
                 "Error Code: " & pErrorCode & vbCRLF & _
                 "--------------------------------------" & vbCRLF & _
                 pErrorMessage
    errf.write errContent
    errf.close
    
    If FileTracking Then
      Set errf = errfs.CreateTextFile (log_file & "-errors-" & UpdateTimeStamp & ".txt", True)
      errf.write errContent
      errf.close
    End If

    Set errf = Nothing
    
    If errfs.FileExists(log_file & "-Updating.txt") Then errfs.DeleteFile(log_file & "-Updating.txt") 

    Set errfs = Nothing
    
    WScript.Quit

End Sub

Function Decrypt(Str)

  Dim Key, NewStr, LenStr, LenKey, wsh, x
   
  set wsh = WScript.CreateObject( "WScript.Shell" )
  key = LCase(wsh.ExpandEnvironmentStrings("%COMPUTERNAME%"))

  Newstr = ""
  LenStr = Len(Str)
  LenKey = Len(Key)

  if Len(Key)<Len(Str) Then
    For x = 1 to Ceiling(LenStr/LenKey)
      Key = Key & Key
    Next
  End If

  For x = 1 To LenStr
    Newstr = Newstr & chr(Int(asc(Mid(str,x,1))) + 20 - Int(asc(Mid(key,x,1))))
  Next

 Decrypt = Newstr

End Function

Function MyLPad (MyValue, MyPadChar, MyPaddedLength) 
  MyLpad = String(MyPaddedLength - Len(MyValue), MyPadChar) & MyValue 
End Function

Private Function FormatCalc (paramString, wMeasure)

  wRegExp = wRegExp & "<" & paramString & ">(.*)" & "</" & paramString & ">.*"
  
  wMeasureDefs = wMeasureDefs & "[Measure" & paramString & "]" & vbCRLF
  wMeasureDefs = wMeasureDefs & "Measure=Plugin" & vbCRLF
  wMeasureDefs = wMeasureDefs & "Plugin=Plugins\WebParser.dll" & vbCRLF
  wMeasureDefs = wMeasureDefs & "Url=[MeasureNuSkope]" & vbCRLF
  wMeasureDefs = wMeasureDefs & "StringIndex=" & wMeasureIdx & vbCRLF
  If InStr(LCase(paramString),"percent") > 0 Then wMeasureDefs = wMeasureDefs & "MaxValue=100" & vbCRLF
  If InStr(LCase(paramString),"pct") > 0 Then wMeasureDefs = wMeasureDefs & "MaxValue=100" & vbCRLF
  wMeasureDefs = wMeasureDefs & vbCRLF
  wMeasureIdx = wMeasureIdx + 1

  FormatCalc = "<" & paramString & ">" & wMeasure & "</" & paramString & ">"

End Function

Dim fs, f, wResponse
Dim wRegExp, wMeasureDefs, GenerateMeasureSection, wMeasureIdx
    
wResponse = UpdateStats()
   
If wResponse = "Fetch Failed" Then RaiseException "Fetch", "KP-1", "Check Setup"
    
GenerateMeasureSection = False
   
Set fs = CreateObject ("Scripting.FileSystemObject")
Set f = fs.CreateTextFile (log_file & "-calculations.txt", True)

f.writeline FormatCalc("Quota",Quota)
f.writeline FormatCalc("QuotaFormatted",FormatNumber(Quota,0) & " GB")
f.writeline FormatCalc("DownloadUsage",DownloadUsage)
f.writeline FormatCalc("DownloadUsageFormatted",FormatNumber(DownloadUsage,0) & " GB")
f.writeline FormatCalc("UploadUsage",UploadUsage)
f.writeline FormatCalc("UploadUsageFormatted",FormatNumber(UploadUsage,0) & " GB")
f.writeline FormatCalc("DownloadUsagePercent",Round(DownloadUsagePercent,2))
f.writeline FormatCalc("UploadUsagePercent",Round(UploadUsagePercent,2))
f.writeline FormatCalc("DownloadRemaining",DownloadRemaining)
f.writeline FormatCalc("DownloadRemainingFormatted",FormatNumber(DownloadRemaining,0) & " GB")
f.writeline FormatCalc("UploadRemaining",UploadRemaining)
f.writeline FormatCalc("UploadRemainingFormatted",FormatNumber(UploadRemaining,0) & " GB")
f.writeline FormatCalc("ResetRemainNumeric",Round(ResetRemainNumeric,2))
f.writeline FormatCalc("ResetRemain",ResetRemain)
f.writeline FormatCalc("percent_thrumonth",Round(percent_thrumonth,2))
f.writeline FormatCalc("percent_thrumonth_endtoday",Round(percent_thrumonth_endtoday,2))
f.writeline FormatCalc("DownloadToday",Round(DownloadToday,2))
f.writeline FormatCalc("DownloadTodayFormatted",FormatNumber(Round(DownloadToday,2),0) & " GB")
f.writeline FormatCalc("UploadToday",Round(UploadToday,2))
f.writeline FormatCalc("UploadTodayFormatted",FormatNumber(Round(UploadToday,2),0) & " GB")
f.writeline FormatCalc("DownloadAveragePerDay",Round(DownloadAveragePerDay,2))
f.writeline FormatCalc("UploadAveragePerDay",Round(UploadAveragePerDay,2))
f.writeline FormatCalc("DownloadAverageDaysToGo",DownloadAverageDaysToGo)
f.writeline FormatCalc("UploadAverageDaysToGo",UploadAverageDaysToGo)

If DownloadUsagePercent <= 25 Then f.writeline FormatCalc("DownloadUsageBarColour",ColourBarGreen)
If DownloadUsagePercent > 25 and DownloadUsagePercent < 70 Then f.writeline FormatCalc("DownloadUsageBarColour",ColourBarYellow)
If DownloadUsagePercent >= 70 Then f.writeline FormatCalc("DownloadUsageBarColour",ColourBarRed)

If UploadUsagePercent <= 25 Then f.writeline FormatCalc("UploadUsageBarColour",ColourBarGreen)
If UploadUsagePercent > 25 and UploadUsagePercent < 70 Then f.writeline FormatCalc("UploadUsageBarColour",ColourBarYellow)
If UploadUsagePercent >= 70 Then f.writeline FormatCalc("UploadUsageBarColour",ColourBarRed)

f.writeline FormatCalc("TodaysDownloadUsage",TodaysDownloadUsage)
f.writeline FormatCalc("TodaysDownloadUsageFormatted",FormatNumber(TodaysDownloadUsage,0) & " GB")
f.writeline FormatCalc("TodaysUploadUsage",TodaysUploadUsage)
f.writeline FormatCalc("TodaysUploadUsageFormatted",FormatNumber(TodaysUploadUsage,0) & " GB")
f.writeline FormatCalc("UsageUpdated",Now())
f.close
      
If GenerateMeasureSection Then
  Set fs = CreateObject ("Scripting.FileSystemObject")
  Set f = fs.CreateTextFile (log_file & "-measures.txt", True)
  f.WriteLine "[MeasureNuSkope]"
  f.WriteLine "Measure=Plugin"
  f.WriteLine "Plugin=Plugins\WebParser.dll"
  f.WriteLine "UpdateRate=60"
  f.WriteLine "CodePage=1252"
  f.WriteLine "Url=file://#@#Scripts\NuSkope-calculations.txt"
  f.WriteLine "RegExp=""(?siU)" & wRegExp & """"
  f.WriteLine
  f.WriteLine wMeasureDefs
  f.close
End If 
      
Set f = Nothing
Set fs = Nothing
