--[[

What Port Can do?
	Any Script Can Request Function by port.

Commands:
	ports() #Look All Ports
	find(Port) #Find port.
	register(Port,PortName,Function,CustomKey) #Register Port.
	listen(Port,PortName,Function,CustomKey) #Register Port.
	listener(Port,PortName,thisfunction,CustomKey) #Register Port.
	changefunction(Port,NewFunction,Key) #Change Old Function to New Function.
	request(Port,Key,...(Args)) #Fire Function (require Enabled Port)
	fire(Port,key,...(Args)) #Fire Function (require Enabled Port)
	enabled(Port,Key) #Enabled Port.
	disabled(Port,Key) #Disabled Port.
	delete(Port,Key) #Delete Port.
	remove(Port,Key) #Delete Port.
	destroy(Port,Key) #Delete Port.
	getinfo(Port,Key) #Look all information Port.
	
How to use:
	1.Register Port
	2.Enabled Port
	3.That all.
	
How to Change Function Port?
	changefunction(Port,NewFunction,Key)

How to Fire Function Port?
	fire(Port,Key) or request(Port,Key)

How Can i check all ports?
	ports()
]]

local PortModule = {}

local PortList = {}

function CreateStrongKey(Length)
	local Key = ""
	for i = 1,Length do
		local utf = math.random(1,255)
		utf = utf8.char(utf)
		Key = Key..utf
	end
	return Key;
end

function PortModule:ports()
	local NameTable = {}
	for i,v in pairs(PortList) do
		NameTable[i] = {["Name"] = v.Name}
	end
	return NameTable;
end

function PortModule:find(Port)
	if rawequal(type(Port),"number") then
		return Port[Port].Name
	end
	if rawequal(type(Port),"string") then
		Port = Port
		for i,v in pairs(PortList) do
			if v.Name and rawequal(v.Name,Port) then
				return i;
			end
		end
	end
	return {Code = -202,Stack = Port.." Not in List."};
end

function PortModule:register(Port,PortName,thisfunction,CustomKey)
	if rawequal(PortList[Port],nil) then
		if rawequal(CustomKey,nil) then
			CustomKey = CreateStrongKey(64)
		end
		if type(thisfunction) ~= "function" then
			return {Code = -430,Stack = "Invaid 3 (Missing Function.)"}
		elseif rawequal(PortName,nil) then
			PortName = "PORT_"..Port
		end
		PortList[Port] = {
			Name = PortName,
			execute = thisfunction,
			Key = CustomKey,
			Enabled = false,
		}
		return 
			{
				Name = PortName,
				Key = CustomKey
			};
	end
	return {Code = -440,Stack = "This Port Already Registed."};
end

function PortModule:listen(Port,PortName,thisfunction,CustomKey)
	PortModule:register(Port,PortName,thisfunction,CustomKey)
end

function PortModule:listener(Port,PortName,thisfunction,CustomKey)
	PortModule:register(Port,PortName,thisfunction,CustomKey)
end

function PortModule:getinfo(Port,Key)
	if PortList[Port] and rawequal(PortList[Port].Key,Key) then
		return PortList[Port]
	else
		return {Code = -647,Stack = "Invaild Key."}
	end
end

function PortModule:delete(Port,Key)
	if PortList[Port] and rawequal(PortList[Port].Key,Key) then
		PortList[Port] = nil
		return {Code = 795,Stack = Port.." Removed."}
	else
		return {Code = -647,Stack = Port.." Invaild key or not found."}
	end
end

function PortModule:remove(Port,Key)
	PortModule:delete(Port,Key)
end

function PortModule:destroy(Port,Key)
	PortModule:delete(Port,Key)
end

function PortModule:changefunction(Port,Newfunction,Key)
	if PortList[Port] and rawequal(PortList[Port].Key,Key) then
		PortList[Port].execute = Newfunction
		return {Code = -000,Stack = "Success."};
	end
	return {Code = -470,Stack = "Fail Change Function."};
end

function PortModule:request(Port,Key,...)
	if PortList[Port] and rawequal(PortList[Port].Key,Key) and rawequal(PortList[Port].Enabled,true) then
		local values = { ... }
		PortList[Port].execute(table.unpack(values))
		return {Code = 000,Stack = "Success."}; 
	else
		if rawequal(PortList[Port].Enabled,false) then
			return {Code = -700,Stack = "Forgot Enabled Port."}
		else
			return {Code = -700,Stack = "Invaild Key."}
		end
	end
end

function PortModule:fire(Port,Key,...)
	PortModule:request(Port,Key,...)
end


function PortModule:enabled(Port,Key)
	if PortList[Port] and rawequal(PortList[Port].Key,Key) then
		PortList[Port].Enabled = true
		return {Code = -000,Stack = "Success."};
	end
	return {Code = -450,Stack = "Failure Connecting."};
end

function PortModule:disabled(Port,Key)
	if PortList[Port] and rawequal(PortList[Port].Key,Key) then
		PortList[Port].Enabled = false
		return {Code = 000,Stack = "Success."};
	end
	return {Code = -450,Stack = "Failure Disconnect."};
end

return PortModule
