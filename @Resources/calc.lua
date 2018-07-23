function Initialize ()
    date = dofile(SKIN:GetVariable('@') ..'date.lua')
    mhDay = SKIN:GetMeasure('MeasureResetDay')
    mhMonth = SKIN:GetMeasure('MeasureResetMonth')
    mhYear = SKIN:GetMeasure('MeasureResetYear')
    mhData = SKIN:GetMeasure('MeasureDataBlob')

end

function Update ()
    rDay = tonumber(mhDay:GetStringValue())
    rMonth = tonumber(mhMonth:GetStringValue())
    rYear = tonumber(mhYear:GetStringValue())
    jData = mhData:GetStringValue()
    dNow = date()
    rDate = date(rYear,rMonth,rDay)
    eDate = date(rYear,rMonth,rDay):addmonths(1)
    p1Date = date(rYear,rMonth,rDay):addmonths(-1)
    p2Date = date(rYear,rMonth,rDay):addmonths(-2)
    d0 = date.diff(eDate,dNow)
    d1 = date.diff(dNow,rDate)
    d2 = date.diff(dNow,p1Date)
    d3 = date.diff(dNow,p2Date)
    d4 = date.diff(eDate,p1Date)
    d0Sum = assert(math.ceil(d0:spandays()))
    d1Sum = assert(math.ceil(d1:spandays()))
    d2Sum = assert(math.ceil(d2:spandays()))
    d3Sum = assert(math.ceil(d3:spandays()))
    d4Sum = assert(math.ceil(d4:spandays()))
    ptMonth = 0
    p1Usage = 0
    p2Usage = 0
    tData = {}

    if dNow > rDate then
        ptMonth = math.ceil((d2Sum/d4Sum)*100)
    else
        ptMonth = math.ceil((d0Sum/d1Sum)*100)
    end


    SKIN:Bang('!SetOption', 'ptMonth', 'String', ptMonth)
    SKIN:Bang('!UpdateMeasure', 'ptMonth')

    SKIN:Bang('!SetOption', 'DaysRemaining', 'String', d0Sum)
    SKIN:Bang('!UpdateMeasure', 'DaysRemaining')

    --print(dNow)
    --print(eDate)
    --print(rDate)
    --print(p1Date)
    --print(p2Date)
    --print(d0Sum)
    --print(d2Sum)
    --print(d3Sum)

    editStr = string.gsub(jData, '%"%:%"', " %\=% " )
    
    --print(editStr)
    --print(string.match(testStr, "%-(%d*)-"))

    for k,v in string.gmatch(editStr, "(%w+)%s*=%s*(%d*.%d*)") do
        table.insert(tData,v)
    end

    for i  = d1Sum*3,d2Sum*3, 3 do
        local uploads = 0
        local downloads = 0 
        uploads = tonumber(uploads) + tonumber(tData[i-2])
        downloads = tonumber(downloads) + tonumber(tData[i-1])
       p1Usage = p1Usage + (uploads + downloads)
    end
    
    SKIN:Bang('!SetOption', 'p1Usage', 'String', p1Usage)
    SKIN:Bang('!UpdateMeasure', 'p1Usage')

    for i  = d2Sum*3,d3Sum*3, 3 do
        local uploads = 0
        local downloads = 0 
        uploads = tonumber(uploads) + tonumber(tData[i-2])
        downloads = tonumber(downloads) + tonumber(tData[i-1])
        p2Usage = p2Usage + (uploads + downloads)
    end
    
    SKIN:Bang('!SetOption', 'p2Usage', 'String', p2Usage)
    SKIN:Bang('!UpdateMeasure', 'p2Usage')

    SKIN:Bang('!Redraw')
    
end