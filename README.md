# What's Port Module?
* It's You can Share Function or using function in port.

# Features
* Create Port. #Create Port.
* Remove Port.  #Remove Port.
* Secure. #Strong Key.
* And More!

# Example

## Create Port.
```lua
  local PortModule = require(Your port module location)
  
  local function this_function_connect_port()
      print("hello!")
  end
  
  local InfoPort = PortModule:register(25467,"My First Port Name",this_function_connect_port,"1023489") --Port,Port_Name,Function,CustomKey (can blank.)
  lcoal Key = InfoPort.Key
```

## Remove Port.
```lua
  local PortModule = require(Your port module location)
  
  local InfoPort = PortModule:register(25467,"My First Port Name",this_function_connect_port,"1023489") --Port,Port_Name,Function,CustomKey (can blank.)
  lcoal Key = InfoPort.Key
  
  PortModule:delete(25467,Key) --Port,Key
```
