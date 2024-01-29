local SvgsRectangle = { };

    --// SVG  //--

function dxDrawBordRectangle(x, y, w, h, radius, color, post)
    if not SvgsRectangle[radius] then
        local Path = string.format([[
            <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/>
            </svg>
        ]], w, h, w, h, w, h, radius)
        SvgsRectangle[radius] = svgCreate(w, h, Path)
    end
    if SvgsRectangle[radius] then
        dxDrawImage(x, y, w, h, SvgsRectangle[radius], 0, 0, 0, color, post)
    end
end

    --// Number  //--

function converter(number)   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1.%2")     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end

    --// Cursor  //--

function isCursorOnElement ( x, y, w, h )
    local mx, my = getCursorPosition ()
    local fullx, fully = guiGetScreenSize ()
    cursorx, cursory = mx*fullx, my*fully
    if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
        return true
    else
        return false
   end
end

    --// Dx  //--

_dxDrawText = dxDrawText
function dxDrawText(text, x, y, w, h, ...)

    return _dxDrawText(tostring(text), x, y, (x + w), (y + h), ...)

end