apiRequest(2.40) -- Calling apiRequest() is mandatory.

local emuObj = getEmuObject()
local eeObj = getEEObject()
local gpr = require("ee-gpr-alias")

-- Skips an in-game cutscene, called a "seq" or "seqe" internally (presumably short for sequence).
-- By Bryan Strait

SKIP_CUTSCENE_PC					= 0x1E5AA0 --
SKIP_CUTSCENE_OPCODE				= 0xC7B40080

BEFORE_CUTSCENE_PC					= 0x1E325C --
BEFORE_CUTSCENE_OPCODE				= 0x8CA20004

SEQ_END_PC							= 0x210520 --
SEQ_END_OPCODE						= 0x3C04002F --

MPEG_END_PC							= 0x24D190 --
MPEG_END_OPCODE						= 0x8C830040

local StartAddress					= 0x02E9F35 --

local CutsceneSkipFlag = false
local AvoidCommands = { [13] = true, [10] = true}
local ValidCommands = { [59] = true, [69] = true, [82] = true } 
local LastStartValue = 0
local SkipEnabled = false
local SkipCounter = 0
local LastMpegStart = 0
local SkipTimeout = 0

-- Called at the return of a function that returns a value indicating if the next command should execute immediately.
function SkipCutscene()
	-- Normally, a sequence is like a script of events. This script is occasionally advanced. Sometimes,
	-- one script spawns another. These scripts involve two different classes: CSeq and CSeqThread.
	-- CSeqThread::UpdateSeqe handles most of the heavy lifting. It calls FIsSeqeComplete, which if it returns
	-- false causes UpdateSeqe to return. The idea here (I think) is that if the sequence is still running
	-- then we let it continue. However, if the sequence is complete, then NextSeqe is called. Presumably,
	-- if a sequence is complete then the next sequence is loaded (if there is one).
	
	-- By forcing IsSeqeComplete to return true here, we can skip some or all of a cutscene. If it always
	-- returns true, then eventually the loop will break when there is no new sequence to run. Or, if we time
	-- it right, then we can break out of the cutscene at a specific moment. Unfortunately, we can't hook in
	-- immediately after the call to IsSeqeComplete, so we have to set a flag indicating that we're in the right
	-- function, then hook in on return of IsSeqeComplete, clearing the flag after the call.
	
	if CutsceneSkipFlag == true then
		CutsceneSkipFlag = false
		
		eeObj.SetGpr(gpr.v0, 1)
		
		print("Skip")
	end
end

-- Called before the above hook, sets up a flag letting the above hook know it should fire.
function BeforeCutscenSkip()

	local start = eeObj.ReadMem8(StartAddress)
	start = start & 0x8

	if start ~= 0 and LastStartValue ~= start and SkipTimeout <= 0 then
		
		SkipEnabled = true
		SkipCounter = 0
		
	end
	LastStartValue = start
	
	if SkipTimeout > 0 then
		SkipTimeout = SkipTimeout - 1
	end
	
	if SkipEnabled then
		local command = eeObj.ReadMem8(eeObj.GetGpr(gpr.a1))
		print("Command: ", command)
	
		if eeObj.ReadMem8(eeObj.GetGpr(gpr.a1) + 4) == 0 and ValidCommands[command] ~= nil then 
			CutsceneSkipFlag = true
		end
		
		SkipCounter = SkipCounter + 1
		
		if SkipCounter >= 30 then
			SkipEnabled = false
		end
	end

end

-- Called when a sequence ends and the user regains control.
function OnSequenceEnd()
	SkipEnabled = false
	SkipCounter = 30
	LastStartValue = 0
	SkipTimeout = 10
end

-- Called when the game checks if an MPEG is complete.
function OnMpegEndCheck()
	-- Used to skip MPEG videos when the user presses start.
	
	local start = eeObj.ReadMem8(StartAddress)
	start = start & 0x8

	if start ~= 0 and LastMpegStart ~= start then
		eeObj.WriteMem8(eeObj.GetGpr(gpr.a0) + 0x40, 1)
	end
	LastMpegStart = start
	
end

-- Add hooks.
--eeAddHook(SKIP_CUTSCENE_PC, SKIP_CUTSCENE_OPCODE, SkipCutscene)
--eeAddHook(BEFORE_CUTSCENE_PC, BEFORE_CUTSCENE_OPCODE, BeforeCutscenSkip)
--eeAddHook(SEQ_END_PC, SEQ_END_OPCODE, OnSequenceEnd)
--eeAddHook(MPEG_END_PC, MPEG_END_OPCODE, OnMpegEndCheck)