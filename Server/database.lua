function initScript(res)
	if res == resource then
		dbInit()
	end
end
addEventHandler("onResourceStart", resourceRoot, initScript)

function dbInit()
	dbHandle = dbConnect("mysql", "dbname=jabkarp;host=127.0.0.1;charset=utf8", "jabka", "root")
	if dbHandle then		
		outputServerLog("[MySQL] Connection successfull")
	else
		outputServerLog("[MySQL] Connection error")
	end
end

function addDataToDataBase( table, nick, column, value ) -- обновление данных в бд с клиента
	dbExec(dbHandle, "UPDATE `?` SET ??=? WHERE nick=?", table, column, value, nick)
end

addEvent("addDataToDataBase",true)
addEventHandler("addDataToDataBase",root,addDataToDataBase)

function getDbConnection()
  if dbHandle then return dbHandle end
  dbHandle = dbConnect("mysql", "dbname=jabkarp;host=127.0.0.1;charset=utf8", "jabka", "root")
  return dbHandle
end