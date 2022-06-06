DAT = {}

local DAT_C = util.Compress
local DAT_D = util.Decompress

local function compress(d)
	return DAT_C(d)
end

local function decompress(d)
	return DAT_D(d)
end

--====================================================================================================--
--========================================= Usable Functions =========================================--
--====================================================================================================--

/*
    Used to save a .DAT file with data

    Examples:
        1.)
            DAT.SaveData("mymodname/data/","dataname",{Apples = true, Oranges = false})
        
        2.)
            local plyID = string.gsub(ply:SteamID(),":","_")
            DAT.GetData("mymodname/data/",plyID .. "dataname",{Apples = true, Oranges = false})

        3.)
            DAT.SaveData("mymodname/data/","dataname",{Apples = true, Oranges = false},false)
*/
DAT.SaveData = function(dir,filename,data,override)
	file.CreateDir(dir)
	DAT.WriteDAT(dir .. filename .. ".dat",data,override or true)
end

/*
    Used to read a .DAT file with data

    Examples:
        1.)
            DAT.GetData("mymodname/data/","dataname")
        
        2.)
            local plyID = string.gsub(ply:SteamID(),":","_")
            DAT.GetData("mymodname/data/",plyID .. "dataname")
*/
DAT.GetData = function(dir,filename) -- DAT.GetData("mymodname/data/","dataname") or DAT.GetData("mymodname/data/","dataname.dat")
    return DAT.ReadDAT(dir .. filename .. ".dat") or false
end

--====================================================================================================--
--======================================== Internal Functions ========================================--
--====================================================================================================--

/*
    Used to write data from a .DAT file

    *** This is an internal function, recommended not to use! ***
*/
DAT.WriteDAT = function(fileName,dat,delete)
	print(fileName,"write")
	dat = DAT.LZMA(dat,true)
	if delete then
		file.Write(fileName,dat)
		return
	end
	file.Append(fileName,dat)
end

/*
    Used to read data from a .DAT file

    *** This is an internal function, recommended not to use! ***
*/
DAT.ReadDAT = function(fileName)
	print(fileName,"read")
	local data = file.Read(fileName,"DATA")
	if data == nil then return end
	local decompressed = DAT.LZMA(data)
	return (decompressed != nil && util.JSONToTable(decompressed)) or util.JSONToTable(data)
end

/*
    Used to compress/decompress data using LZMA method

    *** This is an internal function, recommended not to use! ***
*/
DAT.LZMA = function(dat,c)
	if c then
		return DAT_C(util.TableToJSON(dat,true))
	end
	return DAT_D(dat)
end