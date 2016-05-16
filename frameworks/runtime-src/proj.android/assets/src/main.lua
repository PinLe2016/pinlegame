
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

package.path = package.path .. ";src/"
cc.FileUtils:getInstance():setPopupNotify(false)
require("app.MyApp").new():run()



function TableToString(o,n,b,t)  
    if type(b) ~= "boolean" and b ~= nil then  
        print("expected third argument %s is a boolean", tostring(b))  
    end  
    if(b==nil)then b=true end  
    t=t or 1  
    local s=""  
    if type(o) == "number" or   
        type(o) == "function" or  
        type(o) == "boolean" or  
        type(o) == "nil" then  
        s = s..tostring(o)  
    elseif type(o) == "string" then  
        s = s..string.format("%q",o)  
    elseif type(o) == "table" then  
        s = s.."{"  
        if(n)then  
            s = s.."\n"..MultiString("  ",t)  
        end  
        for k,v in pairs(o) do  
            if b then  
                s = s.."["  
            end  
  
            s = s .. TableToString(k,n, b,t+1)  
  
            if b then  
                s = s .."]"  
            end  
  
            s = s.. " = "  
            s = s.. TableToString(v,n, b,t+1)  
            s = s .. ","  
            if(n)then  
                s=s.."\n"..MultiString("  ",t)  
            end  
        end  
        s = s.."}"  
  
    end  
    return s;  
end 