-- mustache VM
-- stack based virtual machine

local dbg = false -- set to true to output machine actions
local log = function (msg)
  if dbg then print("log: "..msg) end
end
timer = true -- to calculate time of execution


--[[ instructions :
-- PSH A -> push A to TOS
-- POP   -> pop TOS
-- ADD   -> add TOS-1 to TOS 
-- SUB   -> substitue TOS-1 to TOS
-- MUL   -> multiply TOS-1 to TOS 
-- JNP A -> jump to prg[A]
-- JNZ A -> jump to prg[A] if TOS not zero
--]]


-- instruction ptr and stack ptr
local ip, sp = 0, 0

-- the stack, a simple table
local stack = {}

-- get program table from file
local prg = {}
for l in io.lines("instructions.txt") do 
	if string.find(l,"%d") then -- if contains a number (i.e. PSH X)
		table.insert(prg, string.sub(l,1,3))
		table.insert(prg, tonumber(string.sub(l,4)))
	else
		table.insert(prg,l)
	end
end
 
-- start timer if in debug mode
local dt
if timer then dt = os.clock() end
 
-- main fetch - exec loop
while prg[ip] ~= "HLT" do
  local inst = prg[ip] -- current instruction
  
  if inst == "PSH" then
    sp = sp + 1
    ip = ip + 1
    stack[sp] = prg[ip]
    
    log("pushed "..prg[ip].." to TOS")
    
  elseif inst == "POP" then
    tmp = stack[sp]
    stack[sp] = nil
    sp = sp - 1
    
    log("poped "..tmp.." from TOS")
    
  elseif inst == "ADD" then
    -- pop TOS and store in tmp1
    tmp1 = stack[sp]
    stack[sp] = nil
    sp = sp -1
    
    -- pop TOS and store in tmp2
    tmp2 = stack[sp]
    stack[sp] = nil
    sp = sp -1
    
    -- push sum to TOS
    sp = sp + 1
    stack[sp] = tmp1 + tmp2
    
    log("added "..tmp1.." to "..tmp2.." in TOS")
    
  elseif inst == "SUB" then
    -- pop TOS and store in tmp1
    tmp1 = stack[sp]
    stack[sp] = nil
    sp = sp -1
    
    -- pop TOS and store in tmp2
    tmp2 = stack[sp]
    stack[sp] = nil
    sp = sp -1
    
    -- push substraction to TOS
    sp = sp + 1
    stack[sp] = tmp2 - tmp1
    
    log("substracted "..tmp1.." to "..tmp2.." in TOS")
    
  elseif inst == "JNZ" then
    if stack[sp] ~= 0 then
      -- set ip to branch
      ip = prg[ip+1]-1
      
      log("TOS not zero, branched to "..prg[ip+1])
    else
      log("TOS zero, continue")
    end
  end
  
  tmp1, tmp2 = nil, nil -- temp regstrs for operations
  ip = ip + 1
end

if timer then print(string.format("execution time: %.5f", os.clock()-dt)) end
print("\nfinal stack values :")
for i=1,#stack do print(i,stack[i]) end
print("final sp value : "..sp)
