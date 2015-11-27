const baseFolderStatisticsXMLWindows = "C:/Users/altieres/Box Sync/Copy/Mestrado/Dissertacao/materialJuliaLang/statistics"
const baseFolderStatisticsXMLLinux = "/home/altieres/Copy/Mestrado/Dissertacao/materialJuliaLang/statistics"
const baseFolderStatistics = @linux?baseFolderStatisticsXMLLinux:baseFolderStatisticsXMLWindows

isdefined(:saveScenario) || include("../evacuation/load/saveScenario.jl")
function prepareScenarios(file,number, name)
	for i in 1:number
		scenario = loadAllXML(file)
		saveScenario("$baseFolderScenarios/$(name)_$i",scenario)
	end
end