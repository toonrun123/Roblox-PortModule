--[[

#Type 'Module'

What Port Can do?
	Any Script Can Request Function by port.

Commands:
	ports() #Look All Ports
	find(Port) #Find port.
	register(Port,PortName,Function,CustomKey) #Register Port.
	changefunction(Port,NewFunction,Key) #Change Old Function to New Function.
	request(Port,Key) #Fire Function (require Enabled Port)
	fire(Port,key) #Fire Function (require Enabled Port)
	Enabled(Port,Key) #Enabled Port.
	Disabled(Port,Key) #Disabled Port.
	
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
			CustomKey = CreateStrongKey(32)
		end
		PortList[Port] = {
			Name = PortName,
			execute = thisfunction,
			Key = CustomKey,
			Enabled = false,
		}
		return {Key = CustomKey};
	end
	return {Code = -440,Stack = "This Port Already Registed."};
end

function PortModule:changefunction(Port,Newfunction,Key)
	if PortList[Port] and rawequal(PortList[Port].Key,Key) then
		PortList[Port].execute = Newfunction
		return {Code = -000,Stack = "Success."};
	end
	return {Code = -470,Stack = "Fail Change Function."};
end

function PortModule:request(Port,Key)
	if PortList[Port] and rawequal(PortList[Port].Key,Key) and rawequal(PortList[Port].Enabled,true) then
		PortList[Port].execute()
		return {Code = 000,Stack = "Success."}; 
	else
		return {Code = -700,Stack = "Forgot Enabled port or key?"}
	end
end

function PortModule:fire(Port,Key)
	PortModule:request(Port,Key)
end


function PortModule:Enabled(Port,Key)
	if PortList[Port] and rawequal(PortList[Port].Key,Key) then
		PortList[Port].Enabled = true
		return {Code = -000,Stack = "Success."};
	end
	return {Code = -450,Stack = "Failure Connecting."};
end

function PortModule:Disabled(Port,Key)
	if PortList[Port] and rawequal(PortList[Port].Key,Key) then
		PortList[Port].Enabled = false
		return {Code = 000,Stack = "Success."};
	end
	return {Code = -450,Stack = "Failure Disconnect."};
end

return PortModule
